Set-StrictMode -Version Latest

#region include
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Private/applyTypes.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/Set-VSTeamAPIVersion.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe 'VSTeamVariableGroup' {
   # Mock the call to Get-Projects by the dynamic parameter for ProjectName
   Mock Invoke-RestMethod { return @() } -ParameterFilter { $Uri -like "*_apis/project*" }

   Context 'Get-VSTeamVariableGroup' {
      Context 'Services' {
         . "$PSScriptRoot\mocks\mockProjectNameDynamicParamNoPSet.ps1"

         [VSTeamVersions]::VariableGroups = '5.0-preview.1'

         $sampleFileVSTS = $(Get-Content "$PSScriptRoot\sampleFiles\variableGroupSamples.json" | ConvertFrom-Json)

         Mock _getInstance { return 'https://dev.azure.com/test' }

         BeforeAll {
            Set-VSTeamAPIVersion -Target VSTS
         }

         Mock Invoke-RestMethod { return $sampleFileVSTS }
         Mock Invoke-RestMethod { return $sampleFileVSTS.value[0] } -ParameterFilter { $Uri -like "*101*" }

         It 'list should return all variable groups' {
            Get-VSTeamVariableGroup -projectName project

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/project/_apis/distributedtask/variablegroups?api-version=$([VSTeamVersions]::VariableGroups)"
            }
         }


         It 'by Id should return one variable group' {
            $projectID = 101
            Get-VSTeamVariableGroup -projectName project -id $projectID

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/project/_apis/distributedtask/variablegroups/$($projectID)?api-version=$([VSTeamVersions]::VariableGroups)"
            }
         }
      }

      Context 'Server' {
         . "$PSScriptRoot\mocks\mockProjectNameDynamicParamNoPSet.ps1"

         [VSTeamVersions]::VariableGroups = '3.2-preview.1'

         $sampleFile2017 = $(Get-Content "$PSScriptRoot\sampleFiles\variableGroupSamples2017.json" | ConvertFrom-Json)

         Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' } -Verifiable

         BeforeAll {
            Set-VSTeamAPIVersion -Target TFS2017
         }

         Mock Invoke-RestMethod { return $sampleFile2017 }
         Mock Invoke-RestMethod { return $sampleFile2017.value[0] } -ParameterFilter { $Uri -like "*101*" }

         It 'list should return all variable groups' {
            Get-VSTeamVariableGroup -projectName project

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/distributedtask/variablegroups?api-version=$([VSTeamVersions]::VariableGroups)"
            }
         }

         It 'by Id should return one variable group' {
            $projectID = 101
            Get-VSTeamVariableGroup -projectName project -id $projectID

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/distributedtask/variablegroups/$($projectID)?api-version=$([VSTeamVersions]::VariableGroups)"
            }
         }

         It 'by name should return one variable group' {
            $varGroupName = "TestVariableGroup1"
            Get-VSTeamVariableGroup -projectName project -Name $varGroupName

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/distributedtask/variablegroups?api-version=$([VSTeamVersions]::VariableGroups)&groupName=$varGroupName"
            }
         }
      }
   }
}
