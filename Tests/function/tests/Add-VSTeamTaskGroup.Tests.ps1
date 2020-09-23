Set-StrictMode -Version Latest

Describe 'VSTeamTaskGroup' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      $taskGroupJson = "$sampleFiles\taskGroup.json"
      $taskGroupJsonAsString = Get-Content $taskGroupJson -Raw

      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'TaskGroups' }
   }

   Context 'Add-VSTeamTaskGroup' {
      BeforeAll {
         Mock Invoke-RestMethod { Open-SampleFile 'taskGroup.json' }
      }

      It 'should create a task group using body param' {
         Add-VSTeamTaskGroup -ProjectName Project -Body $taskGroupJsonAsString

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/Project/_apis/distributedtask/taskgroups?api-version=$(_getApiVersion TaskGroups)" -and
            $Body -eq $taskGroupJsonAsString -and
            $Method -eq "Post"
         }
      }

      It 'should create a task group using infile param' {
         Add-VSTeamTaskGroup -ProjectName Project -InFile $taskGroupJson

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/Project/_apis/distributedtask/taskgroups?api-version=$(_getApiVersion TaskGroups)" -and
            $InFile -eq $taskGroupJson -and
            $Method -eq "Post"
         }
      }
   }
}