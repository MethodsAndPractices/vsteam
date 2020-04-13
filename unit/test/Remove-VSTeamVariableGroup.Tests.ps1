Set-StrictMode -Version Latest

#region include
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Classes/ProjectCompleter.ps1"
. "$here/../../Source/Classes/ProjectValidateAttribute.ps1"
. "$here/../../Source/Private/applyTypes.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/Set-VSTeamAPIVersion.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe 'VSTeamVariableGroup' {
   # Mock the call to Get-Projects by the dynamic parameter for ProjectName
   Mock Invoke-RestMethod { return @() } -ParameterFilter { $Uri -like "*_apis/project*" }

   Context 'Remove-VSTeamVariableGroup' {
      Context 'Services' {
         Mock _getApiVersion { return '5.0-preview.1' } -ParameterFilter { $Service -eq 'VariableGroups' }

         Mock _getInstance { return 'https://dev.azure.com/test' }

         BeforeAll {
            Set-VSTeamAPIVersion -Target VSTS
         }

         Mock Invoke-RestMethod

         It 'should delete variable group' {
            $projectID = 1
            Remove-VSTeamVariableGroup -projectName project -Id $projectID -Force

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/project/_apis/distributedtask/variablegroups/$($projectID)?api-version=$(_getApiVersion VariableGroups)" -and
               $Method -eq 'Delete'
            }
         }
      }

      Context 'Server' {
         Mock _getApiVersion { return '3.2-preview.1' } -ParameterFilter { $Service -eq 'VariableGroups' }

         Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' } -Verifiable

         BeforeAll {
            Set-VSTeamAPIVersion -Target TFS2017
         }

         Mock Invoke-RestMethod

         It 'should delete variable group' {
            $projectID = 1
            Remove-VSTeamVariableGroup -projectName project -id $projectID -Force

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/distributedtask/variablegroups/$($projectID)?api-version=$(_getApiVersion VariableGroups)" -and
               $Method -eq 'Delete'
            }
         }
      }
   }
}
