Describe "VSTeamBanner" {
    Context 'Remove-VSTeamBanner' {
        BeforeAll {
            Mock _callAPI
            Mock _getApiVersion { return 'VSTS' }
            Mock _getInstance { return 'https://dev.azure.com/test' }
        }

        It 'Should remove a banner' {
            Remove-VSTeamBanner -BannerId '9547ed55-66e1-403d-95aa-9e628726861c'

            Should -Invoke _callAPI -ParameterFilter {
                $Method -eq 'DELETE' -and
                $SubDomain -eq 'settings' -and
                $Resource -like 'entries/host/GlobalMessageBanners/9547ed55-66e1-403d-95aa-9e628726861c'
            }
        }
    }
}
