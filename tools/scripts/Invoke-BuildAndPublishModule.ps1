[CmdletBinding(DefaultParameterSetName = "PublishPSGallery")]
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
   $WorkingDirectory
)
Write-Host "Compute Version Number"

if ($null -eq (Get-Module -Name Metadata -ListAvailable))
{
   Write-Host "Metadata module not installed, installing it"
   Install-Module -Name Metadata
}

# Load the psd1 file so you can read the version
$manifest = Import-Metadata -Path "$WorkingDirectory/dist/VSTeam.psd1"
# load as semantic version
[version]$sem_version = $manifest.ModuleVersion

# Build new semantic version with build number
$package_version = "$($sem_version.Major).$($sem_version.Minor).$($sem_version.Build)"
if ($RevisionNumber -and $RevisionNumber -ne -1) {
   $package_version = "$($sem_version.Major).$($sem_version.Minor).$($sem_version.Build).$($RevisionNumber)"
}
$manifest.ModuleVersion = $package_version
Write-Host "Package Version Number: $package_version"
Export-Metadata -Path "$WorkingDirectory/dist/VSTeam.psd1" -InputObject $manifest


if ($PsCmdlet.ParameterSetName -eq "PublishGithub") {

   #create nuspec file
   Write-Host "Create NuSpec from PSD1"
   Install-Module -Name Trackyon.Nuget -Scope CurrentUser -Force
   ConvertTo-NuSpec -Path "$WorkingDirectory/dist/VSTeam.psd1"

   Write-Host "Pack module"
   Write-Host "nuget pack "$WorkingDirectory/dist/VSTeam.nuspec" -NonInteractive -OutputDirectory "$WorkingDirectory/dist" -version $package_version -Verbosity Detailed"
   nuget pack "$WorkingDirectory/dist/VSTeam.nuspec" -NonInteractive -OutputDirectory "$WorkingDirectory/dist" -version $package_version -Verbosity Detailed

   Write-Host "Push module to GitHub Package feed"
   dotnet tool install gpr -g
   gpr push "$WorkingDirectory/dist/*.nupkg" -k $GitHubToken --repository "MethodsAndPractices/vsteam"

}
elseif ($PsCmdlet.ParameterSetName -eq "PublishPSGallery") {

   Write-Host "Publish module to PSGallery"
   Copy-Item -Path "$WorkingDirectory/dist" -Destination "$WorkingDirectory/VSTeam" -Recurse
   Publish-Module -NuGetApiKey $PSGalleryApiKey -Path "$WorkingDirectory/VSTeam"
}
