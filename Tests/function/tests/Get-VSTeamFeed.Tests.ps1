Set-StrictMode -Version Latest

Describe 'VSTeamFeed' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
   }
   
   Context 'Get-VSTeamFeed' {
      BeforeAll {
         ## Arrange
         Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Packaging' }
         $results = Open-SampleFile feeds.json

         Mock Invoke-RestMethod { return $results }
         Mock _getInstance { return 'https://dev.azure.com/test' }
         Mock Invoke-RestMethod { return $results.value[0] } -ParameterFilter { $Uri -like "*00000000-0000-0000-0000-000000000000*" }
      }

      it 'with no parameters should return all the Feeds' {
         ## Act
         Get-VSTeamFeed

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://feeds.dev.azure.com/test/_apis/packaging/feeds?api-version=$(_getApiVersion packaging)"
         }
      }

      it 'by id should return one feed' {
         ## Act
         Get-VSTeamFeed -id '00000000-0000-0000-0000-000000000000'

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://feeds.dev.azure.com/test/_apis/packaging/feeds/00000000-0000-0000-0000-000000000000?api-version=$(_getApiVersion packaging)"
         }
      }
   }
}