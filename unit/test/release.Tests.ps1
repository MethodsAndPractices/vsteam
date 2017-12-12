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
`
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

         It 'should return releases' {
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

      # Context 'Get-VSTeamRelease with expand environments' {
      #    Mock _useWindowsAuthenticationOnPremise { return $true }
      #    Mock Invoke-RestMethod {
      #       return $results 
      #    }

      #    It 'should return Release releases' {
      #       Get-VSTeamRelease -projectName project -expand environments

      #       Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter { 
      #          $Uri -eq "https://test.vsrm.visualstudio.com/project/_apis/release/releases/?api-version=$($VSTeamVersionTable.Release)&`$expand=environments"
      #       }
      #    }
      # }

      # Context 'Add-VSTeamRelease' {
      #    Mock Invoke-RestMethod {
      #       return $results 
      #    }

      #    it 'Should add Release' {
      #       Add-VSTeamRelease -projectName project -inFile 'Releasedef.json'

      #       Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
      #          $Method -eq 'Post' -and
      #          $InFile -eq 'Releasedef.json' -and
      #          $Uri -eq "https://test.vsrm.visualstudio.com/project/_apis/release/releases/?api-version=$($VSTeamVersionTable.Release)"
      #       }
      #    }
      # }

      # Context 'Get-VSTeamRelease by ID' {
      #    Mock Invoke-RestMethod { return [PSCustomObject]@{
      #          queue           = [PSCustomObject]@{ name = 'Default' }
      #          _links          = [PSCustomObject]@{ 
      #             self = [PSCustomObject]@{}
      #             web  = [PSCustomObject]@{}
      #          }
      #          retentionPolicy = [PSCustomObject]@{}
      #          lastRelease     = [PSCustomObject]@{}
      #          artifacts       = [PSCustomObject]@{}
      #          modifiedBy      = [PSCustomObject]@{ name = 'project' }
      #          createdBy       = [PSCustomObject]@{ name = 'test'}
      #       }
      #    }

      #    It 'should return Release definition' {
      #       Get-VSTeamRelease -projectName project -id 15

      #       Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
      #          $Uri -eq "https://test.vsrm.visualstudio.com/project/_apis/release/releases/15?api-version=$($VSTeamVersionTable.Release)"
      #       }
      #    }
      # }

      # Context 'Remove-VSTeamRelease' {
      #    Mock Invoke-RestMethod { return $results }

      #    It 'should delete Release definition' {
      #       Remove-VSTeamRelease -projectName project -id 2 -Force

      #       Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
      #          $Method -eq 'Delete' -and 
      #          $Uri -eq "https://test.vsrm.visualstudio.com/project/_apis/release/releases/2?api-version=$($VSTeamVersionTable.Release)"
      #       }
      #    }
      # }

      # # Make sure these test run last as the need differnt 
      # # $VSTeamVersionTable.Account values
      # Context 'Get-VSTeamRelease with no account' {
      #    $VSTeamVersionTable.Account = $null

      #    It 'should return Release releases' {
      #       { Get-VSTeamRelease -projectName project } | Should Throw
      #    }
      # }

      # Context 'Add-VSTeamRelease on TFS local Auth' {
      #    Mock Invoke-RestMethod { return $results }
      #    Mock _useWindowsAuthenticationOnPremise { return $true }
      #    $VSTeamVersionTable.Account = 'http://localhost:8080/tfs/defaultcollection'

      #    it 'Should add Release' {
      #       Add-VSTeamRelease -projectName project -inFile 'Releasedef.json'

      #       Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
      #          $Method -eq 'Post' -and
      #          $InFile -eq 'Releasedef.json' -and
      #          $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/release/releases/?api-version=$($VSTeamVersionTable.Release)"
      #       }
      #    }
      # }

      # Context 'Remove-VSTeamRelease on TFS local Auth' {
      #    Mock Invoke-RestMethod { return $results }
      #    Mock _useWindowsAuthenticationOnPremise { return $true }
      #    $VSTeamVersionTable.Account = 'http://localhost:8080/tfs/defaultcollection'

      #    Remove-VSTeamRelease -projectName project -id 2 -Force
         
      #    It 'should delete Release definition' {
      #       Assert-MockCalled Invoke-RestMethod -Exactly -Scope Context -Times 1 -ParameterFilter {
      #          $Method -eq 'Delete' -and 
      #          $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/release/releases/2?api-version=$($VSTeamVersionTable.Release)"
      #       }
      #    }
      # }
   }
}