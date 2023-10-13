Describe "VSTeamBanner" {
    Context 'Update-VSTeamBanner' {
        BeforeAll {
            Mock _callAPI
            Mock _getApiVersion { return 'VSTS' }
            Mock _getInstance { return 'https://dev.azure.com/test' }
        }

        It 'Should update a banner' {

            $date = [datetime]::ParseExact('2024-01-01T04:00:00', 's', $null)

            Update-VSTeamBanner -Level warning `
               -Message 'Updated Message' `
               -ExpirationDate $date `
               -BannerId '9547ed55-66e1-403d-95aa-9e628726861c'

            Should -Invoke _callAPI -ParameterFilter {
                $Method -eq 'PATCH' -and
                $SubDomain -eq 'settings' -and
                $Body -like '*"expirationDate":*"2024-01-01T04:00:00"*' -and
                $Body -like '*"level":*"warning"*' -and
                $Body -like '*"message":*"Updated Message"*'
            }
        }
    }
}
