Set-StrictMode -Version Latest

Describe 'VSTeamTaskGroup' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      
      Mock Invoke-RestMethod
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'TaskGroups' }
   }

   Context 'Remove-VSTeamTaskGroup' {
      It 'should delete Task group' {
         $projectID = "d30f8b85-6b13-41a9-bb77-2e1a9c611def"

         Remove-VSTeamTaskGroup -projectName "project" -Id $projectID -Force

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/project/_apis/distributedtask/taskgroups/$($projectID)?api-version=$(_getApiVersion TaskGroups)" -and
            $Method -eq 'Delete'
         }
      }
   }
}