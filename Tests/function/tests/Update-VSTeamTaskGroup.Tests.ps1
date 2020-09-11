Set-StrictMode -Version Latest

Describe 'VSTeamTaskGroup' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$baseFolder/Source/Public/Get-VSTeamTaskGroup.ps1"
      
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'TaskGroups' }
   }

   Context 'Update-VSTeamTaskGroup' {
      BeforeAll {
         Mock Invoke-RestMethod { Open-SampleFile 'taskGroup.json' }
      }

      It 'should update a task group using body param' {
         ## Arrange
         $taskGroupJsonAsString = Open-SampleFile 'taskGroup.json' -Json
         $taskGroupToUpdate = Get-VSTeamTaskGroup -Name "For Unit Tests" -ProjectName 'project'

         ## Act
         Update-VSTeamTaskGroup -ProjectName 'project' -Body $taskGroupJsonAsString -Id $taskGroupToUpdate.id

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/project/_apis/distributedtask/taskgroups/$($taskGroupToUpdate.id)?api-version=$(_getApiVersion TaskGroups)" -and
            $Body -eq $taskGroupJsonAsString -and
            $Method -eq "Put"
         }
      }

      It 'should update a task group using infile param' {
         ## Arrange
         $taskGroupJson = "$sampleFiles\taskGroup.json"
         $taskGroupToUpdate = Get-VSTeamTaskGroup -Name "For Unit Tests" -ProjectName 'project'

         ## Act
         Update-VSTeamTaskGroup -ProjectName 'project' -InFile $taskGroupJson -Id $taskGroupToUpdate.id

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/project/_apis/distributedtask/taskgroups/$($taskGroupToUpdate.id)?api-version=$(_getApiVersion TaskGroups)" -and
            $InFile -eq $taskGroupJson -and
            $Method -eq "Put"
         }
      }
   }
}