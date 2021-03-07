Set-StrictMode -Version Latest

Describe 'VSTeamTaskGroup' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { 
         $Service -eq 'TaskGroups' 
      }
   }

   Context 'Get-VSTeamTaskGroup list' {
      BeforeAll {
         Mock Invoke-RestMethod { Open-SampleFile 'taskGroups.json' }
      }

      It 'Should return all task groups' {
         ## Act
         Get-VSTeamTaskGroup -projectName project

         ## Act
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/project/_apis/distributedtask/taskgroups?api-version=$(_getApiVersion TaskGroups)"
         }
      }
   }

   Context 'Get-VSTeamTaskGroup Id' {
      BeforeAll {
         Mock Invoke-RestMethod { Open-SampleFile 'taskGroup.json' }
      }

      It 'Should return one task group' {
         ## Act
         $projectID = "d30f8b85-6b13-41a9-bb77-2e1a9c611def"
         Get-VSTeamTaskGroup -projectName project -id $projectID

         ## Act
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/project/_apis/distributedtask/taskgroups/$($projectID)?api-version=$(_getApiVersion TaskGroups)"
         }
      }
   }

   Context 'Get-VSTeamTaskGroup Name' {
      BeforeAll {
         Mock Invoke-RestMethod { Open-SampleFile 'taskGroups.json' }
      }

      It 'Should return one task group' {
         ## Act
         $taskGroupName = "For Unit Tests 2"
         $taskGroup = Get-VSTeamTaskGroup -projectName project -Name $taskGroupName

         ## Act
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/project/_apis/distributedtask/taskgroups?api-version=$(_getApiVersion TaskGroups)"
         }

         # Ensure that we only have one task group, in other words, that the name filter was applied.
         $taskGroup.name | Should -Be $taskGroupName
      }
   }
}