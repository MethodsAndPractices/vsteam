function Merge-Files {
   <#
.SYNOPSIS
Combines all the files in the provided inputFile into a single file.

.DESCRIPTION
The input file must be a JSON file in the following format:
{
   output: "outputFileName.ps1",
   files: ["file1.ps1", "file2.ps1"]
}

All the files are read and any using statements removed. All the
removed using statements are collected and written at the top of the
output file. All comments will also be removed from the output file.

.PARAMETER InputFile
The JSON file to process.

.EXAMPLE
PS C:\> Merge-Files -InputFile .\Source\Classes\classes.json

#>
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $True)]
      [string]
      $inputFile
   )

   Write-Output "File to process: $inputFile"

   $fullPath = $(Resolve-Path $inputFile)
   Write-Verbose "Full Path: $fullPath"

   $fileOrder = Get-Content $fullPath -Raw | ConvertFrom-Json
   Write-Output "Processing: $($fileOrder.fileType)"

   $workingDir = Split-Path $fullPath
   Write-Verbose "Working Directory: $workingDir"

   Push-Location
   Set-Location $workingDir

   $outputFile = Join-Path (Get-Location) $fileOrder.output

   try {
      $files = $fileOrder.files

      if ('String' -eq $fileOrder.files.GetType().Name) {
         $files = Get-ChildItem -Filter $fileOrder.files
      }

      # This makes sure the file is there and empty.
      # If the file already exisit it will be overwritten.
      $null = New-Item -ItemType file -Path $outputFile -Force

      switch ($fileOrder.fileType) {
         'formats' {
            Merge-Formats $files | Add-Content $outputFile
         }
         'types' {
            Merge-Types $files | Add-Content $outputFile
         }
         'functions' {
            Merge-Functions $files | Add-Content $outputFile
         }
         Default {
            Merge-Classes $files | Add-Content $outputFile
         }
      }
   }
   catch {
      throw $_
   }
   finally {
      Pop-Location
   }
}

function Merge-Formats {
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $True)]
      [string[]]
      $files
   )

   process {
      $finalXml = '<?xml version="1.0" encoding="utf-8" ?><Configuration><ViewDefinitions>'

      ForEach ($file in $files) {
         Write-Verbose -Message "Merging from $file"
         [xml]$xml = Get-Content $file
         $finalXml += $xml.Configuration.ViewDefinitions.InnerXml
      }

      $finalXml += '</ViewDefinitions></Configuration>'

      Write-Output ([xml]$finalXml).OuterXml
   }
}

function Merge-Types {
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $True)]
      [string[]]
      $files
   )

   process {
      $finalXml = '<?xml version="1.0" encoding="utf-8" ?><Types>'

      ForEach ($file in $files) {
         Write-Verbose -Message "Merging from $file"
         [xml]$xml = Get-Content $file
         $finalXml += $xml.Types.InnerXml
      }

      $finalXml += '</Types>'

      Write-Output ([xml]$finalXml).OuterXml
   }
}

function Merge-Functions {
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $True)]
      [string[]]
      $files
   )

   process {
      $contents = New-Object System.Text.StringBuilder

      ForEach ($file in $files) {
         Write-Verbose -Message "Merging from $file"
         $fileContents = Get-Content $file

         foreach ($line in $fileContents) {
            $contents.AppendLine($line) | Out-Null
         }
      }

      Write-Verbose "Output File: $outputFile"
      Write-Output $contents.ToString()
   }
}

function Merge-Classes {
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $True)]
      [string[]]
      $files
   )

   process {
      $usingsSb = New-Object System.Text.StringBuilder
      $contents = New-Object System.Text.StringBuilder

      ForEach ($file in $files) {
         Write-Verbose -Message "Merging from $file"
         $fileContents = Get-Content $file

         # Find all the usings and save them
         $matches = $fileContents | Select-String 'using.+'

         ForEach ($m in $matches) {
            Write-Verbose "Found $($m.Line)"

            # Don't add duplicate usings
            if ($null -eq ($usings | Where-Object { $_ -eq $m.Line })) {
               $usingsSb.AppendLine($m.Line) | Out-Null
               $usings += , $m.Line
            }
         }

         # Remove move all the using statements and comments
         $newFileContents = ($fileContents -replace 'using.+', '')
         $newFileContents = ($newFileContents -replace '#.+', '')
         foreach ($line in $newFileContents) {
            if ($null -ne $line.Trim() -and '' -ne $line.Trim()) {
               $contents.AppendLine($line) | Out-Null
            }
         }
      }

      Write-Verbose "Output File: $outputFile"
      Write-Output "$($usingsSb.ToString())  $($contents.ToString())"
   }
}