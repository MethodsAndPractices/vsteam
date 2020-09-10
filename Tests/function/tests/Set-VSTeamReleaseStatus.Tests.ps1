Set-StrictMode -Version Latest

Describe 'VSTeamReleaseStatus' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      ## Arrange
      Mock _getApiVersion { return '1.0-unittest' } -ParameterFilter { $Service -eq 'Release' }

      Mock _getInstance { return 'https://dev.azure.com/test' }
   }

   Context 'Set-VSTeamReleaseStatus' {
      BeforeAll {
         ## Arrange
         Mock Invoke-RestMethod
         Mock _useWindowsAuthenticationOnPremise { return $true }
         Mock Invoke-RestMethod { throw 'error' } -ParameterFilter { $Uri -like "*101*" }
      }

      It 'by Id should set release status' {
         ## Act
         Set-VSTeamReleaseStatus -ProjectName project -Id 15 -Status Abandoned -Force

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Patch' -and
            $Body -eq '{ "id": 15, "status": "Abandoned" }' -and
            $Uri -eq "https://vsrm.dev.azure.com/test/project/_apis/release/releases/15?api-version=$(_getApiVersion Release)"
         }
      }

      It 'by Id should throw' {
         ## Act / Assert
         { Set-VSTeamReleaseStatus -ProjectName project -Id 101 -Status Abandoned -Force } | Should -Throw
      }
   }
}