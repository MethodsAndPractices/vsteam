[CmdletBinding(DefaultParameterSetName = "PublishPSGallery", SupportsShouldProcess)]
param (
   # give a revision number if needed for test and build purposes
   [Parameter(Mandatory = $false)]
   [int]
   $RevisionNumber = -1,
   #github token
   [Parameter(Mandatory = $false, ParameterSetName = "PublishGithub")]
   [string]
   $GitHubToken,
   # PS gallery token
   [Parameter(Mandatory = $false, ParameterSetName = "PublishPSGallery")]
   [string]
   $PSGalleryApiKey,
   # path to the module wihtout the name e.g. "C:\path\without\name" and not "C:\path\without\name\VSTeam"
   [Parameter(Mandatory = $true)]
   [string]
   $ModulePath
)
Write-Host "Compute Version Number"

if ($null -eq (Get-Module -Name Metadata -ListAvailable)) {
   Write-Host "Metadata module not installed, installing it"
   Install-Module -Name Metadata -Scope CurrentUser -Force
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
Export-Metadata -Path "$ModulePath/dist/VSTeam.psd1" -InputObject $manifest


if ($PsCmdlet.ParameterSetName -eq "PublishGithub") {

   #create nuspec file
   Write-Host "Create NuSpec from PSD1"
   Install-Module -Name Trackyon.Nuget -Scope CurrentUser -Force
   ConvertTo-NuSpec -Path "$ModulePath/dist/VSTeam.psd1"

   Write-Host "Pack module"
   Write-Host "nuget pack "$ModulePath/dist/VSTeam.nuspec" -NonInteractive -OutputDirectory "$ModulePath/dist" -version $package_version -Verbosity Detailed"
   nuget pack "$ModulePath/dist/VSTeam.nuspec" -NonInteractive -OutputDirectory "$ModulePath/dist" -version $package_version -Verbosity Detailed

   Write-Host "Push module to GitHub Package feed"

   if ($PSCmdlet.ShouldProcess("Module publishing to nuget Github feed")) {
      dotnet tool install gpr -g
      gpr push "$ModulePath/dist/*.nupkg" -k $GitHubToken --repository "MethodsAndPractices/vsteam"
   }
   else {
      Write-Host "Publish to repository 'MethodsAndPractices/vsteam' skipped"
   }

}
elseif ($PsCmdlet.ParameterSetName -eq "PublishPSGallery") {

   Write-Host "Publish module to PSGallery"
   Copy-Item -Path "$ModulePath/dist" -Destination "$ModulePath/VSTeam" -Recurse -WhatIf:$false

   if ($PSCmdlet.ShouldProcess("Module publishing to PS gallery")) {
      Publish-Module -NuGetApiKey $PSGalleryApiKey -Path "$ModulePath/VSTeam"
   }
   else {
      Publish-Module -NuGetApiKey $PSGalleryApiKey -Path "$ModulePath/VSTeam" -WhatIf
   }
}
