Set-StrictMode -Version Latest

Describe 'VSTeamBuild' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      Mock Invoke-RestMethod
   }

   Context 'Update Build keep forever' {
      BeforeAll {
         # Set the account to use for testing. A normal user would do this
         # using the Set-VSTeamAccount function.
         Mock _getInstance { return 'https://dev.azure.com/test' }
      }
      
      It 'should post changes' {
         Update-VSTeamBuild -projectName project -id 1 -KeepForever $true -Force

         Should -Invoke Invoke-RestMethod -Exactly -Scope Context -Times 1 -ParameterFilter {
            $Method -eq 'Patch' -and
            $Body -eq '{"keepForever": true}' -and
            $Uri -eq "https://dev.azure.com/test/project/_apis/build/builds/1?api-version=$(_getApiVersion Build)" }
      }
   }

   Context 'Update Build number' {
      BeforeAll {
         Mock _useWindowsAuthenticationOnPremise { return $true }
         Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' }
      }
      
      It 'should post changes' {
         Update-VSTeamBuild -projectName project -id 1 -BuildNumber 'TestNumber' -KeepForever $true -Force

         Should -Invoke Invoke-RestMethod -Exactly -Scope Context -Times 1 -ParameterFilter {
            $Method -eq 'Patch' -and
            $Body -eq '{"keepForever": true, "buildNumber": "TestNumber"}' -and
            $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/builds/1?api-version=$(_getApiVersion Build)" }
      }
   }
}