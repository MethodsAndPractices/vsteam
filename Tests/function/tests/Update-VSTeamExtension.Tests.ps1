Set-StrictMode -Version Latest

Describe 'VSTeamExtension' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable

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
            lastUpdated = [datetime]'2018-10-09T11:26:47.187Z'
         }
      }
   }

   Context 'Update-VSTeamExtension' {
      BeforeAll {
         $env:Team_TOKEN = '1234'

         Mock _callAPI { return $singleResult }
      }

      AfterAll {
         $env:TEAM_TOKEN = $null
      }

      It 'Should update an extension' {
         Update-VSTeamExtension -PublisherId 'test' -ExtensionId 'test' -ExtensionState disabled -Force

         Should -Invoke _callAPI -Exactly 1 -Scope It -ParameterFilter {
            $Method -eq 'Post' -and
            $subDomain -eq 'extmgmt' -and
            $version -eq [vsteam_lib.Versions]::ExtensionsManagement
            $Url -like "*https://extmgmt.dev.azure.com/test/_apis/_apis/extensionmanagement/installedextensionsbyname/test/test*"
         }
      }
   }
}