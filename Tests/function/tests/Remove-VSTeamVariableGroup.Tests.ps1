Set-StrictMode -Version Latest

Describe 'VSTeamVariableGroup' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$baseFolder/Source/Public/Set-VSTeamAPIVersion.ps1"
      
      Mock Invoke-RestMethod
   }

   Context 'Remove-VSTeamVariableGroup' {
      Context 'Services' {
         BeforeAll {
            Set-VSTeamAPIVersion -Target VSTS
            Mock _getInstance { return 'https://dev.azure.com/test' }
            Mock _getApiVersion { return '5.0-preview.1' } -ParameterFilter { $Service -eq 'VariableGroups' }
         }

         It 'should delete variable group' {
            $projectID = 1
            Remove-VSTeamVariableGroup -projectName project -Id $projectID -Force

            Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/project/_apis/distributedtask/variablegroups/$($projectID)?api-version=$(_getApiVersion VariableGroups)" -and
               $Method -eq 'Delete'
            }
         }
      }

      Context 'Server' {
         BeforeAll {
            Set-VSTeamAPIVersion -Target TFS2017
            Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' } -Verifiable
            Mock _getApiVersion { return '3.2-preview.1' } -ParameterFilter { $Service -eq 'VariableGroups' }
         }

         It 'should delete variable group' {
            $projectID = 1
            Remove-VSTeamVariableGroup -projectName project -id $projectID -Force

            Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/distributedtask/variablegroups/$($projectID)?api-version=$(_getApiVersion VariableGroups)" -and
               $Method -eq 'Delete'
            }
         }
      }
   }
}