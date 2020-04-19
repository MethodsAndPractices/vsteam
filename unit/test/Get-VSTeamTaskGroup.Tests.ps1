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

   Context 'Get-VSTeamTaskGroup list' {
      Mock Invoke-RestMethod {
         return Get-Content $taskGroupsJson | ConvertFrom-Json
      }

      It 'Should return all task groups' {
         Get-VSTeamTaskGroup -projectName $projectName

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/$projectName/_apis/distributedtask/taskgroups?api-version=$(_getApiVersion TaskGroups)"
         }
      }
   }

   Context 'Get-VSTeamTaskGroup Id' {
      Mock Invoke-RestMethod {
         return Get-Content $taskGroupJson | ConvertFrom-Json
      }

      It 'Should return one task group' {
         $projectID = "d30f8b85-6b13-41a9-bb77-2e1a9c611def"
         Get-VSTeamTaskGroup -projectName $projectName -id $projectID

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/$projectName/_apis/distributedtask/taskgroups/$($projectID)?api-version=$(_getApiVersion TaskGroups)"
         }
      }
   }

   Context 'Get-VSTeamTaskGroup Name' {
      Mock Invoke-RestMethod {
         # Return multiple task groups, because the function filters by name after getting the list from the server.
         return Get-Content $taskGroupsJson | ConvertFrom-Json
      }

      It 'Should return one task group' {
         $taskGroupName = "For Unit Tests 2"
         $taskGroup = Get-VSTeamTaskGroup -projectName $projectName -Name $taskGroupName

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/$projectName/_apis/distributedtask/taskgroups?api-version=$(_getApiVersion TaskGroups)"
         }

         # Ensure that we only have one task group, in other words, that the name filter was applied.
         $taskGroup.name | Should Be $taskGroupName
      }
   }
}