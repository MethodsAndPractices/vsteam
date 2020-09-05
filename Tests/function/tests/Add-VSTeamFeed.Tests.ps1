Set-StrictMode -Version Latest

Describe 'VSTeamFeed' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
   }

   Context 'Add-VSTeamFeed' {
      ## Arrange
      BeforeAll {
         $results = Open-SampleFile feeds.json
         Mock Invoke-RestMethod { return $results.value[0] }
         Mock _getInstance { return 'https://dev.azure.com/test' }
         Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Packaging' }
      }

      it 'with description should add feed' {
         ## Act
         Add-VSTeamFeed -Name 'module' -Description 'Test Module'

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -eq "https://feeds.dev.azure.com/test/_apis/packaging/feeds?api-version=$(_getApiVersion Packaging)" -and
            $Method -eq 'Post' -and
            $Body -like '*"name":*"module"*'
         }
      }

      it 'with upstream sources should add feed' {
         ## Act
         Add-VSTeamFeed -Name 'module' -EnableUpstreamSources -showDeletedPackageVersions

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -eq "https://feeds.dev.azure.com/test/_apis/packaging/feeds?api-version=$(_getApiVersion packaging)" -and
            $Method -eq 'Post' -and
            $Body -like '*"upstreamEnabled":*true*' -and
            $Body -like '*"hideDeletedPackageVersions":*false*'
         }
      }
   }
}