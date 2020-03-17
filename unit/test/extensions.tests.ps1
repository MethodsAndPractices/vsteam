Set-StrictMode -Version Latest

$env:Testing=$true
InModuleScope VSTeam {
   Describe 'Extension' {
      Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable
      
      $results = [PSCustomObject]@{
         count = 1
         value = [PSCustomObject]@{
            extensionId     = 'test'
            extensionName   = 'test'
            publisherId     = 'test'
            publisherName   = 'test'
            version         = '1.0.0'
            registrationId  = '12345678-9012-3456-7890-123456789012'
            manifestVersion = 1
            baseUri         = ''
            fallbackBaseUri = ''
            scopes          = [PSCustomObject]@{}
            installState    = [PSCustomObject]@{
               flags       = 'none'
               lastUpdated = '2018-10-09T11:26:47.187Z'
            }
         }
      }

      $singleResult = [PSCustomObject]@{
         extensionId     = 'test'
         extensionName   = 'test'
         publisherId     = 'test'
         publisherName   = 'test'
         version         = '1.0.0'
         registrationId  = '12345678-9012-3456-7890-123456789012'
         manifestVersion = 1
         baseUri         = ''
         fallbackBaseUri = ''
         scopes          = [PSCustomObject]@{}
         installState    = [PSCustomObject]@{
            flags       = 'none'
            lastUpdated = '2018-10-09T11:26:47.187Z'
         }
      }

      Context 'Get-VSTeamExtension' {
         BeforeAll {
            $env:Team_TOKEN = '1234'
         }

         AfterAll {
            $env:TEAM_TOKEN = $null
         }

         It 'Should return extensions' {
            Mock  _callAPI { return $results }

            Get-VSTeamExtension

            Assert-MockCalled _callAPI -Exactly 1 -Scope It -ParameterFilter {
               $Method -eq 'Get' -and
               $subDomain -eq 'extmgmt' -and
               $version -eq [VSTeamVersions]::ExtensionsManagement
               $Url -like "*https://extmgmt.dev.azure.com/test/_apis/_apis/extensionmanagement/installedextensions*"
            }
         }

         It 'Should return extensions with optional parameters' {
            Mock  _callAPI { return $results }

            Get-VSTeamExtension -IncludeInstallationIssues -IncludeDisabledExtensions -IncludeErrors

            Assert-MockCalled _callAPI -Exactly 1 -Scope It -ParameterFilter {
               $Method -eq 'Get' -and
               $subDomain -eq 'extmgmt' -and
               $version -eq [VSTeamVersions]::ExtensionsManagement
               $Url -like "*https://extmgmt.dev.azure.com/test/_apis/_apis/extensionmanagement/installedextensions*" -and
               $Url -like "*includeInstallationIssues*" -and
               $Url -like "*includeDisabledExtensions*" -and
               $Url -like "*includeErrors*"
            }
         }

         It 'Should return the extension' {
            Mock  _callAPI { return $singleResult }

            Get-VSTeamExtension -PublisherId test -ExtensionId test

            Assert-MockCalled _callAPI -Exactly 1 -Scope It -ParameterFilter {
               $Method -eq 'Get' -and
               $subDomain -eq 'extmgmt' -and
               $version -eq [VSTeamVersions]::ExtensionsManagement
               $Url -like "*https://extmgmt.dev.azure.com/test/_apis/_apis/extensionmanagement/installedextensionsbyname/test/test*"
            }
         }
      }

      Context 'Add-VSTeamExtension without version' {
         BeforeAll {
            $env:Team_TOKEN = '1234'
         }

         AfterAll {
            $env:TEAM_TOKEN = $null
         }

         Mock _callAPI { return $singleResult }

         It 'Should add an extension without version' {
            Add-VSTeamExtension -PublisherId 'test' -ExtensionId 'test'

            Assert-MockCalled _callAPI -Exactly 1 -Scope It -ParameterFilter {
               $Method -eq 'Get' -and
               $subDomain -eq 'extmgmt' -and
               $version -eq [VSTeamVersions]::ExtensionsManagement -and
               $uri
               $Url -like "*https://extmgmt.dev.azure.com/test/_apis/_apis/extensionmanagement/installedextensionsbyname/test/test*"
            }
         }
      }

      Context 'Add-VSTeamExtension with version' {
         BeforeAll {
            $env:Team_TOKEN = '1234'
         }

         AfterAll {
            $env:TEAM_TOKEN = $null
         }

         Mock _callAPI { return $singleResult }

         It 'Should add an extension with version' {
            Add-VSTeamExtension -PublisherId 'test' -ExtensionId 'test' -Version '1.0.0'

            Assert-MockCalled _callAPI -Exactly 1 -Scope It -ParameterFilter {
               $Method -eq 'Get' -and
               $subDomain -eq 'extmgmt' -and
               $version -eq [VSTeamVersions]::ExtensionsManagement
               $Url -like "*https://extmgmt.dev.azure.com/test/_apis/_apis/extensionmanagement/installedextensionsbyname/test/test/1.0.0*"
            }
         }
      }

      Context 'Update-VSTeamExtension' {
         BeforeAll {
            $env:Team_TOKEN = '1234'
         }

         AfterAll {
            $env:TEAM_TOKEN = $null
         }

         Mock _callAPI { return $singleResult }

         It 'Should add an extension without version' {
            Update-VSTeamExtension -PublisherId 'test' -ExtensionId 'test' -ExtensionState disabled -Force

            Assert-MockCalled _callAPI -Exactly 1 -Scope It -ParameterFilter {
               $Method -eq 'Post' -and
               $subDomain -eq 'extmgmt' -and
               $version -eq [VSTeamVersions]::ExtensionsManagement
               $Url -like "*https://extmgmt.dev.azure.com/test/_apis/_apis/extensionmanagement/installedextensionsbyname/test/test*"
            }
         }
      }

      Context 'Remove-VSTeamExtension' {
         BeforeAll {
            $env:Team_TOKEN = '1234'
         }

         AfterAll {
            $env:TEAM_TOKEN = $null
         }

         Mock _callAPI { return $singleResult }

         It 'Should remove an extension' {
            Remove-VSTeamExtension -PublisherId 'test' -ExtensionId 'test' -Force

            Assert-MockCalled _callAPI -Exactly 1 -Scope It -ParameterFilter {
               $Method -eq 'Delete' -and
               $subDomain -eq 'extmgmt' -and
               $version -eq [VSTeamVersions]::ExtensionsManagement
               $Url -like "*https://extmgmt.dev.azure.com/test/_apis/_apis/extensionmanagement/installedextensionsbyname/test/test*"
            }
         }
      }
   }
}