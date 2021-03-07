Set-StrictMode -Version Latest

Describe 'VSTeamExtension' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
   }
   
   Context 'Remove-VSTeamExtension' {
      BeforeAll {
         $env:Team_TOKEN = '1234'
         Mock _callAPI { Open-SampleFile 'singleExtensionResult.json' }
         Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable
      }

      AfterAll {
         $env:TEAM_TOKEN = $null
      }

      It 'Should remove an extension' {
         Remove-VSTeamExtension -PublisherId 'test' -ExtensionId 'test' -Force

         Should -Invoke _callAPI -Exactly 1 -Scope It -ParameterFilter {
            $Method -eq 'Delete' -and
            $subDomain -eq 'extmgmt' -and
            $version -eq [vsteam_lib.Versions]::ExtensionsManagement
            $Url -like "*https://extmgmt.dev.azure.com/test/_apis/_apis/extensionmanagement/installedextensionsbyname/test/test*"
         }
      }
   }
}