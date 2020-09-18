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

   # runs the integration tests
   [Parameter(ParameterSetName = "UnitTest")]
   [Parameter(ParameterSetName = "All")]
   [switch]$runIntegrationTests,

   [Parameter(ParameterSetName = "UnitTest")]
   [Parameter(ParameterSetName = "All")]
   [switch]$skipLibBuild,

   [ValidateSet('LibOnly', 'Debug', 'Release')]
   [string]$configuration = "LibOnly",

   [ValidateSet('Diagnostic', 'Detailed', 'Normal', 'Minimal', 'None', 'ErrorsOnly')]
   [string]$testOutputLevel = "ErrorsOnly"
)

function Import-Pester {
   if ($null -eq $(Get-Module -ListAvailable Pester | Where-Object Version -like '5.*')) {
      Write-Output "Installing Pester 5"
      Install-Module -Name Pester -Repository PSGallery -Force -AllowPrerelease -MinimumVersion '5.0.2' -Scope CurrentUser -AllowClobber -SkipPublisherCheck
   }

   # This loads [PesterConfiguration] into scope
   Import-Module Pester -MinimumVersion 5.0.0
}

function Start-IntegrationTests {
   [CmdletBinding(DefaultParameterSetName = "All", SupportsShouldProcess, ConfirmImpact = "High")]
   param()

   process {
      Write-Output '   Testing: Functions (integration)'

      if (-not $(Test-Path -Path './Tests/TestResults')) {
         New-Item -Path './Tests/TestResults' -ItemType Directory | Out-Null
      }

      Import-Pester

      $pesterArgs = [PesterConfiguration]::Default
      $pesterArgs.Run.Path = './Tests/integration'
      $pesterArgs.Run.Exit = $true
      $pesterArgs.TestResult.Enabled = $true
      $pesterArgs.TestResult.OutputPath = './Tests/TestResults/integrationTest-results.xml'
      $pesterArgs.Run.PassThru = $false

      if ('ErrorsOnly' -eq $testOutputLevel) {
         $pesterArgs.Output.Verbosity = 'none'
         $pesterArgs.Run.PassThru = $true
         $intTestResults = Invoke-Pester -Configuration $pesterArgs
         $intTestResults.Failed | Select-Object -ExpandProperty ErrorRecord
      }
      else {
         $pesterArgs.Output.Verbosity = $testOutputLevel
         Invoke-Pester -Configuration $pesterArgs
      }
   }
}

. ./Merge-File.ps1

if ($installDep.IsPresent -or $analyzeScript.IsPresent) {
   # Load the psd1 file so you can read the required modules and install them
   $manifest = Import-PowerShellDataFile .\Source\VSTeam.psd1

   # Install each module
   if ($manifest.RequiredModules) {
      $manifest.RequiredModules | ForEach-Object { if (-not (get-module $_ -ListAvailable)) { Write-Host "Installing $_"; Install-Module -SkipPublisherCheck -Name $_ -Repository PSGallery -F -Scope CurrentUser } }
   }
}

if ([System.IO.Path]::IsPathRooted($outputDir)) {
   $output = $outputDir
}
else {
   $output = Join-Path (Get-Location) $outputDir
}

$output = [System.IO.Path]::GetFullPath($output)

Merge-File -inputFile ./Source/types/_types.json -outputDir $output
Merge-File -inputFile ./Source/formats/_formats.json -outputDir $output
Merge-File -inputFile ./Source/_functions.json -outputDir $output

# Build the help
if ($buildHelp.IsPresent) {
   Write-Output 'Processing: External help file'
   Push-Location
   Set-Location ./.docs
   Try {
      ./gen-help.ps1
   }
   Finally {
      Pop-Location
   }
}

Write-Output 'Publishing: About help files'
Copy-Item -Path ./Source/en-US -Destination "$output/" -Recurse -Force

Write-Output 'Publishing: Manifest file'
Copy-Item -Path ./Source/VSTeam.psm1 -Destination "$output/VSTeam.psm1" -Force

Write-Output '  Updating: Functions To Export'
$newValue = ((Get-ChildItem -Path "./Source/Public" -Filter '*.ps1').BaseName |
   ForEach-Object -Process { Write-Output "'$_'" }) -join ','

(Get-Content "./Source/VSTeam.psd1") -Replace ("FunctionsToExport.+", "FunctionsToExport = ($newValue)") | Set-Content "$output/VSTeam.psd1"

if (-not $skipLibBuild.IsPresent) {
   Write-Output "  Building: C# project ($configuration config)"

   if (-not $(Test-Path -Path $output\bin)) {
      New-Item -Path $output\bin -ItemType Directory | Out-Null
   }

   $buildOutput = dotnet build --nologo --verbosity quiet --configuration $configuration | Out-String

   Copy-Item -Destination "$output\bin\vsteam-lib.dll" -Path ".\Source\Classes\bin\$configuration\netstandard2.0\vsteam-lib.dll" -Force
   Copy-Item -Destination "$output\bin\Trackyon.System.Management.Automation.Abstractions.dll" -Path ".\Source\Classes\bin\$configuration\netstandard2.0\Trackyon.System.Management.Automation.Abstractions.dll" -Force

   if (-not ($buildOutput | Select-String -Pattern 'succeeded')) {
      Write-Output $buildOutput
   }
}

Write-Output "Publishing: Complete to $output"
# run the unit tests with Pester
if ($runTests.IsPresent) {
   if (-not $skipLibBuild.IsPresent -and $configuration -ne 'LibOnly') {
      Write-Output '   Testing: C# project (unit)'
      $testOutput = dotnet test --nologo --configuration $configuration | Out-String

      if (-not ($testOutput | Select-String -Pattern 'Test Run Successful')) {
         Write-Output $testOutput
      }
   }

   Write-Output '   Testing: Functions (unit)'

   if (-not $(Test-Path -Path './Tests/TestResults')) {
      New-Item -Path './Tests/TestResults' -ItemType Directory | Out-Null
   }

   Import-Pester

   $pesterArgs = [PesterConfiguration]::Default
   $pesterArgs.Run.Path = './Tests/function'
   $pesterArgs.TestResult.Enabled = $true
   $pesterArgs.TestResult.OutputPath = './Tests/TestResults/test-results.xml'

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

   if ('ErrorsOnly' -eq $testOutputLevel) {
      $pesterArgs.Output.Verbosity = 'none'
      $pesterArgs.Run.PassThru = $true
      $unitTestResults = Invoke-Pester -Configuration $pesterArgs
      $unitTestResults.Failed | Select-Object -ExpandProperty ErrorRecord
   }
   else {
      $pesterArgs.Output.Verbosity = $testOutputLevel
      Invoke-Pester -Configuration $pesterArgs
   }
}

# reload the just built module
if ($ipmo.IsPresent -or $analyzeScript.IsPresent -or $runIntegrationTests.IsPresent) {
   # module needs to be unloaded if present
   if ((Get-Module VSTeam)) {
      Remove-Module VSTeam
   }

   Write-Host " Importing: Module"

   Import-Module "$output/VSTeam.psd1" -Force
   Set-VSTeamAlias
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

# run integration tests with Pester
if ($runIntegrationTests.IsPresent) {
   Start-IntegrationTests
}