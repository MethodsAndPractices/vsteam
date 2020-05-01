Set-StrictMode -Version Latest

#region include
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Private/applyTypes.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/Get-VSTeamTaskGroup.ps1"
. "$here/../../Source/Public/$sut"
#endregion

$taskGroupsJson = "$PSScriptRoot\sampleFiles\taskGroups.json"
$taskGroupJson = "$PSScriptRoot\sampleFiles\taskGroup.json"
   
Describe 'VSTeamTaskGroup' {
   . "$PSScriptRoot\mocks\mockProjectNameDynamicParamNoPSet.ps1"

   # Set the account to use for testing. A normal user would do this
   # using the Set-VSTeamAccount function.
   Mock _getInstance { return 'https://dev.azure.com/test' }
   Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'TaskGroups' }

   # Mock the call to Get-Projects by the dynamic parameter for ProjectName
   Mock Invoke-RestMethod { return @() } -ParameterFilter { $Uri -like "*_apis/project*" }

   BeforeAll {
      $projectName = "project"
      $taskGroupJsonAsString = Get-Content $taskGroupJson -Raw
   }

   Context 'Update-VSTeamTaskGroup' {
      Mock Invoke-RestMethod {
         return Get-Content $taskGroupJson | ConvertFrom-Json
      }

      It 'should update a task group using body param' {
         $taskGroupToUpdate = Get-VSTeamTaskGroup -Name "For Unit Tests" -ProjectName $projectName

         Update-VSTeamTaskGroup -ProjectName $projectName -Body $taskGroupJsonAsString -Id $taskGroupToUpdate.id

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/$projectName/_apis/distributedtask/taskgroups/$($taskGroupToUpdate.id)?api-version=$(_getApiVersion TaskGroups)" -and
            $Body -eq $taskGroupJsonAsString -and
            $Method -eq "Put"
         }
      }

      It 'should update a task group using infile param' {
         $taskGroupToUpdate = Get-VSTeamTaskGroup -Name "For Unit Tests" -ProjectName $projectName

         Update-VSTeamTaskGroup -ProjectName $projectName -InFile $taskGroupJson -Id $taskGroupToUpdate.id

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/$projectName/_apis/distributedtask/taskgroups/$($taskGroupToUpdate.id)?api-version=$(_getApiVersion TaskGroups)" -and
            $InFile -eq $taskGroupJson -and
            $Method -eq "Put"
         }
      }
   }
}