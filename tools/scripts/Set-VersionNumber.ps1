[CmdletBinding(DefaultParameterSetName = 'DirectVersion')]
param (
   # Revision number for non-production use
   [Parameter(Mandatory = $true, ParameterSetName = 'Revision')]
   [int]
   $RevisionNumber,

   # Path to the module without the name e.g. "C:\path\without\name" and not "C:\path\without\name\VSTeam"
   [Parameter(Mandatory = $true)]
   [string]
   $ModulePath
)

if ($null -eq (Get-Module -Name Metadata -ListAvailable)) {
   $null = Install-Module -Name Metadata -Scope CurrentUser -Force
}

Write-Host 'Compute Version Number'

# Load the psd1 file so you can read the version
$manifest = Import-Metadata -Path "$ModulePath/dist/VSTeam.psd1"

# Load as semantic version
[version]$sem_version = $manifest.ModuleVersion
# Build new semantic version with revision number
$computedVersion = "$($sem_version.Major).$($sem_version.Minor).$($sem_version.Build).$($RevisionNumber)"

$manifest.ModuleVersion = $computedVersion
Write-Host "Package Version Number: $computedVersion"
$null = Export-Metadata -Path "$ModulePath/dist/VSTeam.psd1" -InputObject $manifest

Write-Output $computedVersion
