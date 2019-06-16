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
      if ('formats' -eq $fileOrder.fileType) {
         $files = $fileOrder.files

         if ('String' -eq $fileOrder.files.GetType().Name) {
            $files = Get-ChildItem -Filter $fileOrder.files
         }

         $finalXml = Merge-Formats $files

         ([xml]$finalXml).Save("$outputFile")
      }
      else {
         Merge-Classes $fullPath
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
      $finalXml = "<Configuration>"

      ForEach ($file in $files) {
         Write-Verbose -Message "Merging from $file"
         [xml]$xml = Get-Content $file
         $finalXml += $xml.Configuration.InnerXml
      }

      $finalXml += "</Configuration>"

      Write-Output $finalXml
   }
}

function Merge-Classes {
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $True)]
      [string]
      $fullPath
   )

   process {
      $usingsSb = New-Object System.Text.StringBuilder
      $contents = New-Object System.Text.StringBuilder
      $fileOrder = Get-Content $fullPath -Raw | ConvertFrom-Json

      $outputFile = Join-Path (Get-Location) $fileOrder.output

      $null = New-Item -ItemType file -Path $outputFile -Force

      ForEach ($file in $fileOrder.files) {
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

      Write-Output "Output File: $outputFile"
      $usingsSb.ToString() | Add-Content $outputFile
      $contents.ToString() | Add-Content $outputFile
   }
}