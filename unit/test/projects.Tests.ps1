Set-StrictMode -Version Latest

InModuleScope projects {
   [VSTeamVersions]::Account = 'https://test.visualstudio.com'

   Describe 'Project' {
      . "$PSScriptRoot\mocks\mockProjectNameDynamicParam.ps1"

      Context 'Show-VSTeamProject by ID' {
         Mock Show-Browser
         
         It 'Show call start' {
            Show-VSTeamProject -Id 123456

            Assert-MockCalled Show-Browser
         }
      }

      Context 'Show-VSTeamProject by ProjectName' {
         Mock Show-Browser

         It 'Show call open' {
            Show-VSTeamProject -ProjectName MyProject

            Assert-MockCalled Show-Browser
         }
      }

      Context 'Show-VSTeamProject by default parameter' {
         Mock Show-Browser

         It 'Show call open' {
            Show-VSTeamProject MyProject

            Assert-MockCalled Show-Browser
         }
      }

      $results = [PSCustomObject]@{
         value = [PSCustomObject]@{
            name        = 'Test'
            description = ''
            url         = ''
            id          = '123-5464-dee43'
            state       = ''
            visibility  = ''
            revision    = 0
            _links      = [PSCustomObject]@{}
         }
      }

      $singleResult = [PSCustomObject]@{
         name        = 'Test'
         description = ''
         url         = ''
         id          = '123-5464-dee43'
         state       = ''
         visibility  = ''
         revision    = 0
         defaultTeam = [PSCustomObject]@{}
         _links      = [PSCustomObject]@{}
      }

      Context 'Get-VSTeamProject with no parameters using BearerToken' {

         BeforeAll {
            $env:TEAM_TOKEN = '1234'
         }

         AfterAll {
            $env:TEAM_TOKEN = $null
         }

         Mock Invoke-RestMethod { return $results }

         It 'Should return projects' {
            Get-VSTeamProject

            # Make sure it was called with the correct URI
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -like "*https://test.visualstudio.com/_apis/projects/*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
               $Uri -like "*`$top=100*" -and
               $Uri -like "*stateFilter=WellFormed*"
            }
         }
      }

      Context 'Get-VSTeamProject with top 10' {

         Mock Invoke-RestMethod { return $results }

         It 'Should return top 10 projects' {
            Get-VSTeamProject -top 10

            # Make sure it was called with the correct URI
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -like "*https://test.visualstudio.com/_apis/projects/*" -and
               $Uri -like "*`$top=10*" -and
               $Uri -like "*stateFilter=WellFormed*"
            }
         }
      }

      Context 'Get-VSTeamProject with skip 1' {

         Mock Invoke-RestMethod { return $results }

         It 'Should skip first project' {
            Get-VSTeamProject -skip 1

            # Make sure it was called with the correct URI
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -like "*https://test.visualstudio.com/_apis/projects/*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
               $Uri -like "*`$skip=1*" -and
               $Uri -like "*`$top=100*" -and
               $Uri -like "*stateFilter=WellFormed*"
            }
         }
      }

      Context 'Get-VSTeamProject with stateFilter All' {

         Mock Invoke-RestMethod { return $results }

         It 'Should return All projects' {
            Get-VSTeamProject -stateFilter 'All'

            # Make sure it was called with the correct URI
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -like "*https://test.visualstudio.com/_apis/projects/*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
               $Uri -like "*`$top=100*" -and
               $Uri -like "*stateFilter=All*"
            }
         }
      }

      Context 'Get-VSTeamProject with no Capabilities' {

         Mock Invoke-RestMethod { return $singleResult }

         It 'Should return the project' {
            Get-VSTeamProject -Name Test

            # Make sure it was called with the correct URI
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/_apis/projects/Test?api-version=$([VSTeamVersions]::Core)"
            }
         }
      }

      Context 'Get-VSTeamProject with Capabilities' {

         Mock Invoke-RestMethod { return $singleResult }

         It 'Should return the project with capabilities' {
            Get-VSTeamProject -projectId Test -includeCapabilities

            # Make sure it was called with the correct URI
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -like "*https://test.visualstudio.com/_apis/projects/Test*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
               $Uri -like "*includeCapabilities=True*"
            }
         }
      }

      Context 'Get-VSTeamProject with no parameters throws' {

         Mock Invoke-RestMethod { throw 'error' }

         It 'Should return projects' {
            { Get-VSTeamProject } | Should Throw
         }
      }

      Context 'Update-VSTeamProject with no op by id' {
         Mock Invoke-RestMethod { return $singleResult }

         It 'Should not call Invoke-RestMethod' {
            Update-VSTeamProject -id '123-5464-dee43'

            Assert-MockCalled Invoke-RestMethod -Exactly 0
         }
      }

      Context 'Update-VSTeamProject with newName' {

         Mock Invoke-RestMethod { return $singleResult } -ParameterFilter { $Uri -eq "https://test.visualstudio.com/_apis/projects/Test?api-version=$([VSTeamVersions]::Core)" }
         Mock Invoke-RestMethod { return @{status = 'inProgress'; url = 'https://someplace.com'} } -ParameterFilter { $Method -eq 'Patch'}
         Mock _trackProjectProgress
         Mock Invoke-RestMethod { return $singleResult } -ParameterFilter { $Uri -eq "https://test.visualstudio.com/_apis/projects/Testing123?api-version=$([VSTeamVersions]::Core)" }

         It 'Should change name' {
            Update-VSTeamProject -ProjectName Test -newName Testing123 -Force

            Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter { $Uri -eq "https://test.visualstudio.com/_apis/projects/Test?api-version=$([VSTeamVersions]::Core)" }
            Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter { $Method -eq 'Patch' -and $Body -eq '{"name": "Testing123"}'}
            Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter { $Uri -eq "https://test.visualstudio.com/_apis/projects/Testing123?api-version=$([VSTeamVersions]::Core)" }
         }
      }

      Context 'Update-VSTeamProject with newDescription' {

         Mock Invoke-RestMethod { return $singleResult } -ParameterFilter { $Uri -eq "https://test.visualstudio.com/_apis/projects/Test?api-version=$([VSTeamVersions]::Core)" }
         Mock Invoke-RestMethod { return @{status = 'inProgress'; url = 'https://someplace.com'} } -ParameterFilter { $Method -eq 'Patch'}
         Mock _trackProjectProgress

         It 'Should change description' {
            Update-VSTeamProject -ProjectName Test -newDescription Testing123 -Force

            Assert-MockCalled Invoke-RestMethod -Times 2 -ParameterFilter { $Uri -eq "https://test.visualstudio.com/_apis/projects/Test?api-version=$([VSTeamVersions]::Core)" }
            Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter { $Method -eq 'Patch' -and $Body -eq '{"description": "Testing123"}' }
         }
      }

      Context 'Update-VSTeamProject with new name and description' {

         Mock Invoke-RestMethod { return $singleResult } -ParameterFilter { $Uri -eq "https://test.visualstudio.com/_apis/projects/Test?api-version=$([VSTeamVersions]::Core)" }
         Mock Invoke-RestMethod { return @{status = 'inProgress'; url = 'https://someplace.com'} } -ParameterFilter { $Method -eq 'Patch'}
         Mock _trackProjectProgress
         Mock Invoke-RestMethod { return $singleResult } -ParameterFilter { $Uri -eq "https://test.visualstudio.com/_apis/projects/Testing123?api-version=$([VSTeamVersions]::Core)" }

         It 'Should not call Invoke-RestMethod' {
            Update-VSTeamProject -ProjectName Test -newName Testing123 -newDescription Testing123 -Force

            Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter { $Uri -eq "https://test.visualstudio.com/_apis/projects/Test?api-version=$([VSTeamVersions]::Core)" }
            Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter { $Method -eq 'Patch'}
            Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter { $Uri -eq "https://test.visualstudio.com/_apis/projects/Testing123?api-version=$([VSTeamVersions]::Core)" }
         }
      }

      Context 'Remove-VSTeamProject with Force' {

         Mock Write-Progress
         Mock _trackProjectProgress
         Mock Invoke-RestMethod { return $singleResult } -ParameterFilter { $Uri -eq "https://test.visualstudio.com/_apis/projects/Test?api-version=$([VSTeamVersions]::Core)" }
         Mock Invoke-RestMethod { return @{status = 'inProgress'; url = 'https://someplace.com'} } -ParameterFilter { $Method -eq 'Delete' -and $Uri -eq "https://test.visualstudio.com/_apis/projects/123-5464-dee43?api-version=$([VSTeamVersions]::Core)"}

         It 'Should not call Invoke-RestMethod' {
            Remove-VSTeamProject -ProjectName Test -Force

            Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter { $Uri -eq "https://test.visualstudio.com/_apis/projects/Test?api-version=$([VSTeamVersions]::Core)" }
            Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter { $Method -eq 'Delete' -and $Uri -eq "https://test.visualstudio.com/_apis/projects/123-5464-dee43?api-version=$([VSTeamVersions]::Core)"}
         }
      }

      Context 'Add-VSTeamProject with tfvc' {
         Mock Write-Progress
         # Add Project
         Mock Invoke-RestMethod { return @{status = 'inProgress'; id = '123-5464-dee43'; url = 'https://someplace.com'} } -ParameterFilter {
            $Method -eq 'Post' -and
            $Uri -eq "https://test.visualstudio.com/_apis/projects/?api-version=$([VSTeamVersions]::Core)"
         }

         # Track Progress
         Mock Invoke-RestMethod {
            # This $i is in the module. Because we use InModuleScope
            # we can see it
            if ($i -gt 9) {
               return @{status = 'succeeded'}
            }

            return @{status = 'inProgress' }
         } -ParameterFilter {
            $Uri -eq 'https://someplace.com'
         }

         # Get-VSTeamProject
         Mock Invoke-RestMethod { return $singleResult } -ParameterFilter {
            $Uri -eq "https://test.visualstudio.com/_apis/projects/Test?api-version=$([VSTeamVersions]::Core)"
         }

         It 'Should create project with tfvc' {
            Add-VSTeamProject -Name Test -tfvc

            Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/_apis/projects/Test?api-version=$([VSTeamVersions]::Core)"
            }
            Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter {
               $Method -eq 'Post' -and
               $Uri -eq "https://test.visualstudio.com/_apis/projects/?api-version=$([VSTeamVersions]::Core)" -and
               $Body -eq '{"name": "Test", "description": "", "capabilities": {"versioncontrol": { "sourceControlType": "Tfvc"}, "processTemplate":{"templateTypeId": "6b724908-ef14-45cf-84f8-768b5384da45"}}}'
            }
         }
      }

      Context 'Add-VSTeamProject with Agile' {

         Mock Invoke-RestMethod { return @{status = 'inProgress'; id = 1; url = 'https://someplace.com'} } -ParameterFilter { $Method -eq 'Post' -and $Uri -eq "https://test.visualstudio.com/_apis/projects/?api-version=$([VSTeamVersions]::Core)"}
         Mock _trackProjectProgress
         Mock Invoke-RestMethod { return $singleResult } -ParameterFilter { $Uri -eq "https://test.visualstudio.com/_apis/projects/Test?api-version=$([VSTeamVersions]::Core)" }

         It 'Should create project with Agile' {
            Add-VSTeamProject -ProjectName Test -processTemplate Agile

            Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter { $Uri -eq "https://test.visualstudio.com/_apis/projects/Test?api-version=$([VSTeamVersions]::Core)" }
            Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter { $Method -eq 'Post' -and $Uri -eq "https://test.visualstudio.com/_apis/projects/?api-version=$([VSTeamVersions]::Core)"}
         }
      }

      Context 'Add-VSTeamProject with CMMI' {

         Mock Invoke-RestMethod { return @{status = 'inProgress'; id = 1; url = 'https://someplace.com'} } -ParameterFilter { $Method -eq 'Post' -and $Uri -eq "https://test.visualstudio.com/_apis/projects/?api-version=$([VSTeamVersions]::Core)"}
         Mock _trackProjectProgress
         Mock Invoke-RestMethod { return $singleResult } -ParameterFilter { $Uri -eq "https://test.visualstudio.com/_apis/projects/Test?api-version=$([VSTeamVersions]::Core)" }

         It 'Should create project with CMMI' {
            Add-VSTeamProject -ProjectName Test -processTemplate CMMI

            Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter { $Uri -eq "https://test.visualstudio.com/_apis/projects/Test?api-version=$([VSTeamVersions]::Core)" }
            Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter { $Method -eq 'Post' -and $Uri -eq "https://test.visualstudio.com/_apis/projects/?api-version=$([VSTeamVersions]::Core)"}
         }
      }

      Context 'Add-VSTeamProject throws error' {

         Mock Invoke-RestMethod { return @{status = 'inProgress'; id = 1; url = 'https://someplace.com'} } -ParameterFilter { $Method -eq 'Post' -and $Uri -eq "https://test.visualstudio.com/_apis/projects/?api-version=$([VSTeamVersions]::Core)"}
         Mock Write-Error
         Mock _trackProjectProgress { throw 'Test error' }
         Mock Invoke-RestMethod { return $singleResult } -ParameterFilter { $Uri -eq "https://test.visualstudio.com/_apis/projects/Test?api-version=$([VSTeamVersions]::Core)" }

         It 'Should throw' { { Add-VSTeamProject -projectName Test -processTemplate CMMI } | Should throw
         }
      }

      Context 'Set-VSTeamDefaultProject' {
         It 'should set default project' {
            Set-VSTeamDefaultProject 'MyProject'

            $Global:PSDefaultParameterValues['*:projectName'] | Should be 'MyProject'
         }

         It 'should update default project' {
            $Global:PSDefaultParameterValues['*:projectName'] = 'MyProject'

            Set-VSTeamDefaultProject -Project 'NextProject'

            $Global:PSDefaultParameterValues['*:projectName'] | Should be 'NextProject'
         }
      }

      Context 'Set-VSTeamDefaultProject on Non Windows' {
         Mock _isOnWindows { return $false } -Verifiable

         It 'should set default project' {
            Set-VSTeamDefaultProject 'MyProject'

            Assert-VerifiableMock
            $Global:PSDefaultParameterValues['*:projectName'] | Should be 'MyProject'
         }
      }

      Context 'Set-VSTeamDefaultProject As Admin on Windows' {
         Mock _isOnWindows { return $true }
         Mock _testAdministrator { return $true } -Verifiable

         It 'should set default project' {
            Set-VSTeamDefaultProject 'MyProject'

            Assert-VerifiableMock
            $Global:PSDefaultParameterValues['*:projectName'] | Should be 'MyProject'
         }
      }

      Context 'Clear-VSTeamDefaultProject on Non Windows' {
         Mock _isOnWindows { return $false } -Verifiable

         It 'should clear default project' {
            $Global:PSDefaultParameterValues['*:projectName'] = 'MyProject'

            Clear-VSTeamDefaultProject

            $Global:PSDefaultParameterValues['*:projectName'] | Should BeNullOrEmpty
         }
      }

      Context 'Clear-VSTeamDefaultProject as Non-Admin on Windows' {
         Mock _isOnWindows { return $true }
         Mock _testAdministrator { return $false }

         It 'should clear default project' {
            $Global:PSDefaultParameterValues['*:projectName'] = 'MyProject'

            Clear-VSTeamDefaultProject

            $Global:PSDefaultParameterValues['*:projectName'] | Should BeNullOrEmpty
         }
      }

      Context 'Clear-VSTeamDefaultProject as Admin on Windows' {
         Mock _isOnWindows { return $true }
         Mock _testAdministrator { return $true } -Verifiable

         It 'should clear default project' {
            $Global:PSDefaultParameterValues['*:projectName'] = 'MyProject'

            Clear-VSTeamDefaultProject

            $Global:PSDefaultParameterValues['*:projectName'] | Should BeNullOrEmpty
         }
      }
   }
}