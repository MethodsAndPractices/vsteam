Set-StrictMode -Version Latest

Describe 'VSTeamTaskGroup' {
   BeforeAll {
      Add-Type -Path "$PSScriptRoot/../../dist/bin/vsteam-lib.dll"
      
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")
      
      
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/Set-VSTeamAPIVersion.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"

      # Prime the project cache with an empty list. This will make sure
      # any project name used will pass validation and Get-VSTeamProject 
      # will not need to be called.
      [vsteam_lib.ProjectCache]::Update([string[]]@())
      
      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'TaskGroups' }
   }

   Context 'Remove-VSTeamTaskGroup' {
      BeforeAll {
         Mock Invoke-RestMethod
      }

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