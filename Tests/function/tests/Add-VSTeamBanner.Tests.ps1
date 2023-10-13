Describe "VSTeamBanner" {
    BeforeAll {
        . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
    }

    Context 'Add-VSTeamBanner' {
        BeforeAll {
            [vsteam_lib.Versions]::ModuleVersion = '0.0.0'

            Mock _callAPI
            Mock _getApiVersion { return 'VSTS' }
            Mock _getInstance { return 'https://dev.azure.com/test' }
        }

        It 'Should add a banner' {

            $date = [datetime]::ParseExact('2024-01-01T04:00:00', 's', $null)

            Add-VSTeamBanner -Level info `
               -Message 'Test Message' `
               -ExpirationDate $date `
               -BannerId '9547ed55-66e1-403d-95aa-9e628726861c'

            Should -Invoke _callAPI -ParameterFilter {
                $Method -eq 'PATCH' -and
                $SubDomain -eq 'settings' -and
                $Body -like '*"expirationDate":*"2024-01-01T04:00:00"*' -and
                $Body -like '*"level":*"info"*' -and
                $Body -like '*"message":*"Test Message"*'
            }
        }
    }
}
