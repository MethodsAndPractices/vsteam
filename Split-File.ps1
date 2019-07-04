function Split-File {
   <#
.SYNOPSIS
Takes an formats or types file and splits it into separate files.

.DESCRIPTION
The input file must be a ps1xml file of formats. A file will be created
from the Name node.

.PARAMETER InputFile
The ps1xml file to process.

.EXAMPLE
PS C:\> Split-File -InputFile .\Source\formats\builds.format.ps1xml

#>
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $True)]
      [string]
      $inputFile
   )

   [xml]$xml = Get-Content $inputFile

   foreach ($view in $xml.Configuration.ViewDefinitions.View) {
      $finalXml = '<?xml version="1.0" encoding="utf-8" ?><Configuration><ViewDefinitions>'
      $finalXml += $view.OuterXml
      $finalXml += '</ViewDefinitions></Configuration>'
      
      $output = Join-Path . "$($view.Name).ps1xml"
      # This makes sure the file is there and empty.
      # If the file already exisit it will be overwritten.
      $null = New-Item -ItemType file -Path $output -Force

      Write-Verbose $output
      $finalXml | Add-Content $output
   }
}