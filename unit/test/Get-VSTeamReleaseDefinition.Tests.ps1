Set-StrictMode -Version Latest

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

# Loading System.Web avoids issues finding System.Web.HttpUtility
Add-Type -AssemblyName 'System.Web'


[VSTeamVersions]::Account = 'https://dev.azure.com/test'
[VSTeamVersions]::Release = '1.0-unittest'

$results = Get-Content "$PSScriptRoot\sampleFiles\releaseDefAzD.json" -Raw | ConvertFrom-Json

Describe 'Get-VSTeamReleaseDefinition' {
   # Mock the call to Get-Projects by the dynamic parameter for ProjectName
   Mock Invoke-RestMethod { return @() } -ParameterFilter {
      $Uri -like "*_apis/projects*"
   }

   . "$PSScriptRoot\mocks\mockProjectNameDynamicParamNoPSet.ps1"

   Context 'no parameters' {
      Mock _useWindowsAuthenticationOnPremise { return $true }
      Mock Invoke-RestMethod {
         return $results
      }

      It 'should return Release definitions' {
         Get-VSTeamReleaseDefinition -projectName project

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://vsrm.dev.azure.com/test/project/_apis/release/definitions/?api-version=$([VSTeamVersions]::Release)"
         }
      }
   }

   Context 'expand environments' {
      Mock _useWindowsAuthenticationOnPremise { return $true }
      Mock Invoke-RestMethod {
         return $results
      }

      It 'should return Release definitions' {
         Get-VSTeamReleaseDefinition -projectName project -expand environments

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://vsrm.dev.azure.com/test/project/_apis/release/definitions/?api-version=$([VSTeamVersions]::Release)&`$expand=environments"
         }
      }
   }

   Context 'by ID' {
      Mock Invoke-RestMethod { return $results.value[0] }

      It 'should return Release definition' {
         Get-VSTeamReleaseDefinition -projectName project -id 15

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://vsrm.dev.azure.com/test/project/_apis/release/definitions/15?api-version=$([VSTeamVersions]::Release)"
         }
      }
   }

   # Make sure these test run last as the need differnt
   # [VSTeamVersions]::Account values
   Context 'no account' {
      [VSTeamVersions]::Account = $null

      It 'should return Release definitions' {
         { Get-VSTeamReleaseDefinition -projectName project } | Should Throw
      }
   }
}