[CmdletBinding()]
param(
   [Parameter(Mandatory = $True)]
   [string]$outputDir = './dist'
)

. ./Merge-Files.ps1

if ([System.IO.Path]::IsPathRooted($outputDir)) {
   $output = $outputDir
}
else {
   $output = Join-Path (Get-Location) $outputDir
}

Merge-Files -inputFile ./Source/types/_types.json -outputDir $output
Merge-Files -inputFile ./Source/Public/_public.json -outputDir $output
Merge-Files -inputFile ./Source/Classes/_classes.json -outputDir $output
Merge-Files -inputFile ./Source/formats/_formats.json -outputDir $output
Merge-Files -inputFile ./Source/Private/_private.json -outputDir $output

Copy-Item -Path ./Source/en-US -Destination "$output/" -Recurse -Force
Copy-Item -Path ./Source/VSTeam.psm1 -Destination "$output/VSTeam.psm1" -Force

$newValue = ((Get-ChildItem -Path "./Source/Public" -Filter '*.ps1').BaseName |
   ForEach-Object -Process { Write-Output "'$_'" }) -join ','

(Get-Content "./Source/VSTeam.psd1") -Replace ("FunctionsToExport.+", "FunctionsToExport = ($newValue)") |
Set-Content "$output/VSTeam.psd1"
