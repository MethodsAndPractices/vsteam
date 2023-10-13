Describe "VSTeamBanner" {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$baseFolder/Source/Public/Invoke-VSTeamRequest.ps1"
   }

   Context 'Get-VSTeamBanner' {
      BeforeAll {
         Mock Invoke-VSTeamRequest { return @{ value = @{ bannerId = '12345' } } }
      }

      It 'Should get a banner' {
         $result = Get-VSTeamBanner -Id '12345'

         Should -Invoke Invoke-VSTeamRequest -ParameterFilter {
            $Method -eq 'GET' -and
            $Area -eq 'settings' -and
            $Resource -eq 'entries/host/GlobalMessageBanners/12345' -and
            $Version -eq '3.2-preview'
         }

         $result.bannerId | Should -Be '12345'
      }
   }
}
