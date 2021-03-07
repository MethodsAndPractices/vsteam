Set-StrictMode -Version Latest

Describe 'VSTeamVariableGroup' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'VariableGroups' }
   }

   Context 'Get-VSTeamVariableGroup' {
      Context 'Services' {
         BeforeAll {
            Mock _getApiVersion { return 'VSTS' }
            Mock _getInstance { return 'https://dev.azure.com/test' }

            Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamVariableGroup.json' }
            Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamVariableGroup.json' -Index 0 } -ParameterFilter { $Uri -like "*101*" }
         }

         It 'list should return all variable groups' {
            Get-VSTeamVariableGroup -projectName project

            Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/project/_apis/distributedtask/variablegroups?api-version=$(_getApiVersion VariableGroups)"
            }
         }


         It 'by Id should return one variable group' {
            $projectID = 101
            Get-VSTeamVariableGroup -projectName project -id $projectID

            Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/project/_apis/distributedtask/variablegroups/$($projectID)?api-version=$(_getApiVersion VariableGroups)"
            }
         }
      }

      Context 'Server' {
         BeforeAll {
            Mock _getApiVersion { return 'TFS2017' }
            Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' }

            Mock Invoke-RestMethod { Open-SampleFile 'variableGroupSamples2017.json' }
            Mock Invoke-RestMethod { Open-SampleFile 'variableGroupSamples2017.json' -Index 0 } -ParameterFilter { $Uri -like "*101*" }
         }

         It 'list should return all variable groups' {
            Get-VSTeamVariableGroup -projectName project

            Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/distributedtask/variablegroups?api-version=$(_getApiVersion VariableGroups)"
            }
         }

         It 'by Id should return one variable group' {
            $projectID = 101
            Get-VSTeamVariableGroup -projectName project -id $projectID

            Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/distributedtask/variablegroups/$($projectID)?api-version=$(_getApiVersion VariableGroups)"
            }
         }

         It 'by name should return one variable group' {
            $varGroupName = "TestVariableGroup1"
            Get-VSTeamVariableGroup -projectName project -Name $varGroupName

            Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/distributedtask/variablegroups?api-version=$(_getApiVersion VariableGroups)&groupName=$varGroupName"
            }
         }
      }
   }
}