function Set-DockerHost {
   <#
    .SYNOPSIS
        Switch between windows and linux containers. IMPORTANT: Works only for windows based systems
   #>
   [CmdletBinding()]
   param (
      #sets the container OS
      [Parameter(Mandatory = $true)]
      [ValidateSet("windows", "linux")]
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

      #only build if image does not exist or it's forced
      #when not using force: It can't be checked if a docker file has is different from the existing image
      if ($null -eq $dockerImageId -or $Force) {
         docker build -f $DockerFile --tag $Tag .
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
         .\Build-Module.ps1 -installDep;
         $null = Import-Module Pester;

         $pesterArgs = [PesterConfiguration]::Default;
         $pesterArgs.Run.Exit = $true;
         $pesterArgs.Run.Path = '.\unit';
         $pesterArgs.Run.PassThru = $true;
         $pesterArgs.Output.Verbosity = 'Normal';
         $pesterArgs.TestResult.Enabled = $true;

         Invoke-Pester -Configuration $pesterArgs;

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

      docker run `
         -dit `
         --name  $Container `
         --volume $Volume `
         -w $DefaultWorkDir `
         $Image `
         $Shell -Command $pesterBuild.ToString()

      if ($FollowLogs) {
         $argList = "-NoExit -Command `"`$Host.UI.RawUI.WindowTitle = 'VSTeam Unit Tests | $($PSVersionTable.PSEdition) $($PSVersionTable.PSVersion) | $($PSVersionTable.Os)'; docker logs $Container -f`""
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
         docker wait ($Container -join ' ')
      }
   }
}

$platform = $PSVersionTable.Platform
if ($platform -ne "Win32NT") {
   Write-Warning "Platform is not Win32NT based but '$platform'. Windows container do not work on linux based systems. Ignoring windows containers..."
}

$scriptPath = $PSScriptRoot
$rootDir = (Resolve-Path -Path "$scriptPath\..\..\").ToString().trim('\')
$containerFolder = "c:/vsteam"
$containerFilePath = "$rootDir/build/docker"

$dockerRepository = "vsteam"


$windowsImage = "$dockerRepository/wcore1903"
$windowsContainerPS7 = "$($dockerRepository)_wcore1903_ps7_tests"
$windowsContainerPS5 = "$($dockerRepository)_wcore1903_ps5_tests"

# Build / run windows based container
if ($platform -eq "Win32NT") {
   Set-DockerHost -Os windows -Verbose
   Add-DockerBuild -DockerFile "$containerFilePath/wcore1903/Dockerfile" -Tag $windowsImage

   Start-DockerVSTeamTests `
      -Container $windowsContainerPS7 `
      -Volume "$rootDir`:$containerFolder" `
      -DefaultWorkDir $containerFolder `
      -Image $windowsImage `
      -FollowLogs

   Start-DockerVSTeamTests `
      -Container $windowsContainerPS5 `
      -Volume "$rootDir`:$containerFolder" `
      -DefaultWorkDir $containerFolder `
      -Image $windowsImage `
      -Shell powershell `
      -FollowLogs


      Wait-DockerContainer -Container @($windowsContainerPS5,$windowsContainerPS7)
}

$linuxImage = "$dockerRepository/linux"
$linuxContainer = "$($dockerRepository)_linux_tests"
$linuxContainerFolder = $containerFolder.Replace('c:/', '/c/')

# Build / run linux based container
if ($platform -eq "Win32NT") {
   Set-DockerHost -Os linux -Verbose
}
Add-DockerBuild -DockerFile "$containerFilePath/linux/Dockerfile" -Tag $linuxImage
Start-DockerVSTeamTests `
   -Container $linuxContainer `
   -Volume "$rootDir`:$linuxContainerFolder" `
   -DefaultWorkDir $linuxContainerFolder `
   -Image $linuxImage `
   -Wait `
   -FollowLogs
