[CmdletBinding(DefaultParameterSetName = "PublishPSGallery", SupportsShouldProcess)]
param (
   # version number that should be used when publishing to github
   [Parameter(Mandatory = $true, ParameterSetName = "PublishGithub")]
   [Parameter(Mandatory = $true, ParameterSetName = "PublishPSGallery")]
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
   $ModulePath,
   # if set then the module will be published as a test to the gallery
   [Parameter(Mandatory = $true, ParameterSetName = "TestPublishPSGallery")]
   [string]
   $TestPublishPSGalleryApiKey
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
elseif ($PsCmdlet.ParameterSetName -eq "PublishPSGallery" -or $PsCmdlet.ParameterSetName -eq "TestPublishPSGallery") {

   $DestinationPath = "$ModulePath/VSTeam"

   Copy-Item -Path "$ModulePath/dist" -Destination $DestinationPath -Recurse -WhatIf:$false

   # replace VSTeam occurences in the module name in the files with VSTeam1
   # to make a test publish
   if ($PsCmdlet.ParameterSetName -eq "TestPublishPSGallery") {
      Write-Host "Publish module to PSGallery as test"
      $PSGalleryApiKey = $TestPublishPSGalleryApiKey

      $testPublishName = "VSTeam1"

      # rename only minimal required contents to fulfill the test publish when publishing to gallery
      # replace root module folder
      (Get-Content -Path "$DestinationPath\VSTeam.psd1") -replace "'VSTeam.psm1'", "'$testPublishName.psm1'" | Set-Content -Path "$DestinationPath\VSTeam.psd1"
      # rename psm1 file and psd1 file and folder
      Rename-Item -Path "$DestinationPath\VSTeam.psm1" -NewName "$testPublishName.psm1"
      Rename-Item -Path "$DestinationPath\VSTeam.psd1" -NewName "$testPublishName.psd1"
      Rename-Item -Path "$ModulePath\VSTeam" -NewName $testPublishName

      $DestinationPath = "$ModulePath\$testPublishName"

   }else {
      Write-Host "Publish module to PSGallery"
   }

   if ($PSCmdlet.ShouldProcess("Module publishing to PS gallery")) {
      Publish-Module -NuGetApiKey $PSGalleryApiKey -Path $DestinationPath -RequiredVersion $Version
   }
   else {
      Publish-Module -NuGetApiKey $PSGalleryApiKey -Path $DestinationPath -RequiredVersion $Version -WhatIf
   }
}
