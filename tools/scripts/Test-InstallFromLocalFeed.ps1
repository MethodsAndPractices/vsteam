<#
.SYNOPSIS
Script for doing a test installation of VSTeam on a local machine.

.DESCRIPTION
This script will to a test installation of VSTeam on a local machine. It downloads the published VSTeam packages and downloads them locally.
Then they will be republished in a local PS repository temporarily created.
Finally, it will install the packages from the local PS repository to test the installation process.
#>
[CmdletBinding()]
param (
   [Parameter(Mandatory = $true)]
   [string]
   $GitHubToken,
   # temporary path to put packages in
   [Parameter(Mandatory = $false)]
   [string]
   $RunnerTempPath = "$env:TEMP/InstallModuleWorkaround"
)

$LocalPSGallery = "LocalPSGallery"
$moduleName = "VSTeam"

Write-Host "`n##### Download module and all it's dependencies"
dotnet nuget add source --username USERNAME --password $GitHubToken --store-password-in-clear-text --name GitHub-VSTeam "https://nuget.pkg.github.com/MethodsAndPractices/index.json"
nuget install $moduleName -Source GitHub-VSTeam -OutputDirectory "$RunnerTempPath/install"


# rename folders by removing version tag from the folder name
$moduleFolders = Get-ChildItem "$RunnerTempPath/install" -Directory
$modulesToPublish = @()
New-Item -Path "$RunnerTempPath/repo" -Type Directory | Out-Null
foreach ($folder in $moduleFolders) {
   $shortName = $folder.Name -replace '(.*)(\.\d+){3,4}', '$1'
   Move-Item -Path "$RunnerTempPath/install/$($folder.Name)" -Destination "$RunnerTempPath/install/$($shortName)"
   $modulesToPublish += $shortName
}

Write-Host "`n##### Register-PSRepository $LocalPSGallery"
Register-PSRepository -Name $LocalPSGallery -SourceLocation "$RunnerTempPath/repo"

Write-Host "`n##### Publish modules to PS feed $LocalPSGallery"
$modulesToPublish | ForEach-Object {
   Publish-Module -Path "$RunnerTempPath/install/$_" -Repository $LocalPSGallery
   Install-Module -Name $_ -Repository $LocalPSGallery -AllowClobber -SkipPublisherCheck -Force -Scope CurrentUser
}

# split vsteam from array to uninstall first and then remove from the array
$vsteamModule = $modulesToPublish | Where-Object { $_ -eq "VSTeam" }
Uninstall-Module -Name $vsteamModule
$modulesToPublish =  $modulesToPublish | Where-Object { $_ -ne $vsteamModule }

$modulesToPublish | ForEach-Object {
   Uninstall-Module -Name $_ -AllVersions
}

Write-Host "`n##### Do test installation of Module $moduleName"
Install-Module -Name $moduleName -Repository $LocalPSGallery -AllowClobber -SkipPublisherCheck -Force -Scope CurrentUser -Verbose

UnRegister-PSRepository -Name $LocalPSGallery
dotnet nuget remove source GitHub-VSTeam
