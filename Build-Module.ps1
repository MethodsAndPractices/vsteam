[CmdletBinding(DefaultParameterSetName = "All")]
param(
   #output path of the build module
   [Parameter(ParameterSetName = "All")]
   [Parameter(ParameterSetName = "UnitTest")]
   [string]$outputDir = './dist',

   # Building help is skipped by default to speed your inner loop.
   # Use this flag to include building the help
   [Parameter(ParameterSetName = "All")]
   [Parameter(ParameterSetName = "UnitTest")]
   [switch]$buildHelp,

   # By default the build will not install dependencies
   [Parameter(ParameterSetName = "All")]
   [Parameter(ParameterSetName = "UnitTest")]
   [switch]$installDep,

   # built module will be imported into session
   [Parameter(ParameterSetName = "All")]
   [Parameter(ParameterSetName = "UnitTest")]
   [switch]$ipmo,

   # run the scripts with the PS script analyzer
   [Parameter(ParameterSetName = "All")]
   [Parameter(ParameterSetName = "UnitTest")]
   [switch]$analyzeScript,

   # runs the unit tests
   [Parameter(ParameterSetName = "UnitTest", Mandatory = $true)]
   [Parameter(ParameterSetName = "All")]
   [switch]$runTests,

   # can be used to filter the unit test parts that should be run
   # see also: https://github.com/pester/Pester/wiki/Invoke%E2%80%90Pester#testname-alias-name
   [Parameter(ParameterSetName = "UnitTest")]
   [string]$testName,

   # outputs the code coverage
   [Parameter(ParameterSetName = "UnitTest")]
   [switch]$codeCoverage,

   #If specified puts classes in the PSM1 file instead on dot sourcing them from a PS1. This can be helpful in development but is not used for release builds 
   [switch]$WithPublicClasses
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
   Try {
      ./gen-help.ps1
   }
   Finally {
      Pop-Location
   }
}

Write-Output 'Publishing about help files'
Copy-Item -Path ./Source/en-US -Destination "$output/" -Recurse -Force
Copy-Item -Path ./Source/VSTeam.psm1 -Destination "$output/VSTeam.psm1" -Force
if ($WithPublicClasses) {
   #If the classes are in vsteam.psm1 and the module is loaded with using rather than with import-module, 
   #then the classes are accessible from the command-line, scripts, and functions which do form part of the module
   # See https://github.com/DarqueWarrior/vsteam/pull/313#issuecomment-629644064 for more information
   #Currently the default not to do this, but it can make things easier in development, 
   #if the default changes the switch name will too and the condition will become a -not 
   Write-Output "Merging classes.ps1 into VSTeam.psm1"
   Get-Content -Path "$output/VSTeam.psm1" | Out-File -Append -FilePath "$output/vsteam.classes.ps1" -Encoding ascii 
   Copy-Item   -Path "$output/vsteam.classes.ps1" -Destination "$output/VSTeam.psm1" 
   "#empty" |  Out-File -Force -FilePath "$output/vsteam.classes.ps1" -Encoding ascii 
}


Get-Content -Path ./Source/VSTeam.psm1 | Out-File -Append -FilePath "$output/VSTeam.psm1" -Encoding ascii
<#Write-Output 'Updating Functions To Export'
$newValue = ((Get-ChildItem -Path "./Source/Public" -Filter '*.ps1').BaseName |
      ForEach-Object -Process { Write-Output "'$_'" }) -join ','
#>

$PSDsettings = Import-PowerShellDataFile -path "./Source/VSTeam.psd1"
Write-Output 'Updating Functions To Export'
$FunctionsToExport  = @()
$FunctionsToExport += $PSDsettings.FunctionsToExport.where({$_ -like "_*"})
$FunctionsToExport +=  (Get-ChildItem -Path "./Source/Public" -Filter '*.ps1').BaseName
Update-ModuleManifest -Path "$output/VSTeam.psd1" -FunctionsToExport $FunctionsToExport

Write-Output "Publish complete to $output"


# reload the just built module
if ($ipmo.IsPresent -or $runTests.IsPresent) {

   # module needs to be unloaded if present
   if ((Get-Module VSTeam)) {
      Remove-Module VSTeam
   }
   $env:testing = $true
   Import-Module "$output/VSTeam.psd1"  -Global -Force
   Set-VSTeamAlias
}

# run the unit tests with Pester
if ($runTests.IsPresent) {
   # This loads [PesterConfiguration] into scope
   Import-Module Pester

   if ($null -eq $(Get-Module -ListAvailable Pester | Where-Object Version -like '5.*')) {
      Write-Output "Installing Pester 5"
      Install-Module -Name Pester -Repository PSGallery -Force -AllowPrerelease -MinimumVersion '5.0.0-rc9' -Scope CurrentUser -AllowClobber -SkipPublisherCheck
   }

   $pesterArgs = [PesterConfiguration]::Default
   $pesterArgs.Run.Path = '.\unit'
   $pesterArgs.Output.Verbosity = "Minimal"
   $pesterArgs.TestResult.Enabled = $true
   $pesterArgs.TestResult.OutputPath = 'test-results.xml'

   if ($codeCoverage.IsPresent) {
      $pesterArgs.CodeCoverage.Enabled = $true
      $pesterArgs.CodeCoverage.OutputFormat = 'JaCoCo'
      $pesterArgs.CodeCoverage.OutputPath = "coverage.xml"
      $pesterArgs.CodeCoverage.Path = "./Source/**/*.ps1"
   }
   else {
      $pesterArgs.Run.PassThru = $false
   }

   if ($testName) {
      $pesterArgs.Filter.FullName = $testName
   }

   Invoke-Pester -Configuration $pesterArgs 
}

# Run this last so the results can be seen even if tests were also run
# if not the results scroll off and my not be in the buffer.
# run PSScriptAnalyzer
if ($analyzeScript.IsPresent) {
   Write-Output "Starting static code analysis..."
   if ($null -eq $(Get-Module -Name PSScriptAnalyzer)) {
      Install-Module -Name PSScriptAnalyzer -Repository PSGallery -Force -Scope CurrentUser
   }

   $r = Invoke-ScriptAnalyzer -Path $output -Recurse
   $r | ForEach-Object { Write-Host "##vso[task.logissue type=$($_.Severity);sourcepath=$($_.ScriptPath);linenumber=$($_.Line);columnnumber=$($_.Column);]$($_.Message)" }
   Write-Output "Static code analysis complete."
}
