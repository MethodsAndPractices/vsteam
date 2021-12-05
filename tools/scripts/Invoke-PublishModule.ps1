[CmdletBinding(DefaultParameterSetName = "PublishPSGallery", SupportsShouldProcess)]
param (
   # version number that should be used when publishing to github
   [Parameter(Mandatory = $true, ParameterSetName = "PublishGithub")]
   [version]
   $Version,
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

if ($PsCmdlet.ParameterSetName -eq "PublishGithub") {

   #create nuspec file
   Write-Host "Create NuSpec from PSD1"
   Install-Module -Name Trackyon.Nuget -Scope CurrentUser -Force
   ConvertTo-NuSpec -Path "$ModulePath/dist/VSTeam.psd1"

   Write-Host "Pack module"
   Write-Host "nuget pack "$ModulePath/dist/VSTeam.nuspec" -NonInteractive -OutputDirectory "$ModulePath/dist" -version $Version -Verbosity Detailed"
   nuget pack "$ModulePath/dist/VSTeam.nuspec" -NonInteractive -OutputDirectory "$ModulePath/dist" -version $Version -Verbosity Detailed

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
