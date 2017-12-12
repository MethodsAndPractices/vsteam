Set-StrictMode -Version Latest

Get-Module VSTeam | Remove-Module -Force
# Required for the dynamic parameter
Import-Module $PSScriptRoot\..\..\src\team.psm1 -Force
Import-Module $PSScriptRoot\..\..\src\ReleaseDefinitions.psm1 -Force

# Loading System.Web avoids issues finding System.Web.HttpUtility
Add-Type -AssemblyName 'System.Web'

InModuleScope ReleaseDefinitions {
   $VSTeamVersionTable.Account = 'https://test.visualstudio.com'
   $VSTeamVersionTable.Release = '1.0-unittest'

   $results = [PSCustomObject]@{
      value = [PSCustomObject]@{
         queue           = [PSCustomObject]@{ name = 'Default' }
         _links          = [PSCustomObject]@{ 
            self = [PSCustomObject]@{}
            web  = [PSCustomObject]@{}
         }
         retentionPolicy = [PSCustomObject]@{}
         lastRelease     = [PSCustomObject]@{}
         artifacts       = [PSCustomObject]@{}
         modifiedBy      = [PSCustomObject]@{ name = 'project' }
         createdBy       = [PSCustomObject]@{ name = 'test'}
      }
   }

   Describe 'ReleaseDefinitions' {
      . "$PSScriptRoot\mockProjectNameDynamicParamNoPSet.ps1"

      Context 'Show-VSTeamReleaseDefinition by ID' {
         Mock _openOnWindows { }
         Mock _isOnWindows { return $true }

         it 'should return Release definitions' {
            Show-VSTeamReleaseDefinition -projectName project -Id 15

            Assert-MockCalled _openOnWindows -Exactly -Scope It -Times 1 -ParameterFilter {
               $command -eq 'https://test.visualstudio.com/project/_release?definitionId=15'
            }
         }
      }
    
      Context 'Get-VSTeamReleaseDefinition with no parameters' {
         Mock _useWindowsAuthenticationOnPremise { return $true }
         Mock Invoke-RestMethod {
            return $results 
         }

         It 'should return Release definitions' {
            Get-VSTeamReleaseDefinition -projectName project

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter { 
               $Uri -eq "https://test.vsrm.visualstudio.com/project/_apis/release/definitions/?api-version=$($VSTeamVersionTable.Release)"
            }
         }
      }

      Context 'Add-VSTeamReleaseDefinition' {
         Mock Invoke-RestMethod {
            return $results 
         }

         it 'Should add Release' {
            Add-VSTeamReleaseDefinition -projectName project -inFile 'Releasedef.json'

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Method -eq 'Post' -and
               $InFile -eq 'Releasedef.json' -and
               $Uri -eq "https://test.vsrm.visualstudio.com/project/_apis/release/definitions/?api-version=$($VSTeamVersionTable.Release)"
            }
         }
      }

      Context 'Get-VSTeamReleaseDefinition by ID' {
         Mock Invoke-RestMethod { return [PSCustomObject]@{
               queue           = [PSCustomObject]@{ name = 'Default' }
               _links          = [PSCustomObject]@{ 
                  self = [PSCustomObject]@{}
                  web  = [PSCustomObject]@{}
               }
               retentionPolicy = [PSCustomObject]@{}
               lastRelease     = [PSCustomObject]@{}
               artifacts       = [PSCustomObject]@{}
               modifiedBy      = [PSCustomObject]@{ name = 'project' }
               createdBy       = [PSCustomObject]@{ name = 'test'}
            }
         }

         It 'should return Release definition' {
            Get-VSTeamReleaseDefinition -projectName project -id 15

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://test.vsrm.visualstudio.com/project/_apis/release/definitions/15?api-version=$($VSTeamVersionTable.Release)"
            }
         }
      }

      Context 'Remove-VSTeamReleaseDefinition' {
         Mock Invoke-RestMethod { return $results }

         It 'should delete Release definition' {
            Remove-VSTeamReleaseDefinition -projectName project -id 2 -Force

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Method -eq 'Delete' -and 
               $Uri -eq "https://test.vsrm.visualstudio.com/project/_apis/release/definitions/2?api-version=$($VSTeamVersionTable.Release)"
            }
         }
      }

      # Make sure these test run last as the need differnt 
      # $VSTeamVersionTable.Account values
      Context 'Get-VSTeamReleaseDefinition with no account' {
         $VSTeamVersionTable.Account = $null

         It 'should return Release definitions' {
            { Get-VSTeamReleaseDefinition -projectName project } | Should Throw
         }
      }

      Context 'Add-VSTeamReleaseDefinition on TFS local Auth' {
         Mock Invoke-RestMethod { return $results }
         Mock _useWindowsAuthenticationOnPremise { return $true }
         $VSTeamVersionTable.Account = 'http://localhost:8080/tfs/defaultcollection'

         it 'Should add Release' {
            Add-VSTeamReleaseDefinition -projectName project -inFile 'Releasedef.json'

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Method -eq 'Post' -and
               $InFile -eq 'Releasedef.json' -and
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/release/definitions/?api-version=$($VSTeamVersionTable.Release)"
            }
         }
      }

      Context 'Remove-VSTeamReleaseDefinition on TFS local Auth' {
         Mock Invoke-RestMethod { return $results }
         Mock _useWindowsAuthenticationOnPremise { return $true }
         $VSTeamVersionTable.Account = 'http://localhost:8080/tfs/defaultcollection'

         Remove-VSTeamReleaseDefinition -projectName project -id 2 -Force
         
         It 'should delete Release definition' {
            Assert-MockCalled Invoke-RestMethod -Exactly -Scope Context -Times 1 -ParameterFilter {
               $Method -eq 'Delete' -and 
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/release/definitions/2?api-version=$($VSTeamVersionTable.Release)"
            }
         }
      }
   }
}