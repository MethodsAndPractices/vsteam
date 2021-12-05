[CmdletBinding(DefaultParameterSetName = "PublishPSGallery", SupportsShouldProcess)]
param (
   # give a revision number if needed for test and build purposes
   [Parameter(Mandatory = $false)]
   [int]
   $RevisionNumber = -1,
   # path to the module wihtout the name e.g. "C:\path\without\name" and not "C:\path\without\name\VSTeam"
   [Parameter(Mandatory = $true)]
   [string]
   $ModulePath
)
Write-Host "Compute Version Number"

if ($null -eq (Get-Module -Name Metadata -ListAvailable)) {
   Write-Host "Metadata module not installed, installing it"
   $null = Install-Module -Name Metadata -Scope CurrentUser -Force
}

# Load the psd1 file so you can read the version
$manifest = Import-Metadata -Path "$ModulePath/dist/VSTeam.psd1"
# load as semantic version
[version]$sem_version = $manifest.ModuleVersion

# Build new semantic version with build number
$package_version = "$($sem_version.Major).$($sem_version.Minor).$($sem_version.Build)"
if ($RevisionNumber -and $RevisionNumber -ne -1) {
   $package_version = "$($sem_version.Major).$($sem_version.Minor).$($sem_version.Build).$($RevisionNumber)"
}
$manifest.ModuleVersion = $package_version
Write-Host "Package Version Number: $package_version"
$null = Export-Metadata -Path "$ModulePath/dist/VSTeam.psd1" -InputObject $manifest

Write-Output $package_version
