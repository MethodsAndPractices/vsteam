[CmdletBinding()]
param (
   # if you want to make sure that only Linux based containers are used, since Windows based containers are not supported on your OS
   [Parameter(Mandatory = $false)]
   [switch]
   $UseLinux,

   # Open another PowerShell session to show the logs from the container
   [Switch]
   $ShowLogs
)

function Find-Numbers {
   [CmdletBinding()]
   param (
      [string] $fileToRead
   )
   
   process {
      $passed = 0
      $failed = 0
      $skipped = 0
      $not_run = 0
         
      if (Test-Path $fileToRead) {
         $a = Get-Content $fileToRead
         $myMatches = $a | Select-string "total=""([0-9]+)"""
         $passed = $myMatches.Matches[0].Groups[1].Value -as [int]

         $myMatches = $a | Select-string 'failures="([0-9]+)"'
         $failed = $myMatches.Matches[0].Groups[1].Value -as [int]

         $myMatches = $a | Select-string 'skipped="([0-9]+)"'
         $skipped = $myMatches.Matches[0].Groups[1].Value -as [int]

         $myMatches = $a | Select-string 'not-run="([0-9]+)"'
         $not_run = $myMatches.Matches[0].Groups[1].Value -as [int]
      }

      Write-Output @{
         Passed  = $passed
         Failed  = $failed
         Skipped = $skipped
         NotRun  = $not_run
      }
   }
}

function Set-DockerHost {
   <#
    .SYNOPSIS
        Switch between Windows and Linux containers. IMPORTANT: Works only for Windows based systems
   #>
   [CmdletBinding()]
   param (
      #sets the container OS
      [Parameter(Mandatory = $true)]
      [ValidateSet("Windows", "Linux")]
      [string]
      $Os
   )

   process {
      $dockerVersion = docker version --format '{{json .}}' | ConvertFrom-Json

      if ($dockerVersion.Server.Os -ne $Os ) {
         & "$env:ProgramFiles\Docker\Docker\DockerCli.exe" -SwitchDaemon
      }
      else {
         Write-Verbose "docker host is already set to $Os... ignoring command"
      }
   }
}

function Add-DockerBuild {
   <#
    .SYNOPSIS
        Create a docker build with a tag. Optionally force to rebuild the container.
   #>
   [CmdletBinding()]
   param (
      # Path to the dockerfile
      [Parameter(Mandatory = $true)]
      [string]
      $DockerFile,

      # give it a named tag. Best with repository and image name
      [Parameter(Mandatory = $true)]
      [string]
      $Tag,

      # Force the rebuild of the container
      [Switch]
      $Force
   )

   process {
      $dockerImageId = docker images -q $Tag

      # only build if image does not exist or it's forced
      # when not using force: It can't be checked if a docker file has is different from the existing image
      if ($null -eq $dockerImageId -or $Force) {
         docker build --file $DockerFile --tag $Tag .
      }
      else {
         Write-Verbose "image $Tag already exists with id $dockerImageId"
      }
   }
}

function Start-DockerVSTeamTests {
   [CmdletBinding()]
   param (
      # Name of the container to run
      [Parameter(Mandatory = $true)]
      [string]
      $Container,

      # volume mapping string
      # see: https://docs.docker.com/storage/volumes/#start-a-container-with-a-volume
      [Parameter(Mandatory = $true)]
      [string]
      $Volume,

      # default directoy when the container is started
      [Parameter(Mandatory = $true)]
      [string]
      $DefaultWorkDir,

      # Image to start
      [Parameter(Mandatory = $true)]
      [string]
      $Image,

      # choose which shell to start
      [Parameter(Mandatory = $false)]
      [ValidateSet("pwsh", "powershell")]
      [string]
      $Shell = "pwsh",

      # Use if powershell should wait for the container to exit
      [Parameter(Mandatory = $false)]
      [Switch]
      $Wait,

      # Open another powershell session to show the logs from the container
      [Parameter(Mandatory = $false)]
      [Switch]
      $FollowLogs
   )

   begin {
      # using a script block here to have syntax checking and highlightning.
      # Later it is converted to a string to start the container with it
      $pesterBuild = {
         Write-Verbose 'Deleting old results'
         # I delete from the container so that all the correct permissions
         # are granted to delete. When I tried this from outside the container
         # I did not have permissions to delete it.
         if (Test-Path '#Container#_result.xml') {
            Write-Verbose 'Deleting old results file #Container#_result.xml'
            Remove-Item '#Container#_result.xml'
         }

         .\Build-Module.ps1 -installDep
         $null = Import-Module Pester

         $pesterArgs = [PesterConfiguration]::Default
         $pesterArgs.Run.Exit = $true
         $pesterArgs.Run.Path = '.\unit'
         $pesterArgs.Run.PassThru = $false
         $pesterArgs.Output.Verbosity = 'Detailed'
         $pesterArgs.TestResult.Enabled = $true
         $pesterArgs.TestResult.OutputPath = '#Container#_result.xml'

         Invoke-Pester -Configuration $pesterArgs

         # exist with PowerShells last exist code for docker.
         # without deliverate exit code the -Wait switch could cause to wait indefinetely
         Exit $LASTEXITCODE
      }
   }

   process {

      $containerId = docker ps --all --filter name=$Container -q
      $containerIsRunning = $null -ne (docker ps --filter name=$Container -q)

      if ($containerIsRunning) {
         docker stop $containerId
      }

      if ($containerId) {
         docker rm $Container
      }

      $psCommandString = ($pesterBuild.ToString()) -replace '#Container#', $Container

      docker run `
         -dit `
         --name  $Container `
         --volume $Volume `
         -w $DefaultWorkDir `
         $Image `
         $Shell -Command $psCommandString

      if ($FollowLogs) {
         $output = (docker exec -it $Container $Shell -c '$PSVersionTable | ConvertTo-Json -Compress') -join ''
         $outputFirst = $output.IndexOf('{')
         $ouputLast = $output.LastIndexOf('}')
         $versiontable = $output.Substring($outputFirst, $ouputLast + 1 - $outputFirst) | ConvertFrom-Json
         $psVersion = "$($versiontable.PSVersion.Major).$($versiontable.PSVersion.Minor).$($versiontable.PSVersion.Patch)"

         # On Linux the logs show up in the same PowerShell window so we need it to exit 
         # On Windows new windows are opened and you want -NoExit so they stay open for you to
         # review the logs.
         $os = Get-OperatingSystem
         if ($os -ne 'Windows') {
            $argList = "-Command `"`$Host.UI.RawUI.WindowTitle = 'VSTeam Unit Tests | PowerShell $($versiontable.PSEdition) $psVersion | $($versiontable.Os)'; docker logs $Container -f`""
         }
         else {
            $argList = "-NoExit -Command `"`$Host.UI.RawUI.WindowTitle = 'VSTeam Unit Tests | PowerShell $($versiontable.PSEdition) $psVersion | $($versiontable.Os)'; docker logs $Container -f`""
         }

         Start-Process $Shell -argumentlist $argList
      }

      if ($Wait) {
         docker wait $Container
      }
   }
}

