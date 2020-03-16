Set-StrictMode -Version Latest

Import-Module SHiPS

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamLeaf.ps1"
. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamInstallState.ps1"
. "$here/../../Source/Classes/VSTeamExtension.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/$sut"

Describe 'VSTeamExtension' {
   Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable
      
   $results = Get-Content "$PSScriptRoot\sampleFiles\extensionResults.json" -Raw | ConvertFrom-Json
   $singleResult = Get-Content "$PSScriptRoot\sampleFiles\singleExtensionResult.json" -Raw | ConvertFrom-Json

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
}