Describe "VSTeamBanner" {
    BeforeAll {
        . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
    }

   Context 'Remove-VSTeamBanner' {
      BeforeAll {
         [vsteam_lib.Versions]::ModuleVersion = '0.0.0'

         Mock Invoke-VSTeamRequest
         Mock _getInstance { return 'https://dev.azure.com/test' }
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
}