function Wait-DockerContainer {
   <#
    .SYNOPSIS
        Wait for the given containers to finish. If they don't run, then error is thrown
   #>
   [CmdletBinding()]
   param (
      # Containers to wait for
      [Parameter(Mandatory = $true)]
      [string[]]
      $Container
   )

   process {

      $exitCodes = @()

      $runningContainers = docker ps --format '{{json .}}' | ConvertFrom-Json

      $notRunningContainers = @()
      $notAllContainersRunning = $Container.Count -ne ($Container | Where-Object {

            $contains = $runningContainers.Names.Contains($_)
            if ($contains) {
               return $true
            }
            else {
               $notRunningContainers += $_
               return $false
            }

         }).Count

      if ($notAllContainersRunning) {
         Write-Error "Contains with the following names are not running: $($notRunningContainers -join ', ')"
      }
      else {

         $Container | ForEach-Object {
            $exitCode = docker wait $_

            $exitCodes += @{
               containerName = $_
               exitCode      = $exitCode
            }
         }
      }

      return $exitCodes
   }
}

$platform = Get-OperatingSystem

$scriptPath = $PSScriptRoot
$rootDir = (Resolve-Path -Path "$scriptPath\..\..\").ToString().trim('\')
$containerFolder = "c:/vsteam"
$containerFilePath = "$rootDir/tools/docker"

$dockerRepository = "vsteam"

$WindowsImage = "$dockerRepository/wcore1903"
$WindowsContainerPS7 = "$($dockerRepository)_wcore1903_ps7_tests"
$WindowsContainerPS5 = "$($dockerRepository)_wcore1903_ps5_tests"


# Build / run Windows based container
if ($platform -eq "Windows" -and !$UseLinux) {
   Set-DockerHost -Os Windows
   Add-DockerBuild -DockerFile "$containerFilePath/wcore1903/Dockerfile" -Tag $WindowsImage

   Write-Output 'Starting PowerShell 7 tests on Windows'
   $null = Start-DockerVSTeamTests `
      -Container $WindowsContainerPS7 `
      -Volume "$rootDir`:$containerFolder" `
      -DefaultWorkDir $containerFolder `
      -Image $WindowsImage `
      -FollowLogs:$ShowLogs

   Write-Output 'Starting PowerShell 5 tests on Windows'
   $null = Start-DockerVSTeamTests `
      -Container $WindowsContainerPS5 `
      -Volume "$rootDir`:$containerFolder" `
      -DefaultWorkDir $containerFolder `
      -Image $WindowsImage `
      -Shell powershell `
      -FollowLogs:$ShowLogs

   $null = Wait-DockerContainer -Container @($WindowsContainerPS5, $WindowsContainerPS7)
}

$LinuxImage = "$dockerRepository/linux"
$LinuxContainer = "$($dockerRepository)_Linux_ps7_tests"
$LinuxContainerFolder = $containerFolder.Replace('c:/', '/c/')

# Build / run Linux based container
if ($platform -eq "Windows") {
   Set-DockerHost -Os Linux
}

Add-DockerBuild -DockerFile "$containerFilePath/linux/Dockerfile" -Tag $LinuxImage

Write-Output 'Starting PowerShell 7 tests on Linux'
$null = Start-DockerVSTeamTests `
   -Container $LinuxContainer `
   -Volume "$rootDir`:$LinuxContainerFolder" `
   -DefaultWorkDir $LinuxContainerFolder `
   -Image $LinuxImage `
   -Wait `
   -FollowLogs:$ShowLogs

$linux = Find-Numbers -fileToRead "$rootDir/vsteam_Linux_ps7_tests_result.xml"
$winP5 = Find-Numbers -fileToRead "$rootDir/vsteam_wcore1903_ps5_tests_result.xml"
$winP7 = Find-Numbers -fileToRead "$rootDir/vsteam_wcore1903_ps7_tests_result.xml"
   
$totalPassed = $winP5.Passed + $linux.Passed + $winP7.Passed
$totalFailed = $winP5.Failed + $linux.Failed + $winP7.Failed
$totalNotRun = $winP5.NotRun + $linux.NotRun + $winP7.NotRun
$totalSkipped = $winP5.Skipped + $linux.Skipped + $winP7.Skipped
   
Write-Host "Tests Passed: $totalPassed, Failed: $totalFailed, Skipped: $totalSkipped, NotRun: $totalNotRun"