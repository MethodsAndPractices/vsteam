Set-StrictMode -Version Latest

Describe 'VSTeamApproval' -Tag 'unit', 'approvals' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' }

      Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamApproval.json' -Index 0 }
   }

   Context 'Set-VSTeamApproval' {      
      It 'should set approval' {
         Set-VSTeamApproval -projectName project -Id 1 -Status Rejected -Force

         Should -Invoke Invoke-RestMethod -Exactly -Scope Context -Times 1 `
            -ParameterFilter {
            $Method -eq 'Patch' -and
            $Uri -eq "https://vsrm.dev.azure.com/test/project/_apis/release/approvals/1?api-version=$(_getApiVersion Release)"
         }
      }
   }

   Context 'Set-VSTeamApproval handles exception' {
      BeforeAll {
         Mock _handleException
         Mock Invoke-RestMethod { throw 'testing error handling' }
      }
      
      It 'should set approval' {
         Set-VSTeamApproval -projectName project -Id 1 -Status Rejected -Force

         Should -Invoke Invoke-RestMethod -Exactly -Scope Context -Times 1 `
            -ParameterFilter {
            $Uri -eq "https://vsrm.dev.azure.com/test/project/_apis/release/approvals/1?api-version=$(_getApiVersion Release)"
         }
      }
   }

   Context 'Set-VSTeamApproval' {
      BeforeAll {
         Mock _useWindowsAuthenticationOnPremise { return $true }
         Set-VSTeamApproval -projectName project -Id 1 -Status Rejected -Force
      }

      It 'should set approval' {
         Should -Invoke Invoke-RestMethod -Exactly -Scope Context -Times 1 `
            -ParameterFilter {
            $Method -eq 'Patch' -and
            $Uri -eq "https://vsrm.dev.azure.com/test/project/_apis/release/approvals/1?api-version=$(_getApiVersion Release)"
         }
      }
   }
}

