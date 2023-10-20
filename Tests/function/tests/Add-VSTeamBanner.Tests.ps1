Set-StrictMode -Version Latest

Describe 'VSTeamBanner' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$baseFolder/Source/Public/Invoke-VSTeamRequest.ps1"
   }

   Context 'Add-VSTeamBanner' {
      BeforeAll {
         Mock Invoke-VSTeamRequest
      }

      It 'Should add a banner' {
         Add-VSTeamBanner -Id 'test-id' `
            -Message 'Test Message' `
            -ExpirationDate (Get-Date '2024-01-01T04:00:00') `
            -Level 'info'

         Should -Invoke Invoke-VSTeamRequest -ParameterFilter {
            $Method -eq 'PATCH' -and
            $area -eq 'settings' -and
            $Body -like '*"expirationDate":*"2024-01-02T04:00:00"*'
            $resource -eq 'entries/host' -and
            $Body -like '*"GlobalMessageBanners/test-id"*'
         }
      }
   }
}
