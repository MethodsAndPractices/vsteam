Set-StrictMode -Version Latest

#region inclucde
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
   ## Arrange
   Mock _getInstance { return 'https://dev.azure.com/test' }

   $results = Get-Content "$PSScriptRoot\sampleFiles\extensionResults.json" -Raw | ConvertFrom-Json
   $singleResult = Get-Content "$PSScriptRoot\sampleFiles\singleExtensionResult.json" -Raw | ConvertFrom-Json

   Context 'Get-VSTeamExtension' {
      ## Arrange
      BeforeAll {
         $env:Team_TOKEN = '1234'
      }

      AfterAll {
         $env:TEAM_TOKEN = $null
      }

      Mock _callAPI { return $results }
      Mock _callAPI { return $singleResult } -ParameterFilter { $resource -eq "extensionmanagement/installedextensionsbyname/test/test" }

      It 'Should return extensions' {
         ## Act
         Get-VSTeamExtension

         ## Assert
         Assert-MockCalled _callAPI -Exactly 1 -Scope It -ParameterFilter {
            $Method -eq 'Get' -and
            $subDomain -eq 'extmgmt' -and
            $version -eq [VSTeamVersions]::ExtensionsManagement
            $Url -like "*https://extmgmt.dev.azure.com/test/_apis/_apis/extensionmanagement/installedextensions*"
         }
      }

      It 'Should return extensions with optional parameters' {
         ## Act
         Get-VSTeamExtension -IncludeInstallationIssues -IncludeDisabledExtensions -IncludeErrors

         ## Assert
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
         ## Act
         Get-VSTeamExtension -PublisherId test -ExtensionId test

         ## Assert
         Assert-MockCalled _callAPI -Exactly 1 -Scope It -ParameterFilter {
            $Method -eq 'Get' -and
            $subDomain -eq 'extmgmt' -and
            $version -eq [VSTeamVersions]::ExtensionsManagement
            $Url -like "*https://extmgmt.dev.azure.com/test/_apis/_apis/extensionmanagement/installedextensionsbyname/test/test*"
         }
      }
   }
}