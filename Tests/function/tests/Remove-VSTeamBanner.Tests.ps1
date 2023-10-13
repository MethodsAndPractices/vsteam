Describe "VSTeamBanner" {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$baseFolder/Source/Public/Invoke-VSTeamRequest.ps1"
   }

   Context 'Remove-VSTeamBanner' {
      BeforeAll {
         Mock Invoke-VSTeamRequest
      }

      It 'Should remove a banner' {
         Remove-VSTeamBanner -Id 'test-id'

         Should -Invoke Invoke-VSTeamRequest -ParameterFilter {
            $Method -eq 'DELETE' -and
            $area -eq 'settings' -and
            $resource -eq 'entries/host/GlobalMessageBanners/test-id'
         }
      }
   }
}
