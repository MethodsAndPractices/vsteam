Set-StrictMode -Version Latest

Describe 'VSTeamFeed' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      ## Arrange
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter {
         $Service -eq 'Packaging'
      }

      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamFeed.json' }
      Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamFeed.json' -Index 0 } -ParameterFilter {
         $Uri -like "*00000000-0000-0000-0000-000000000000*"
      }

   }

   Context 'Get-VSTeamFeed for whole organization' {

      It 'with no parameters should return all the Feeds' {
         ## Act
         Get-VSTeamFeed

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://feeds.dev.azure.com/test/_apis/packaging/feeds?api-version=$(_getApiVersion packaging)"
         }
      }

      It 'with no parameters should return only organization feeds' {
         ## Act
         $feeds = Get-VSTeamFeed -Scope organization

         $feeds | ForEach-Object {
            $_.Url | Should -BeLike 'https://feeds.dev.azure.com/test/_apis/Packaging'
         }

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://feeds.dev.azure.com/test/_apis/packaging/feeds?api-version=$(_getApiVersion packaging)"
         }
      }

      It 'with no parameters should return only project feeds' {
         ## Act
         $feeds = Get-VSTeamFeed -Scope project

         $feeds | ForEach-Object {
            $_.Url | Should -BeLike ''
         }

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://feeds.dev.azure.com/test/_apis/packaging/feeds?api-version=$(_getApiVersion packaging)"
         }
      }

      It 'by id should return one feed' {
         ## Act
         Get-VSTeamFeed -id '00000000-0000-0000-0000-000000000000'

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://feeds.dev.azure.com/test/_apis/packaging/feeds/00000000-0000-0000-0000-000000000000?api-version=$(_getApiVersion packaging)"
         }
      }
   }

   Context 'Get-VSTeamFeed for project' {

      It 'with no parameters should return all the Feeds' {
         ## Act
         Get-VSTeamFeed -ProjectName 'testProject'

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://feeds.dev.azure.com/test/testProject/_apis/packaging/feeds?api-version=$(_getApiVersion packaging)"
         }
      }

      It 'by id should return one feed' {
         ## Act
         Get-VSTeamFeed -id '00000000-0000-0000-0000-000000000000'  -ProjectName 'testProject'

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://feeds.dev.azure.com/test/testProject/_apis/packaging/feeds/00000000-0000-0000-0000-000000000000?api-version=$(_getApiVersion packaging)"
         }
      }
   }
}