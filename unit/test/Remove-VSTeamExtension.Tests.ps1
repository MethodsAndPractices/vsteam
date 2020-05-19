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

      $singleResult = Get-Content "$PSScriptRoot\sampleFiles\singleExtensionResult.json" -Raw | ConvertFrom-Json

      Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable
   }

   Context 'Remove-VSTeamExtension' {
      BeforeAll {
         $env:Team_TOKEN = '1234'

         Mock _callAPI { return $singleResult }
      }

      AfterAll {
         $env:TEAM_TOKEN = $null
      }

      It 'Should remove an extension' {
         Remove-VSTeamExtension -PublisherId 'test' -ExtensionId 'test' -Force

         Should -Invoke _callAPI -Exactly 1 -Scope It -ParameterFilter {
            $Method -eq 'Delete' -and
            $subDomain -eq 'extmgmt' -and
            $version -eq [VSTeamVersions]::ExtensionsManagement
            $Url -like "*https://extmgmt.dev.azure.com/test/_apis/_apis/extensionmanagement/installedextensionsbyname/test/test*"
         }
      }
   }
}