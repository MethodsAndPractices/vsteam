Set-StrictMode -Version Latest

#ipmo D:\Projects\Main\Powershell\vsteam\dist\VSTeam.psd1 -Force

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


      # Context 'Remove-VSTeamVariableGroup' {
      #    Mock Invoke-RestMethod

      #    It 'should delete variable group' {
      #       $projectID = 1
      #       Remove-VSTeamVariableGroup -projectName project -Id $projectID -Force

      #       Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
      #          $Uri -eq "https://dev.azure.com/test/project/_apis/distributedtask/variablegroups/$($projectID)?api-version=$([VSTeamVersions]::VariableGroups)" -and
      #          $Method -eq 'Delete'
      #       }
      #    }
      # }

      Context 'Add-VSTeamTaskGroup' {
         Mock Invoke-RestMethod {
            return Get-Content $taskGroupJson | ConvertFrom-Json
         }

         It 'should create a task group using body param' {
            $taskGroupJsonAsString = Get-Content $taskGroupJson -Raw

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

      # Context 'Update-VSTeamVariableGroup' {
      #    Mock Invoke-RestMethod {
      #       #Write-Host $args

      #       $collection = Get-Content $sampleFileVSTS | ConvertFrom-Json
      #       return $collection.value | Where-Object {$_.id -eq 1}
      #    } -Verifiable

      #    It 'should update an exisiting Variable Group' {

      #       Update-VSTeamVariableGroup @testParameters

      #       Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
      #          $Uri -eq "https://dev.azure.com/test/project/_apis/distributedtask/variablegroups/$($testParameters.id)?api-version=$([VSTeamVersions]::VariableGroups)" -and
      #          $Method -eq 'Put'
      #       }
      #    }
      # }
   }
}