Describe "VSTeamBanner" {
   BeforeAll {
         . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
         . "$baseFolder/Source/Public/Invoke-VSTeamRequest.ps1"
         . "$baseFolder/Source/Public/Get-VSTeamBanner.ps1"
   }

    Context 'Update-VSTeamBanner' {
      BeforeAll {
         Mock Invoke-VSTeamRequest

         Mock Get-VSTeamBanner { return @{
            message = 'Old Message'
            level = 'warning'
            expirationDate = '2023-10-01T00:00:00'
            id = '12345'
         } }
      }

      It 'Should update a banner' {
         $result = Update-VSTeamBanner -Id '12345' -Message 'Updated Message' -Level 'info' -ExpirationDate (Get-Date '2023-12-31T23:59:59')

         Should -Invoke Invoke-VSTeamRequest -ParameterFilter {
            $Method -eq 'PATCH' -and
            $Area -eq 'settings' -and
            $Resource -eq 'entries/host' -and
            $Version -eq '3.2-preview' -and
            $Body -like '*12345*' -and
            $Body -like '*Updated Message*' -and
            $Body -like '*info*' -and
            $Body -like '*2023-12-31T23:59:59*'
         }

         $result | Should -Not -BeNullOrEmpty
         $result.message | Should -Be 'Updated Message'
     }

    }
}
