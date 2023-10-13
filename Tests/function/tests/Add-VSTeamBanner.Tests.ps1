Describe "VSTeamBanner" {
    BeforeAll {
        . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
    }

    Context 'Add-VSTeamBanner' {
      BeforeAll {
         [vsteam_lib.Versions]::ModuleVersion = '0.0.0'

         Mock Invoke-VSTeamRequest
         Mock _getInstance { return 'https://dev.azure.com/test' }
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
