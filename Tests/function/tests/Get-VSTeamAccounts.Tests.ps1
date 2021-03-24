Set-StrictMode -Version Latest

Describe 'VSTeamAccounts' -Tag 'unit', 'accounts' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      # The Parameter Filter makes sure this mock is only called if the
      # function under test request the correct service version
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter {
         $Service -eq 'Core'
      }

      Mock _callAPI { return $null }
   }

   Context 'Get-VSTeamAccounts' {
      It 'should get accounts by owner id' {
         Get-VSTeamAccounts -OwnerId 569a3107-0cd3-4817-83f1-4d91b0e3d7cb

         Should -Invoke _callAPI -Exactly -Scope It -Times 1 `
            -ParameterFilter {
            $NoProject -eq $true -and
            $Area -eq 'accounts' -and
            $SubDomain -eq 'vssps' -and
            $Version -eq '1.0-unitTests' -and
            $QueryString['ownerId'] -eq '569a3107-0cd3-4817-83f1-4d91b0e3d7cb'
         }
      }

      It 'should get accounts by member id' {
         Get-VSTeamAccounts -MemberId e80da752-e806-4acb-b344-91f5d47081a5

         Should -Invoke _callAPI -Exactly -Scope It -Times 1 `
            -ParameterFilter {
            $NoProject -eq $true -and
            $Area -eq 'accounts' -and
            $SubDomain -eq 'vssps' -and
            $Version -eq '1.0-unitTests' -and
            $QueryString['memberId'] -eq 'e80da752-e806-4acb-b344-91f5d47081a5'
         }
      }
   }
}
