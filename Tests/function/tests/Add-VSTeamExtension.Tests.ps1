Set-StrictMode -Version Latest

Describe 'VSTeamExtension' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
   }

   Context 'Add-VSTeamExtension' {
      ## Arrange
      BeforeAll {
         Mock _getInstance { return 'https://dev.azure.com/test' }
         Mock _callAPI { Open-SampleFile 'Get-VSTeamExtension.json' -Index 0 }
         Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'ExtensionsManagement' }
      }

      It 'should add an extension without version' {
         ## Act
         Add-VSTeamExtension -PublisherId 'test' `
            -ExtensionId 'test'

         ## Assert
         Should -Invoke _callAPI -Exactly -Times 1 -Scope It -ParameterFilter {
            $Method -eq 'POST' -and
            $subDomain -eq 'extmgmt' -and
            $Area -eq 'extensionmanagement' -and
            $Resource -eq 'installedextensionsbyname' -and
            $Id -eq 'test/test' -and
            $version -eq $(_getApiVersion ExtensionsManagement)
         }
      }

      It 'should add an extension with version' {
         ## Act
         Add-VSTeamExtension -PublisherId 'test' `
            -ExtensionId 'test' `
            -Version '1.0.0'

         ## Assert
         Should -Invoke _callAPI -Exactly -Times 1 -Scope It -ParameterFilter {
            $Method -eq 'POST' -and
            $subDomain -eq 'extmgmt' -and
            $Area -eq 'extensionmanagement' -and
            $Resource -eq 'installedextensionsbyname' -and
            $Id -eq 'test/test/1.0.0' -and
            $version -eq $(_getApiVersion ExtensionsManagement)
         }
      }
   }
}