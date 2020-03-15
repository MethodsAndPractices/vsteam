Set-StrictMode -Version Latest

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/$sut"

Describe 'Update-VSTeamBuild' {
   Mock Invoke-RestMethod

   # Mock the call to Get-Projects by the dynamic parameter for ProjectName
   Mock Invoke-RestMethod { return @() } -ParameterFilter {
      $Uri -like "*_apis/projects*"
   }

   Context 'Update Build keep forever' {
      # Load the mocks to create the project name dynamic parameter
      . "$PSScriptRoot\mocks\mockProjectNameDynamicParamNoPSet.ps1"

      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable

      Update-VSTeamBuild -projectName project -id 1 -KeepForever $true -Force

      It 'should post changes' {
         Assert-MockCalled Invoke-RestMethod -Exactly -Scope Context -Times 1 -ParameterFilter {
            $Method -eq 'Patch' -and
            $Body -eq '{"keepForever": true}' -and
            $Uri -eq "https://dev.azure.com/test/project/_apis/build/builds/1?api-version=$([VSTeamVersions]::Build)" }
      }
   }

   Context 'Update Build number' {
      . "$PSScriptRoot\mocks\mockProjectNameDynamicParam.ps1"

      Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' } -Verifiable

      Mock _useWindowsAuthenticationOnPremise { return $true }
   
      Update-VSTeamBuild -projectName project -id 1 -BuildNumber 'TestNumber' -KeepForever $true -Force

      It 'should post changes' {
         Assert-MockCalled Invoke-RestMethod -Exactly -Scope Context -Times 1 -ParameterFilter {
             $Method -eq 'Patch' -and 
             $Body -eq '{"keepForever": true, "buildNumber": "TestNumber"}' -and 
             $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/builds/1?api-version=$([VSTeamVersions]::Build)" }
      }
   }
}