Set-StrictMode -Version Latest

#region include
Import-Module SHiPS

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamLeaf.ps1"
. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamInstallState.ps1"
. "$here/../../Source/Classes/VSTeamExtension.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe 'VSTeamExtension' {
   $singleResult = Get-Content "$PSScriptRoot\sampleFiles\singleExtensionResult.json" -Raw | ConvertFrom-Json

   Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable

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