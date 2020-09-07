Set-StrictMode -Version Latest

Describe 'VSTeamVariableGroup' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      
      . "$baseFolder/Source/Private/applyTypes.ps1"
      . "$baseFolder/Source/Public/Set-VSTeamAPIVersion.ps1"

      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'VariableGroups' }
   }

   Context 'Get-VSTeamVariableGroup' {
      Context 'Services' {
         BeforeAll {
            $sampleFileVSTS = Open-SampleFile 'variableGroupSamples.json'

            Mock _getApiVersion { return 'VSTS' }
            Mock _getInstance { return 'https://dev.azure.com/test' }

            Mock Invoke-RestMethod { return $sampleFileVSTS }
            Mock Invoke-RestMethod { return $sampleFileVSTS.value[0] } -ParameterFilter { $Uri -like "*101*" }
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
            $sampleFile2017 = Open-SampleFile 'variableGroupSamples2017.json'

            Mock _getApiVersion { return 'TFS2017' }
            Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' } -Verifiable

            Mock Invoke-RestMethod { return $sampleFile2017 }
            Mock Invoke-RestMethod { return $sampleFile2017.value[0] } -ParameterFilter { $Uri -like "*101*" }
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