Set-StrictMode -Version Latest

#region include
Import-Module SHiPS

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Classes/ProjectCompleter.ps1"
. "$here/../../Source/Classes/ProjectValidateAttribute.ps1"
. "$here/../../Source/Classes/VSTeamLeaf.ps1"
. "$here/../../Source/Classes/VSTeamUserEntitlement.ps1"
. "$here/../../Source/Classes/VSTeamReleaseDefinition.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe 'VSTeamReleaseDefinition' {
   $results = Get-Content "$PSScriptRoot\sampleFiles\releaseDefAzD.json" -Raw | ConvertFrom-Json
   
   Mock _getProjects { return $null }
   Mock _hasProjectCacheExpired { return $true }
   Mock Invoke-RestMethod { return $results }
   Mock Invoke-RestMethod { return $results.value[0] } -ParameterFilter { $Uri -like "*15*" }
   Mock _getInstance { return 'https://dev.azure.com/test' }
   Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Release' }

   Context 'Get-VSTeamReleaseDefinition' {
      It 'no parameters should return Release definitions' {
         ## Act
         Get-VSTeamReleaseDefinition -projectName project

         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://vsrm.dev.azure.com/test/project/_apis/release/definitions?api-version=$(_getApiVersion Release)"
         }
      }

      It 'expand environments should return Release definitions' {
         ## Act
         Get-VSTeamReleaseDefinition -projectName project -expand environments

         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://vsrm.dev.azure.com/test/project/_apis/release/definitions?api-version=$(_getApiVersion Release)&`$expand=environments"
         }
      }

      It 'by Id should return Release definition' {
         ## Act
         Get-VSTeamReleaseDefinition -projectName project -id 15

         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://vsrm.dev.azure.com/test/project/_apis/release/definitions/15?api-version=$(_getApiVersion Release)"
         }
      }
   }
}