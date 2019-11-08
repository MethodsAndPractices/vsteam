[CmdletBinding()]
param(
   [string]$outputDir = './dist',

   # Building help is skipped by default to speed your inner loop.
   # Use this flag to include building the help
   [switch]$buildHelp,

   # By default the build will not install dependencies
   [switch]$installDep,

   [switch]$ipmo,

   [switch]$analyzeScript,

   [switch]$runTests,

   [switch]$codeCoverage
)

. ./Merge-File.ps1

if ($installDep.IsPresent -or $analyzeScript.IsPresent) {
   # Load the psd1 file so you can read the required modules and install them
   $manifest = Import-PowerShellDataFile .\Source\VSTeam.psd1

   # Install each module
   if ($manifest.RequiredModules) {
      $manifest.RequiredModules | ForEach-Object { if (-not (get-module $_ -ListAvailable)) { Write-Host "Installing $_"; Install-Module -Name $_ -Repository PSGallery -F -Scope CurrentUser } }
   }
}

if ([System.IO.Path]::IsPathRooted($outputDir)) {
   $output = $outputDir
}
else {
   $output = Join-Path (Get-Location) $outputDir
}

$output = [System.IO.Path]::GetFullPath($output)

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

Write-Output 'Publishing about help files'
Copy-Item -Path ./Source/en-US -Destination "$output/" -Recurse -Force
Copy-Item -Path ./Source/VSTeam.psm1 -Destination "$output/VSTeam.psm1" -Force

Write-Output 'Updating Functions To Export'
$newValue = ((Get-ChildItem -Path "./Source/Public" -Filter '*.ps1').BaseName |
   ForEach-Object -Process { Write-Output "'$_'" }) -join ','

(Get-Content "./Source/VSTeam.psd1") -Replace ("FunctionsToExport.+", "FunctionsToExport = ($newValue)") | Set-Content "$output/VSTeam.psd1"

Write-Output "Publish complete to $output"

if ($ipmo.IsPresent -or $runTests.IsPresent) {
   Import-Module "$output/VSTeam.psd1" -Force
   Set-VSTeamAlias
}

if ($analyzeScript.IsPresent) {
   Write-Output "Starting static code analysis..."
   if ($null -eq $(Get-Module -Name PSScriptAnalyzer)) {
      Install-Module -Name PSScriptAnalyzer -Repository PSGallery -Force -Scope CurrentUser
   }

   $r = Invoke-ScriptAnalyzer -Path $output -Recurse
   $r | ForEach-Object { Write-Host "##vso[task.logissue type=$($_.Severity);sourcepath=$($_.ScriptPath);linenumber=$($_.Line);columnnumber=$($_.Column);]$($_.Message)" }
   Write-Output "Static code analysis complete."
}

if ($runTests.IsPresent) {
   if ($null -eq $(Get-Module -Name Pester)) {
      Install-Module -Name Pester -Repository PSGallery -Force -Scope CurrentUser -AllowClobber -SkipPublisherCheck
   }

   if ($codeCoverage.IsPresent) {
      Invoke-Pester -Script .\unit -CodeCoverage .\dist\*.ps1 -CodeCoverageOutputFile coverage.xml -CodeCoverageOutputFileFormat JaCoCo -Strict -OutputFile test-results.xml -OutputFormat NUnitXml -Show Fails
   }
   else {
      Invoke-Pester -Script .\unit -Strict -OutputFile test-results.xml -OutputFormat NUnitXml -passThru -Show Fails
   }
}