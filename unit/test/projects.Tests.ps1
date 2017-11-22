Set-StrictMode -Version Latest

Get-Module team | Remove-Module -Force
Import-Module $PSScriptRoot\..\..\src\team.psm1 -Force
Import-Module $PSScriptRoot\..\..\src\projects.psm1 -Force

InModuleScope projects {
   $VSTeamVersionTable.Account = 'https://test.visualstudio.com'

   Describe 'Project' {
      . "$PSScriptRoot\mockProjectNameDynamicParam.ps1"

      Context 'Show-VSTeamProject by ID on Windows' {
         Mock _openOnWindows
         Mock _isOnWindows { return $true }

         It 'Show call start' {
            Show-VSTeamProject -Id 123456

            Assert-MockCalled _openOnWindows
         }
      }

      Context 'Show-VSTeamProject by ProjectName on Mac' {
         Mock _isOnMac { return $true }
         Mock _isOnWindows { return $false }
         Mock _openOnMac
         
         It 'Show call open' {
            Show-VSTeamProject -ProjectName MyProject

            Assert-MockCalled _openOnMac
         }
      }

      Context 'Show-VSTeamProject by default parameter on Linux' {
         Mock _isOnMac { return $false }
         Mock _isOnWindows { return $false }
         Mock _openOnLinux

         It 'Show call open' {
            Show-VSTeamProject MyProject

            Assert-MockCalled _openOnLinux
         }
      }

      Context 'Get-VSTeamProject with no parameters' {

         Mock Invoke-RestMethod { return @{value = 'projects'}}

         It 'Should return projects' {
            Get-VSTeamProject

            # Make sure it was called with the correct URI
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/_apis/projects/?api-version=$($VSTeamVersionTable.Core)&stateFilter=WellFormed&`$top=100&`$skip=0"
            }
         }
      }

      Context 'Get-VSTeamProject with top 10' {

         Mock Invoke-RestMethod { return @{value = 'projects'}}

         It 'Should return top 10 projects' {
            Get-VSTeamProject -top 10

            # Make sure it was called with the correct URI
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Uri -eq "https://test.visualstudio.com/_apis/projects/?api-version=$($VSTeamVersionTable.Core)&stateFilter=WellFormed&`$top=10&`$skip=0" }
         }
      }

      Context 'Get-VSTeamProject with skip 1' {

         Mock Invoke-RestMethod { return @{value = 'projects'}}

         It 'Should skip first project' {
            Get-VSTeamProject -skip 1

            # Make sure it was called with the correct URI
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Uri -eq "https://test.visualstudio.com/_apis/projects/?api-version=$($VSTeamVersionTable.Core)&stateFilter=WellFormed&`$top=100&`$skip=1" }
         }
      }

      Context 'Get-VSTeamProject with stateFilter All' {

         Mock Invoke-RestMethod { return @{value = 'projects'}}

         It 'Should return All projects' {
            Get-VSTeamProject -stateFilter 'All'

            # Make sure it was called with the correct URI
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Uri -eq "https://test.visualstudio.com/_apis/projects/?api-version=$($VSTeamVersionTable.Core)&stateFilter=All&`$top=100&`$skip=0" }
         }
      }

      Context 'Get-VSTeamProject with no Capabilities' {

         Mock Invoke-RestMethod { return @{value = 'projects'}}

         It 'Should return the project' {
            Get-VSTeamProject -ProjectName Test

            # Make sure it was called with the correct URI
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Uri -eq "https://test.visualstudio.com/_apis/projects/Test?api-version=$($VSTeamVersionTable.Core)" }
         }
      }

      Context 'Get-VSTeamProject with Capabilities' {

         Mock Invoke-RestMethod { return 'project'}

         It 'Should return the project with capabilities' {
            Get-VSTeamProject -projectId Test -includeCapabilities

            # Make sure it was called with the correct URI
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Uri -eq "https://test.visualstudio.com/_apis/projects/Test?api-version=$($VSTeamVersionTable.Core)&includeCapabilities=true" }
         }
      }

      Context 'Update-VSTeamProject with no op' {
         Mock Invoke-RestMethod { return @{id = '123-5464-dee43'} } 

         It 'Should call Invoke-RestMethod only once' {
            Update-VSTeamProject -ProjectName Test

            Assert-MockCalled Invoke-RestMethod -Exactly 1
         }
      }

      Context 'Update-VSTeamProject with newName' {

         Mock Invoke-RestMethod { return @{id = '123-5464-dee43'} } -ParameterFilter { $Uri -eq "https://test.visualstudio.com/_apis/projects/Test?api-version=$($VSTeamVersionTable.Core)" }
         Mock Invoke-RestMethod { return @{status = 'inProgress'; url = 'https://someplace.com'} } -ParameterFilter { $Method -eq 'Patch'}
         Mock _trackProgress
         Mock Invoke-RestMethod { return @{id = '123-5464-dee43'} } -ParameterFilter { $Uri -eq "https://test.visualstudio.com/_apis/projects/Testing123?api-version=$($VSTeamVersionTable.Core)" }

         It 'Should change name' {
            Update-VSTeamProject -ProjectName Test -newName Testing123 -Force

            Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter { $Uri -eq "https://test.visualstudio.com/_apis/projects/Test?api-version=$($VSTeamVersionTable.Core)" }
            Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter { $Method -eq 'Patch' -and $Body -eq '{"name": "Testing123"}'}
            Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter { $Uri -eq "https://test.visualstudio.com/_apis/projects/Testing123?api-version=$($VSTeamVersionTable.Core)" }
         }
      }

      Context 'Update-VSTeamProject with newDescription' {

         Mock Invoke-RestMethod { return @{id = '123-5464-dee43'} } -ParameterFilter { $Uri -eq "https://test.visualstudio.com/_apis/projects/Test?api-version=$($VSTeamVersionTable.Core)" }
         Mock Invoke-RestMethod { return @{status = 'inProgress'; url = 'https://someplace.com'} } -ParameterFilter { $Method -eq 'Patch'}
         Mock _trackProgress

         It 'Should change description' {
            Update-VSTeamProject -ProjectName Test -newDescription Testing123 -Force

            Assert-MockCalled Invoke-RestMethod -Times 2 -ParameterFilter { $Uri -eq "https://test.visualstudio.com/_apis/projects/Test?api-version=$($VSTeamVersionTable.Core)" }
            Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter { $Method -eq 'Patch' -and $Body -eq '{"description": "Testing123"}' }
         }
      }

      Context 'Update-VSTeamProject with new name and description' {

         Mock Invoke-RestMethod { return @{id = '123-5464-dee43'} } -ParameterFilter { $Uri -eq "https://test.visualstudio.com/_apis/projects/Test?api-version=$($VSTeamVersionTable.Core)" }
         Mock Invoke-RestMethod { return @{status = 'inProgress'; url = 'https://someplace.com'} } -ParameterFilter { $Method -eq 'Patch'}
         Mock _trackProgress
         Mock Invoke-RestMethod { return @{id = '123-5464-dee43'} } -ParameterFilter { $Uri -eq "https://test.visualstudio.com/_apis/projects/Testing123?api-version=$($VSTeamVersionTable.Core)" }

         It 'Should not call Invoke-RestMethod' {
            Update-VSTeamProject -ProjectName Test -newName Testing123 -newDescription Testing123 -Force

            Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter { $Uri -eq "https://test.visualstudio.com/_apis/projects/Test?api-version=$($VSTeamVersionTable.Core)" }
            Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter { $Method -eq 'Patch'}
            Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter { $Uri -eq "https://test.visualstudio.com/_apis/projects/Testing123?api-version=$($VSTeamVersionTable.Core)" }
         }
      }

      Context 'Remove-VSTeamProject with Force' {

         Mock Write-Progress
         Mock _trackProgress
         Mock Invoke-RestMethod { return @{id = '123-5464-dee43'} } -ParameterFilter { $Uri -eq "https://test.visualstudio.com/_apis/projects/Test?api-version=$($VSTeamVersionTable.Core)" }
         Mock Invoke-RestMethod { return @{status = 'inProgress'; url = 'https://someplace.com'} } -ParameterFilter { $Method -eq 'Delete' -and $Uri -eq "https://test.visualstudio.com/_apis/projects/123-5464-dee43?api-version=$($VSTeamVersionTable.Core)"}

         It 'Should not call Invoke-RestMethod' {
            Remove-VSTeamProject -ProjectName Test -Force

            Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter { $Uri -eq "https://test.visualstudio.com/_apis/projects/Test?api-version=$($VSTeamVersionTable.Core)" }
            Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter { $Method -eq 'Delete' -and $Uri -eq "https://test.visualstudio.com/_apis/projects/123-5464-dee43?api-version=$($VSTeamVersionTable.Core)"}
         }
      }

      Context 'Add-VSTeamProject with tfvc' {
         Mock Write-Progress
         # Add Project
         Mock Invoke-RestMethod { return @{status = 'inProgress'; id = '123-5464-dee43'; url = 'https://someplace.com'} } -ParameterFilter { $Method -eq 'Post' -and $Uri -eq "https://test.visualstudio.com/_apis/projects/?api-version=$($VSTeamVersionTable.Core)"}

         # Track Progress
         Mock Invoke-RestMethod {
            # This $i is in the module. Because we use InModuleScope
            # we can see it
            if ($i -gt 9) {
               return @{status = 'succeeded'}
            }

            return @{status = 'inProgress' }
         } -ParameterFilter { $Uri -eq 'https://someplace.com'}

         # Get-VSTeamProject
         Mock Invoke-RestMethod { return @{id = '123-5464-dee43'} } -ParameterFilter { $Uri -eq "https://test.visualstudio.com/_apis/projects/Test?api-version=$($VSTeamVersionTable.Core)" }

         It 'Should create project with tfvc' {
            Add-VSTeamProject -ProjectName Test -tfvc

            Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter { $Uri -eq "https://test.visualstudio.com/_apis/projects/Test?api-version=$($VSTeamVersionTable.Core)" }
            Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter { $Method -eq 'Post' -and $Uri -eq "https://test.visualstudio.com/_apis/projects/?api-version=$($VSTeamVersionTable.Core)" -and $Body -eq '{"name": "Test", "description": "", "capabilities": {"versioncontrol": { "sourceControlType": "Tfvc"}, "processTemplate":{"templateTypeId": "6b724908-ef14-45cf-84f8-768b5384da45"}}}'}
         }
      }

      Context 'Add-VSTeamProject with Agile' {

         Mock Invoke-RestMethod { return @{status = 'inProgress'; id = 1; url = 'https://someplace.com'} } -ParameterFilter { $Method -eq 'Post' -and $Uri -eq "https://test.visualstudio.com/_apis/projects/?api-version=$($VSTeamVersionTable.Core)"}
         Mock _trackProgress
         Mock Invoke-RestMethod { return @{id = '123-5464-dee43'} } -ParameterFilter { $Uri -eq "https://test.visualstudio.com/_apis/projects/Test?api-version=$($VSTeamVersionTable.Core)" }

         It 'Should create project with Agile' {
            Add-VSTeamProject -ProjectName Test -processTemplate Agile

            Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter { $Uri -eq "https://test.visualstudio.com/_apis/projects/Test?api-version=$($VSTeamVersionTable.Core)" }
            Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter { $Method -eq 'Post' -and $Uri -eq "https://test.visualstudio.com/_apis/projects/?api-version=$($VSTeamVersionTable.Core)"}
         }
      }

      Context 'Add-VSTeamProject with CMMI' {

         Mock Invoke-RestMethod { return @{status = 'inProgress'; id = 1; url = 'https://someplace.com'} } -ParameterFilter { $Method -eq 'Post' -and $Uri -eq "https://test.visualstudio.com/_apis/projects/?api-version=$($VSTeamVersionTable.Core)"}
         Mock _trackProgress
         Mock Invoke-RestMethod { return @{id = '123-5464-dee43'} } -ParameterFilter { $Uri -eq "https://test.visualstudio.com/_apis/projects/Test?api-version=$($VSTeamVersionTable.Core)" }

         It 'Should create project with CMMI' {
            Add-VSTeamProject -ProjectName Test -processTemplate CMMI

            Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter { $Uri -eq "https://test.visualstudio.com/_apis/projects/Test?api-version=$($VSTeamVersionTable.Core)" }
            Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter { $Method -eq 'Post' -and $Uri -eq "https://test.visualstudio.com/_apis/projects/?api-version=$($VSTeamVersionTable.Core)"}
         }
      }

      Context 'Add-VSTeamProject throws error' {

         Mock Invoke-RestMethod { return @{status = 'inProgress'; id = 1; url = 'https://someplace.com'} } -ParameterFilter { $Method -eq 'Post' -and $Uri -eq "https://test.visualstudio.com/_apis/projects/?api-version=$($VSTeamVersionTable.Core)"}
         Mock Write-Error
         Mock _trackProgress { throw 'Test error' }
         Mock Invoke-RestMethod { return @{id = '123-5464-dee43'} } -ParameterFilter { $Uri -eq "https://test.visualstudio.com/_apis/projects/Test?api-version=$($VSTeamVersionTable.Core)" }

         It 'Should throw' { { Add-VSTeamProject -projectName Test -processTemplate CMMI } | Should throw
         }
      }
   }
}