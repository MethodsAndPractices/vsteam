Set-StrictMode -Version Latest

Describe 'VSTeamPolicy' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
   
      ## Arrange
      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' }

      Mock Invoke-RestMethod
      Mock Invoke-RestMethod { throw 'Error' } -ParameterFilter { $Uri -like "*boom*" }
   }

   Context 'Remove-VSTeamPolicy' {
      It 'by id should delete the policy' {
         ## Act
         Remove-VSTeamPolicy -ProjectName Demo -id 4 -Force

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Method -eq 'Delete' -and
            $Uri -eq "https://dev.azure.com/test/Demo/_apis/policy/configurations/4?api-version=$(_getApiVersion Git)"
         }
      }

      It 'Should throw' {
         ## Act / Assert
         { Remove-VSTeamPolicy -ProjectName boom -id 4 -Force } | Should -Throw
      }
   }
}