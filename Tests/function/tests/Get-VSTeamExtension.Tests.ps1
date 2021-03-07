Set-StrictMode -Version Latest

Describe 'VSTeamExtension' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
   
      ## Arrange
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'ExtensionsManagement' }
   }

   Context 'Get-VSTeamExtension' {
      BeforeAll {
         ## Arrange
         $env:Team_TOKEN = '1234'

         Mock _callAPI { Open-SampleFile 'extensionResults.json' }
         Mock _callAPI { Open-SampleFile 'singleExtensionResult.json' } -ParameterFilter { $id -eq "test/test" }
      }

      AfterAll {
         $env:TEAM_TOKEN = $null
      }

      It 'Should return extensions' {
         ## Act
         Get-VSTeamExtension

         ## Assert
         Should -Invoke _callAPI -Exactly 1 -Scope It -ParameterFilter {
            $subDomain -eq 'extmgmt' -and
            $area -eq 'extensionmanagement' -and
            $resource -eq 'installedextensions' -and
            $version -eq $(_getApiVersion ExtensionsManagement)
         }
      }

      It 'Should return extensions with optional parameters' {
         ## Act
         Get-VSTeamExtension -IncludeInstallationIssues -IncludeDisabledExtensions -IncludeErrors

         ## Assert
         Should -Invoke _callAPI -Exactly 1 -Scope It -ParameterFilter {
            $subDomain -eq 'extmgmt' -and
            $area -eq 'extensionmanagement' -and
            $resource -eq 'installedextensions' -and
            $version -eq $(_getApiVersion ExtensionsManagement)
         }
      }

      It 'Should return the extension' {
         ## Act
         Get-VSTeamExtension -PublisherId test -ExtensionId test

         ## Assert
         Should -Invoke _callAPI -Exactly 1 -Scope It -ParameterFilter {
            $id -eq 'test/test' -and
            $subDomain -eq 'extmgmt' -and
            $area -eq 'extensionmanagement' -and
            $resource -eq 'installedextensionsbyname' -and
            $version -eq $(_getApiVersion ExtensionsManagement)
         }
      }
   }
}