Set-StrictMode -Version Latest

Describe 'VSTeamAccounts' -Tag 'unit', 'billing' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com' }

      Mock Invoke-RestMethod { Write-Host $args }
   }

   Context 'Get-VSTeamAccounts' {
      It 'should get accounts by owner id' {
         Get-VSTeamAccounts -OwnerId 569a3107-0cd3-4817-83f1-4d91b0e3d7cb

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 `
            -ParameterFilter {
            $Method -eq 'Get' -and
            $Uri -eq "https://vssps.dev.azure.com/_apis/accounts?api-version=3.0&ownerId=569a3107-0cd3-4817-83f1-4d91b0e3d7cb"
         }
      }

      It 'should get accounts by member id' {
         Get-VSTeamAccounts -MemberId e80da752-e806-4acb-b344-91f5d47081a5

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 `
            -ParameterFilter {
            $Method -eq 'Get' -and
            $Uri -eq "https://vssps.dev.azure.com/_apis/accounts?api-version=3.0&memberId=e80da752-e806-4acb-b344-91f5d47081a5"
         }
      }
   }
}
