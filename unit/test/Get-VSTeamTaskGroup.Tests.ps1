Set-StrictMode -Version Latest

Describe 'VSTeamTaskGroup' {
   BeforeAll {
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/Set-VSTeamAPIVersion.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"

      $taskGroupsJson = "$PSScriptRoot\sampleFiles\taskGroups.json"
      $taskGroupJson = "$PSScriptRoot\sampleFiles\taskGroup.json"

      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'TaskGroups' }

      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter { $Uri -like "*_apis/project*" }
   }

   Context 'Get-VSTeamTaskGroup list' {
      BeforeAll {
         Mock Invoke-RestMethod {
            return Get-Content $taskGroupsJson | ConvertFrom-Json
         }
      }

      It 'Should return all task groups' {
         Get-VSTeamTaskGroup -projectName project

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/project/_apis/distributedtask/taskgroups?api-version=$(_getApiVersion TaskGroups)"
         }
      }
   }

   Context 'Get-VSTeamTaskGroup Id' {
      BeforeAll {
         Mock Invoke-RestMethod {
            return Get-Content $taskGroupJson | ConvertFrom-Json
         }
      }

      It 'Should return one task group' {
         $projectID = "d30f8b85-6b13-41a9-bb77-2e1a9c611def"
         Get-VSTeamTaskGroup -projectName project -id $projectID

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/project/_apis/distributedtask/taskgroups/$($projectID)?api-version=$(_getApiVersion TaskGroups)"
         }
      }
   }

   Context 'Get-VSTeamTaskGroup Name' {
      BeforeAll {
         Mock Invoke-RestMethod {
            # Return multiple task groups, because the function filters by name after getting the list from the server.
            return Get-Content $taskGroupsJson | ConvertFrom-Json
         }
      }

      It 'Should return one task group' {
         $taskGroupName = "For Unit Tests 2"
         $taskGroup = Get-VSTeamTaskGroup -projectName project -Name $taskGroupName

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/project/_apis/distributedtask/taskgroups?api-version=$(_getApiVersion TaskGroups)"
         }

         # Ensure that we only have one task group, in other words, that the name filter was applied.
         $taskGroup.name | Should -Be $taskGroupName
      }
   }
}