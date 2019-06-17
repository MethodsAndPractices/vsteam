[CmdletBinding()]
param(
   [Parameter(Mandatory = $True)]
   [string]$outputDir = './dist'
)

. ./Merge-Files.ps1

Merge-Files -inputFile ./Source/types/_types.json -outputDir $outputDir
Merge-Files -inputFile ./Source/Public/_public.json -outputDir $outputDir
Merge-Files -inputFile ./Source/Classes/_classes.json -outputDir $outputDir
Merge-Files -inputFile ./Source/formats/_formats.json -outputDir $outputDir
Merge-Files -inputFile ./Source/Private/_private.json -outputDir $outputDir

Copy-Item -Path ./Source/en-US -Destination "$outputDir/" -Recurse -Force
Copy-Item -Path ./Source/VSTeam.psm1 -Destination "$outputDir/VSTeam.psm1" -Force

$newValue = ((Get-ChildItem -Path "./Source/Public" -Filter '*.ps1').BaseName |
   ForEach-Object -Process { Write-Output "'$_'" }) -join ','

(Get-Content "./Source/VSTeam.psd1") -Replace ("FunctionsToExport.+", "FunctionsToExport = ($newValue)") |
Set-Content "$outputDir/VSTeam.psd1"
