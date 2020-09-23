Set-StrictMode -Version Latest

Describe 'VSTeamWorkItem' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      Mock Invoke-RestMethod
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Core' }
   }

   Context 'Remove-VSTeamWorkItem' {
      It 'Should delete single work item' {
         Remove-VSTeamWorkItem -Id 47 -Force

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/_apis/wit/workitems*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Uri -like "*workitems/47*"
         }
      }

      It 'Should throw single work item with id equals $null' {
         { Remove-VSTeamWorkItem -Id $null } | Should -Throw
      }

      It 'Should delete multipe work items' {
         Remove-VSTeamWorkItem -Id 47, 48 -Force

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 2 -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/_apis/wit/workitems*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            ($Uri -like "*workitems/47*" -or $Uri -like "*workitems/48*")
         }
      }

      It 'Single Work Item Should be deleted permanently' {
         Remove-VSTeamWorkItem -Id 47, 48 -Destroy -Force

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 2 -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/_apis/wit/workitems*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            ($Uri -like "*workitems/47*" -or $Uri -like "*workitems/48*") -and
            $Uri -like "*destroy=True*"
         }
      }
   }
}