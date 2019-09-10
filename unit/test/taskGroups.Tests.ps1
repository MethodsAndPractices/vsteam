Set-StrictMode -Version Latest

InModuleScope VSTeam {
   # Set the account to use for testing. A normal user would do this
   # using the Set-VSTeamAccount function.
   [VSTeamVersions]::Account = 'https://dev.azure.com/test'

   $taskGroupsJson = "$PSScriptRoot\sampleFiles\taskGroups.json"
   $taskGroupJson = "$PSScriptRoot\sampleFiles\taskGroup.json"

   Describe 'Task Groups VSTS' {
      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter {
         $Uri -like "*_apis/project*"
      }

      . "$PSScriptRoot\mocks\mockProjectNameDynamicParamNoPSet.ps1"

      BeforeAll {
         Set-VSTeamAPIVersion -Target VSTS
         $projectName = "project"
         $taskGroupJsonAsString = Get-Content $taskGroupJson -Raw
      }

      Context 'Get-VSTeamTaskGroup list' {
         Mock Invoke-RestMethod {
            return Get-Content $taskGroupsJson | ConvertFrom-Json
         }

         It 'Should return all task groups' {
            Get-VSTeamTaskGroup -projectName $projectName

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/$projectName/_apis/distributedtask/taskgroups/?api-version=$([VSTeamVersions]::TaskGroups)"
            }
         }
      }

      Context 'Get-VSTeamTaskGroup Id' {
         Mock Invoke-RestMethod {
            return Get-Content $taskGroupJson | ConvertFrom-Json
         }

         It 'Should return one task group' {
            $projectID = "d30f8b85-6b13-41a9-bb77-2e1a9c611def"
            Get-VSTeamTaskGroup -projectName $projectName -id $projectID

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/$projectName/_apis/distributedtask/taskgroups/$($projectID)?api-version=$([VSTeamVersions]::TaskGroups)"
            }
         }
      }

      Context 'Get-VSTeamTaskGroup Name' {
         Mock Invoke-RestMethod {
            # Return multiple task groups, because the function filters by name after getting the list from the server.
            return Get-Content $taskGroupsJson | ConvertFrom-Json
         }

         It 'Should return one task group' {
            $taskGroupName = "For Unit Tests 2"
            $taskGroup = Get-VSTeamTaskGroup -projectName $projectName -Name $taskGroupName

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
                $Uri -eq "https://dev.azure.com/test/$projectName/_apis/distributedtask/taskgroups/?api-version=$([VSTeamVersions]::TaskGroups)"
            }

            # Ensure that we only have one task group, in other words, that the name filter was applied.
            $taskGroup.name | Should Be $taskGroupName
         }
      }

      Context 'Remove-VSTeamTaskGroup' {
         Mock Invoke-RestMethod

         It 'should delete Task group' {
            $projectID = "d30f8b85-6b13-41a9-bb77-2e1a9c611def"

            Remove-VSTeamTaskGroup -projectName $projectName -Id $projectID -Force

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/$projectName/_apis/distributedtask/taskgroups/$($projectID)?api-version=$([VSTeamVersions]::TaskGroups)" -and
               $Method -eq 'Delete'
            }
         }
      }

      Context 'Add-VSTeamTaskGroup' {
         Mock Invoke-RestMethod {
            return Get-Content $taskGroupJson | ConvertFrom-Json
         }

         It 'should create a task group using body param' {
            Add-VSTeamTaskGroup -ProjectName $projectName -Body $taskGroupJsonAsString

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/$projectName/_apis/distributedtask/taskgroups/?api-version=$([VSTeamVersions]::TaskGroups)" -and
               $Body -eq $taskGroupJsonAsString -and
               $Method -eq "Post"
            }
         }

         It 'should create a task group using infile param' {
            Add-VSTeamTaskGroup -ProjectName $projectName -InFile $taskGroupJson

             Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/$projectName/_apis/distributedtask/taskgroups/?api-version=$([VSTeamVersions]::TaskGroups)" -and
               $InFile -eq $taskGroupJson -and
               $Method -eq "Post"
             }
         }
      }

      Context 'Update-VSTeamTaskGroup' {
         Mock Invoke-RestMethod {
            return Get-Content $taskGroupJson | ConvertFrom-Json
         }

         It 'should update a task group using body param' {
            $taskGroupToUpdate = Get-VSTeamTaskGroup -Name "For Unit Tests" -ProjectName $projectName

            Update-VSTeamTaskGroup -ProjectName $projectName -Body $taskGroupJsonAsString -Id $taskGroupToUpdate.id

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/$projectName/_apis/distributedtask/taskgroups/$($taskGroupToUpdate.id)?api-version=$([VSTeamVersions]::TaskGroups)" -and
               $Body -eq $taskGroupJsonAsString -and
               $Method -eq "Put"
            }
         }

         It 'should update a task group using infile param' {
            $taskGroupToUpdate = Get-VSTeamTaskGroup -Name "For Unit Tests" -ProjectName $projectName

            Update-VSTeamTaskGroup -ProjectName $projectName -InFile $taskGroupJson -Id $taskGroupToUpdate.id

             Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/$projectName/_apis/distributedtask/taskgroups/$($taskGroupToUpdate.id)?api-version=$([VSTeamVersions]::TaskGroups)" -and
               $InFile -eq $taskGroupJson -and
               $Method -eq "Put"
             }
         }
      }
   }
}