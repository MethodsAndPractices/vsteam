function Merge-File {
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

.PARAMETER outputDir
The destination folder.

.EXAMPLE
PS C:\> Merge-File -InputFile .\Source\Classes\classes.json

#>
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $True)]
      [string]
      $inputFile,

      [Parameter(Mandatory = $True)]
      [string]
      $outputDir
   )

   $fullPath = $(Resolve-Path $inputFile)
   Write-Verbose "Full Path: $fullPath"

   $fileOrder = Get-Content $fullPath -Raw | ConvertFrom-Json
   Write-Output "Processing: $($fileOrder.fileType) in $fullPath"

   $workingDir = Split-Path $fullPath
   Write-Verbose "Working Directory: $workingDir"

   $output = Join-Path $outputDir $fileOrder.outputFile

   Push-Location
   Set-Location $workingDir

   try {
      $files = $()

      foreach ($file in $fileOrder.files) {
         foreach ($item in $(Get-ChildItem -Filter $file)) {
            $files += , (Resolve-Path $item.FullName)
         }
      }

      $files = $files | select-object -Unique # We don't worry about case sensitivity, because for Linux to work it needs to be cased correctly anyways

      # This makes sure the file is there and empty.
      # If the file already exisit it will be overwritten.
      $null = New-Item -ItemType file -Path $output -Force
      Write-Output "Creating: $output"

      switch ($fileOrder.fileType) {
         'formats' {
            Merge-Format $files | Add-Content $output
         }
         'types' {
            Merge-Type $files | Add-Content $output
         }
         'functions' {
            Merge-Function $files | Add-Content $output
         }
         Default {
            Merge-Class $files | Add-Content $output
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

function Merge-Format {
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
         $fileContents = Get-Content $file
         $newFileContents = ($fileContents -replace '<!--.+-->', '')
         [xml]$xml = $newFileContents

         $finalXml += $xml.Configuration.ViewDefinitions.InnerXml
      }

      $finalXml += '</ViewDefinitions></Configuration>'

      Write-Output ([xml]$finalXml).OuterXml
   }
}

function Merge-Type {
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
         $fileContents = Get-Content $file
         $newFileContents = ($fileContents -replace '<!--.+-->', '')
         [xml]$xml = $newFileContents

         $finalXml += $xml.Types.InnerXml
      }

      $finalXml += '</Types>'

      Write-Output ([xml]$finalXml).OuterXml
   }
}

function Merge-Function {
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
            $line = ($line -replace ' +$', '')
            if ($null -ne $line.Trim() -and '' -ne $line.Trim()) {
               $contents.AppendLine($line) | Out-Null
            }
         }
      }

      # Remove all trailing whitespace
      Write-Output $contents.ToString()
   }
}

function Merge-Class {
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $True)]
      [string[]]
      $files
   )

   process {
      $usingsSb = New-Object System.Text.StringBuilder
      $contents = New-Object System.Text.StringBuilder
      $usings = @()

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

         # Remove all trailing whitespace
         $newFileContents = ($newFileContents -replace ' +$', '')
         
         # This not only removes the comment but any whitespace before it.
         $newFileContents = ($newFileContents -replace ' +#.+', '')
         foreach ($line in $newFileContents) {
            if ($null -ne $line.Trim() -and '' -ne $line.Trim()) {
               $contents.AppendLine($line) | Out-Null
            }
         }
      }

      Write-Output "$($usingsSb.ToString())  $($contents.ToString())"
   }
}