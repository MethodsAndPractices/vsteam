[CmdletBinding()]
param(
   [string]$outputDir = './dist',

   # Building help is skipped by default to speed your inner loop.
   # Use this flag to include building the help
   [switch]$buildHelp
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

# Build the help
if ($buildHelp.IsPresent) {
   Write-Output 'Creating help files'
   Push-Location
   Set-Location ./.docs
   ./gen-help.ps1
   Pop-Location
}

Write-Output 'Publishing help files'
Copy-Item -Path ./Source/en-US -Destination "$output/" -Recurse -Force
Copy-Item -Path ./Source/VSTeam.psm1 -Destination "$output/VSTeam.psm1" -Force

Write-Output 'Updating Functions To Export'
$newValue = ((Get-ChildItem -Path "./Source/Public" -Filter '*.ps1').BaseName |
   ForEach-Object -Process { Write-Output "'$_'" }) -join ','

(Get-Content "./Source/VSTeam.psd1") -Replace ("FunctionsToExport.+", "FunctionsToExport = ($newValue)") |
Set-Content "$output/VSTeam.psd1"

Write-Output 'Publish complete'