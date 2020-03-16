Set-StrictMode -Version Latest

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

$results = Get-Content "$PSScriptRoot\sampleFiles\releaseResults.json" -Raw | ConvertFrom-Json
$singleResult = Get-Content "$PSScriptRoot\sampleFiles\releaseSingleReult.json" -Raw | ConvertFrom-Json

Describe 'VSTeamRelease' {
   Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable
   [VSTeamVersions]::Release = '1.0-unittest'
   
   # Mock the call to Get-Projects by the dynamic parameter for ProjectName
   Mock Invoke-RestMethod { return @() } -ParameterFilter {
      $Uri -like "*_apis/projects*"
   }

   . "$PSScriptRoot\mocks\mockProjectNameDynamicParamNoPSet.ps1"

   Context 'Get-VSTeamRelease by ID -Raw' {
      Mock _useWindowsAuthenticationOnPremise { return $true }
      Mock Invoke-RestMethod {
         return $singleResult
      }

      It 'should return release as Raw' {
         $raw = Get-VSTeamRelease -ProjectName project -Id 15 -Raw

         $raw | Get-Member | Select-Object -First 1 -ExpandProperty TypeName | Should be 'System.Management.Automation.PSCustomObject'

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://vsrm.dev.azure.com/test/project/_apis/release/releases/15?api-version=$([VSTeamVersions]::Release)"
         }
      }
   }

   Context 'Get-VSTeamRelease by ID' {
      Mock _useWindowsAuthenticationOnPremise { return $true }
      Mock Invoke-RestMethod {
         return $singleResult
      }

      It 'should return release as Object' {
         $r = Get-VSTeamRelease -ProjectName project -Id 15

         $r | Get-Member | Select-Object -First 1 -ExpandProperty TypeName | Should be 'Team.Release'

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://vsrm.dev.azure.com/test/project/_apis/release/releases/15?api-version=$([VSTeamVersions]::Release)"
         }
      }
   }

   Context 'Get-VSTeamRelease by ID -JSON' {
      Mock _useWindowsAuthenticationOnPremise { return $true }
      Mock Invoke-RestMethod {
         return $singleResult
      }

      It 'should return release as JSON' {
         $r = Get-VSTeamRelease -ProjectName project -Id 15 -JSON

         $r | Get-Member | Select-Object -First 1 -ExpandProperty TypeName | Should be 'System.String'

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://vsrm.dev.azure.com/test/project/_apis/release/releases/15?api-version=$([VSTeamVersions]::Release)"
         }
      }
   }
      
   Context 'Get-VSTeamRelease with no parameters' {
      Mock _useWindowsAuthenticationOnPremise { return $true }
      Mock Invoke-RestMethod {
         return $results
      }

      It 'should return releases' {
         Get-VSTeamRelease -projectName project

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://vsrm.dev.azure.com/test/project/_apis/release/releases?api-version=$([VSTeamVersions]::Release)"
         }
      }
   }

   Context 'Get-VSTeamRelease with expand environments' {
      Mock _useWindowsAuthenticationOnPremise { return $true }
      Mock Invoke-RestMethod {
         return $results
      }

      It 'should return releases' {
         Get-VSTeamRelease -projectName project -expand environments

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://vsrm.dev.azure.com/test/project/_apis/release/releases?api-version=$([VSTeamVersions]::Release)&`$expand=environments"
         }
      }
   }

   Context 'Get-VSTeamRelease with no parameters & no project' {
      Mock _useWindowsAuthenticationOnPremise { return $true }
      Mock Invoke-RestMethod {
         return $results
      }

      It 'should return releases' {
         Get-VSTeamRelease

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://vsrm.dev.azure.com/test/_apis/release/releases?api-version=$([VSTeamVersions]::Release)"
         }
      }
   }
}