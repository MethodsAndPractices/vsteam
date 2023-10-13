Describe "VSTeamBanner" {
    Context 'Update-VSTeamBanner' {
      BeforeAll {
         [vsteam_lib.Versions]::ModuleVersion = '0.0.0'

         Mock Invoke-VSTeamRequest
         Mock _getInstance { return 'https://dev.azure.com/test' }
      }

      It 'Should update a banner' {
         Update-VSTeamBanner -Id 'test-id' `
            -Message 'Updated Message' `
            -ExpirationDate (Get-Date '2024-01-02T04:00:00') `
            -Level 'warning'

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
