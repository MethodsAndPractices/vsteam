Set-StrictMode -Version Latest

Describe 'VSTeamExtension' {
   BeforeAll {
      Import-Module SHiPS

      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamLeaf.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamInstallState.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamExtension.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"
   }

   Context 'Add-VSTeamExtension' {
      ## Arrange
      BeforeAll {
         Mock _getInstance { return 'https://dev.azure.com/test' }
         Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'ExtensionsManagement' }

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
            scopes          = [PSCustomObject]@{ }
            installState    = [PSCustomObject]@{
               flags       = 'none'
               lastUpdated = '2018-10-09T11:26:47.187Z'
            }
         }

         $env:Team_TOKEN = '1234'

         Mock _callAPI { return $singleResult }
      }

      AfterAll {
         $env:TEAM_TOKEN = $null
      }

      It 'Should add an extension without version' {
         ## Act
         Add-VSTeamExtension -PublisherId 'test' -ExtensionId 'test'

         ## Assert
         Should -Invoke _callAPI -Exactly -Times 1 -Scope It -ParameterFilter {
            $Method -eq 'Get' -and
            $subDomain -eq 'extmgmt' -and
            $version -eq $(_getApiVersion ExtensionsManagement) -and
            $uri
            $Url -like "*https://extmgmt.dev.azure.com/test/_apis/_apis/extensionmanagement/installedextensionsbyname/test/test*"
         }
      }

      It 'Should add an extension with version' {
         ## Act
         Add-VSTeamExtension -PublisherId 'test' -ExtensionId 'test' -Version '1.0.0'

         ## Assert
         Should -Invoke _callAPI -Exactly -Times 1 -Scope It -ParameterFilter {
            $Method -eq 'Get' -and
            $subDomain -eq 'extmgmt' -and
            $version -eq $(_getApiVersion ExtensionsManagement)
            $Url -like "*https://extmgmt.dev.azure.com/test/_apis/_apis/extensionmanagement/installedextensionsbyname/test/test/1.0.0*"
         }
      }
   }
}