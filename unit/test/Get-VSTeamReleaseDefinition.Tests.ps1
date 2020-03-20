Set-StrictMode -Version Latest

#region include
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Classes/VSTeamLeaf.ps1"
. "$here/../../Source/Classes/VSTeamUserEntitlement.ps1"
. "$here/../../Source/Classes/VSTeamReleaseDefinition.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe 'VSTeamReleaseDefinition' {
   . "$PSScriptRoot\mocks\mockProjectNameDynamicParamNoPSet.ps1"

   [VSTeamVersions]::Release = '1.0-unittest'

   $results = Get-Content "$PSScriptRoot\sampleFiles\releaseDefAzD.json" -Raw | ConvertFrom-Json
   
   Mock Invoke-RestMethod { return $results }
   Mock Invoke-RestMethod { return $results.value[0] } -ParameterFilter { $Uri -like "*15*" }
   Mock _getInstance { return 'https://dev.azure.com/test' }

   Context 'Get-VSTeamReleaseDefinition' {
      It 'no parameters should return Release definitions' {
         ## Act
         Get-VSTeamReleaseDefinition -projectName project

         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://vsrm.dev.azure.com/test/project/_apis/release/definitions?api-version=$([VSTeamVersions]::Release)"
         }
      }

      It 'expand environments should return Release definitions' {
         ## Act
         Get-VSTeamReleaseDefinition -projectName project -expand environments

         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://vsrm.dev.azure.com/test/project/_apis/release/definitions?api-version=$([VSTeamVersions]::Release)&`$expand=environments"
         }
      }

      It 'by Id should return Release definition' {
         ## Act
         Get-VSTeamReleaseDefinition -projectName project -id 15

         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://vsrm.dev.azure.com/test/project/_apis/release/definitions/15?api-version=$([VSTeamVersions]::Release)"
         }
      }
   }
}