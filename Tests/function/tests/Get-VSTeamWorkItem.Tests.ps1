Set-StrictMode -Version Latest

Describe 'VSTeamWorkItem' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Core' }
   }

   Context 'Get-VSTeamWorkItem' {
      BeforeAll {
         Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamWorkItem-Id16.json' }
         Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamWorkItem-Id.json' } -ParameterFilter { $Uri -like "*ids=47,48*" }
      }

      It 'by id should return work items' {
         Get-VSTeamWorkItem -Id 47, 48

         # With PowerShell core the order of the query string is not the
         # same from run to run!  So instead of testing the entire string
         # matches I have to search for the portions I expect but can't
         # assume the order.
         # The general string should look like this:
         # https://dev.azure.com/test/test/_apis/wit/workitems/?api-version=$(_getApiVersion Core)&ids=47,48&`$Expand=None&errorPolicy=omit

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/_apis/wit/workitems*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Uri -like "*ids=47,48*" -and
            $Uri -like "*`$Expand=None*" -and
            $Uri -like "*errorPolicy=omit*"
         }
      }

      It 'by Id with Default Project should return single work item' {
         Get-VSTeamWorkItem -Id 47

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/wit/workitems/47?api-version=$(_getApiVersion Core)&`$Expand=None"
         }
      }
   }
}