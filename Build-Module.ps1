[CmdletBinding()]
param(
   [string]$outputDir = './dist',

   # Building help is skipped by default to speed your inner loop.
   # Use this flag to include building the help
   [switch]$buildHelp,

   # By default the build will not install dependencies
   [switch]$installDep,

   [switch]$ipmo
)

. ./Merge-File.ps1

if ($installDep.IsPresent) {
   # Load the psd1 file so you can read the required modules and install them
   $manifest = Import-PowerShellDataFile .\Source\VSTeam.psd1

   # Install each module
   $manifest.RequiredModules | ForEach-Object { if (-not (get-module $_ -ListAvailable)) { Write-Host "Installing $_"; Install-Module -Name $_ -Repository PSGallery -F -Scope CurrentUser } }
}

if ([System.IO.Path]::IsPathRooted($outputDir)) {
   $output = $outputDir
}
else {
   $output = Join-Path (Get-Location) $outputDir
}

Merge-File -inputFile ./Source/_functions.json -outputDir $output
Merge-File -inputFile ./Source/types/_types.json -outputDir $output
Merge-File -inputFile ./Source/Classes/_classes.json -outputDir $output
Merge-File -inputFile ./Source/formats/_formats.json -outputDir $output

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

Write-Output "Publish complete to $output"

if($ipmo.IsPresent) {
   Import-Module "$output/VSTeam.psd1" -Force
   Set-VSTeamAlias
}