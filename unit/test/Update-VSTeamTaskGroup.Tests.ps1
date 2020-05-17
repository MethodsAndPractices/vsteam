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
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamTaskGroup.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"
      
      $taskGroupJson = "$PSScriptRoot\sampleFiles\taskGroup.json"
      $taskGroupJsonAsString = Get-Content $taskGroupJson -Raw

      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'TaskGroups' }

      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter { $Uri -like "*_apis/project*" }
   }

   Context 'Update-VSTeamTaskGroup' {
      BeforeAll {
         Mock Invoke-RestMethod {
            return Get-Content $taskGroupJson | ConvertFrom-Json
         }
      }

      It 'should update a task group using body param' {
         $taskGroupToUpdate = Get-VSTeamTaskGroup -Name "For Unit Tests" -ProjectName 'project'

         Update-VSTeamTaskGroup -ProjectName 'project' -Body $taskGroupJsonAsString -Id $taskGroupToUpdate.id

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/project/_apis/distributedtask/taskgroups/$($taskGroupToUpdate.id)?api-version=$(_getApiVersion TaskGroups)" -and
            $Body -eq $taskGroupJsonAsString -and
            $Method -eq "Put"
         }
      }

      It 'should update a task group using infile param' {
         $taskGroupToUpdate = Get-VSTeamTaskGroup -Name "For Unit Tests" -ProjectName 'project'

         Update-VSTeamTaskGroup -ProjectName 'project' -InFile $taskGroupJson -Id $taskGroupToUpdate.id

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/project/_apis/distributedtask/taskgroups/$($taskGroupToUpdate.id)?api-version=$(_getApiVersion TaskGroups)" -and
            $InFile -eq $taskGroupJson -and
            $Method -eq "Put"
         }
      }
   }
}