Set-StrictMode -Version Latest

Describe 'VSTeamFeed' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
   }

   Context 'Add-VSTeamFeed' {
      ## Arrange
      BeforeAll {
         Mock _getInstance { return 'https://dev.azure.com/test' }
         Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamFeed.json' -Index 0 }
         Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Packaging' }
      }

      it 'should add feed with description' {
         ## Act
         Add-VSTeamFeed -Name 'module' `
            -Description 'Test Module'

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -eq "https://feeds.dev.azure.com/test/_apis/packaging/feeds?api-version=$(_getApiVersion Packaging)" -and
            $Method -eq 'Post' -and
            $Body -like '*"name":*"module"*'
         }
      }

      it 'should add feed with upstream sources' {
         ## Act
         Add-VSTeamFeed -Name 'module' `
            -EnableUpstreamSources `
            -showDeletedPackageVersions

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