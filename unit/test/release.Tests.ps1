Set-StrictMode -Version Latest

Get-Module VSTeam | Remove-Module -Force
# Required for the dynamic parameter
Import-Module $PSScriptRoot\..\..\src\team.psm1 -Force
Import-Module $PSScriptRoot\..\..\src\releases.psm1 -Force

# Loading System.Web avoids issues finding System.Web.HttpUtility
Add-Type -AssemblyName 'System.Web'

InModuleScope Releases {
   $VSTeamVersionTable.Account = 'https://test.visualstudio.com'
   $VSTeamVersionTable.Release = '1.0-unittest'

   $results = [PSCustomObject]@{
      value = [PSCustomObject]@{
         environments = [PSCustomObject]@{}
         _links       = [PSCustomObject]@{ 
            self = [PSCustomObject]@{}
            web  = [PSCustomObject]@{}
         }
      }
   }

   $singleResult = [PSCustomObject]@{
      environments = [PSCustomObject]@{}
      _links       = [PSCustomObject]@{ 
         self = [PSCustomObject]@{}
         web  = [PSCustomObject]@{}
      }
   }

   Describe 'Releases' {
      . "$PSScriptRoot\mockProjectNameDynamicParamNoPSet.ps1"

      Context 'Show-VSTeamRelease by ID' {
         Mock _openOnWindows { }
         Mock _isOnWindows { return $true }

         it 'should show release' {
            Show-VSTeamRelease -projectName project -Id 15

            Assert-MockCalled _openOnWindows -Exactly -Scope It -Times 1 -ParameterFilter {
               $command -eq 'https://test.visualstudio.com/project/_release?releaseId=15'
            }
         }
      }

      Context 'Show-VSTeamRelease with invalid ID' {
         it 'should show release' {
            { Show-VSTeamRelease -projectName project -Id 0 } | Should throw 
         }
      }

      Context 'Remove-VSTeamRelease by ID' {
         Mock Invoke-RestMethod

         It 'should return releases' {
            Remove-VSTeamRelease -ProjectName project -Id 15 -Force

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter { 
               $Method -eq 'Delete' -and
               $Uri -eq "https://test.vsrm.visualstudio.com/project/_apis/release/releases/15?api-version=$($VSTeamVersionTable.Release)"
            }
         }
      }

      Context 'Set-VSTeamReleaseStatus by ID' {
         Mock _useWindowsAuthenticationOnPremise { return $true }
         Mock Invoke-RestMethod

         It 'should set release status' {
            Set-VSTeamReleaseStatus -ProjectName project -Id 15 -Status Abandoned -Force

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Method -eq 'Patch' -and
               $Body -eq '{ "status": "Abandoned" }' -and
               $Uri -eq "https://test.vsrm.visualstudio.com/project/_apis/release/releases/15?api-version=$($VSTeamVersionTable.Release)"
            }
         }
      }

      Context 'Get-VSTeamRelease by ID' {
         Mock _useWindowsAuthenticationOnPremise { return $true }
         Mock Invoke-RestMethod {
            return $singleResult 
         }

         It 'should return releases' {
            Get-VSTeamRelease -ProjectName project -Id 15

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter { 
               $Uri -eq "https://test.vsrm.visualstudio.com/project/_apis/release/releases/15?api-version=$($VSTeamVersionTable.Release)"
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
               $Uri -eq "https://test.vsrm.visualstudio.com/project/_apis/release/releases/?api-version=$($VSTeamVersionTable.Release)"
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
               $Uri -eq "https://test.vsrm.visualstudio.com/project/_apis/release/releases/?api-version=$($VSTeamVersionTable.Release)&`$expand=environments"
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
               $Uri -eq "https://test.vsrm.visualstudio.com/_apis/release/releases/?api-version=$($VSTeamVersionTable.Release)"
            }
         }
      }   
      
      Context 'Set-VSTeamEnvironmentStatus by ID' {
         Mock _useWindowsAuthenticationOnPremise { return $false }
         Mock Invoke-RestMethod

         $expectedBody = ConvertTo-Json ([PSCustomObject]@{status = 'inProgress'; comment = ''; scheduledDeploymentTime = $null})

         It 'should set environments' {
            Set-VSTeamEnvironmentStatus -ProjectName project -ReleaseId 1 -Id 15 -Status inProgress -Force

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Method -eq 'Patch' -and
               $Body -eq $expectedBody -and
               $Uri -eq "https://test.vsrm.visualstudio.com/project/_apis/release/releases/1/environments/15?api-version=$($VSTeamVersionTable.Release)"
            }
         }
      }
   }
}