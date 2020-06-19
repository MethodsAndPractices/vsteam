Set-StrictMode -Version Latest

Describe 'VSTeamBuild' {
   BeforeAll {
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"

      Mock Invoke-RestMethod

      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter {
         $Uri -like "*_apis/projects*"
      }
   }

   Context 'Update Build keep forever' {
      BeforeAll {
         # Set the account to use for testing. A normal user would do this
         # using the Set-VSTeamAccount function.
         Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable

         Update-VSTeamBuild -projectName project -id 1 -KeepForever $true -Force
      }

      It 'should post changes' {
         Should -Invoke Invoke-RestMethod -Exactly -Scope Context -Times 1 -ParameterFilter {
            $Method -eq 'Patch' -and
            $Body -eq '{"keepForever": true}' -and
            $Uri -eq "https://dev.azure.com/test/project/_apis/build/builds/1?api-version=$(_getApiVersion Build)" }
      }
   }

   Context 'Update Build number' {
      BeforeAll {
         Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' } -Verifiable

         Mock _useWindowsAuthenticationOnPremise { return $true }

         Update-VSTeamBuild -projectName project -id 1 -BuildNumber 'TestNumber' -KeepForever $true -Force
      }

      It 'should post changes' {
         Should -Invoke Invoke-RestMethod -Exactly -Scope Context -Times 1 -ParameterFilter {
            $Method -eq 'Patch' -and
            $Body -eq '{"keepForever": true, "buildNumber": "TestNumber"}' -and
            $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/builds/1?api-version=$(_getApiVersion Build)" }
      }
   }
}