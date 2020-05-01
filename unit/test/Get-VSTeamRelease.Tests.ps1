Set-StrictMode -Version Latest

#region include
Import-Module SHiPS

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamLeaf.ps1"
. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamFeed.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Private/applyTypes.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe 'VSTeamRelease' {
   . "$PSScriptRoot\mocks\mockProjectNameDynamicParamNoPSet.ps1"

   [VSTeamVersions]::Release = '1.0-unittest'
   $results = Get-Content "$PSScriptRoot\sampleFiles\releaseResults.json" -Raw | ConvertFrom-Json
   $singleResult = Get-Content "$PSScriptRoot\sampleFiles\releaseSingleReult.json" -Raw | ConvertFrom-Json

   Mock _getInstance { return 'https://dev.azure.com/test' }
   Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Release' }
   
   Mock Invoke-RestMethod { return $results }
   Mock Invoke-RestMethod { return $singleResult } -ParameterFilter {
      $Uri -like "*15*"
   }

   Context 'Get-VSTeamRelease' {

      It 'by Id -Raw should return release as Raw' {
         ## Act
         $raw = Get-VSTeamRelease -ProjectName project -Id 15 -Raw

         ## Assert
         $raw | Get-Member | Select-Object -First 1 -ExpandProperty TypeName | Should be 'System.Management.Automation.PSCustomObject'

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://vsrm.dev.azure.com/test/project/_apis/release/releases/15?api-version=$(_getApiVersion Release)"
         }
      }

      It 'by Id should return release as Object' {
         ## Act
         $r = Get-VSTeamRelease -ProjectName project -Id 15

         ## Assert
         $r | Get-Member | Select-Object -First 1 -ExpandProperty TypeName | Should be 'Team.Release'

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://vsrm.dev.azure.com/test/project/_apis/release/releases/15?api-version=$(_getApiVersion Release)"
         }
      }

      It 'by Id -JSON should return release as JSON' {
         ## Act
         $r = Get-VSTeamRelease -ProjectName project -Id 15 -JSON

         ## Assert
         $r | Get-Member | Select-Object -First 1 -ExpandProperty TypeName | Should be 'System.String'

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://vsrm.dev.azure.com/test/project/_apis/release/releases/15?api-version=$(_getApiVersion Release)"
         }
      }

      It 'with no parameters should return releases' {
         ## Act
         Get-VSTeamRelease -projectName project

         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://vsrm.dev.azure.com/test/project/_apis/release/releases?api-version=$(_getApiVersion Release)"
         }
      }

      It 'with expand environments should return releases' {
         ## Act
         Get-VSTeamRelease -projectName project -expand environments

         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://vsrm.dev.azure.com/test/project/_apis/release/releases?api-version=$(_getApiVersion Release)&`$expand=environments"
         }
      }

      It 'with no parameters & no project should return releases' {
         ## Act
         Get-VSTeamRelease

         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://vsrm.dev.azure.com/test/_apis/release/releases?api-version=$(_getApiVersion Release)"
         }
      }
   }
}