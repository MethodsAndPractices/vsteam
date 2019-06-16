[CmdletBinding()]
param(
   [Parameter(Mandatory = $True)]
   [string]
   $filePath
)


$fullPath = $(Resolve-Path $filePath)
Write-Verbose $(Get-Location)
Write-Verbose $filePath
Write-Verbose $fullPath

$workingDir = Split-Path $fullPath
Write-Verbose $workingDir

Push-Location
Set-Location $workingDir

try {
   $usingsSb = New-Object System.Text.StringBuilder
   $contents = New-Object System.Text.StringBuilder
   $fileOrder = Get-Content $fullPath -Raw | ConvertFrom-Json

   Write-Verbose $fileOrder

   $outputFile = Join-Path (Get-Location) $fileOrder.output

   Write-Verbose "Output File: $outputFile"

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

      # Remove move all the using statements
      $newFileContents = ($fileContents -replace 'using.+', '')
      foreach ($line in $newFileContents) {
         $contents.AppendLine($line) | Out-Null
      }
   }

   $usingsSb.ToString() | Add-Content $outputFile
   $contents.ToString() | Add-Content $outputFile
}
catch {

}
finally {
   Pop-Location
}
