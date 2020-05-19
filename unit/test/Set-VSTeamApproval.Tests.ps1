Set-StrictMode -Version Latest

Describe 'VSTeamApproval' -Tag 'unit', 'approvals' {
   BeforeAll {
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")
      
      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"
      
      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' }

      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter {
         $Uri -like "*_apis/projects*"
      }
   }

   Context 'Set-VSTeamApproval' {
      BeforeAll {
         Mock Invoke-RestMethod { return @{
               id       = 1
               revision = 1
               approver = @{
                  id          = 'c1f4b9a6-aee1-41f9-a2e0-070a79973ae9'
                  displayName = 'Test User'
               }
            } }

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

   Context 'Set-VSTeamApproval handles exception' {
      BeforeAll {
         Mock _handleException -Verifiable
         Mock Invoke-RestMethod { throw 'testing error handling' }

         Set-VSTeamApproval -projectName project -Id 1 -Status Rejected -Force
      }

      It 'should set approval' {
         Should -Invoke Invoke-RestMethod -Exactly -Scope Context -Times 1 `
            -ParameterFilter {
            $Uri -eq "https://vsrm.dev.azure.com/test/project/_apis/release/approvals/1?api-version=$(_getApiVersion Release)"
         }
      }
   }

   Context 'Set-VSTeamApproval' {
      BeforeAll {
         Mock _useWindowsAuthenticationOnPremise { return $true }
         Mock Invoke-RestMethod { return @{
               id       = 1
               revision = 1
               approver = @{
                  id          = 'c1f4b9a6-aee1-41f9-a2e0-070a79973ae9'
                  displayName = 'Test User'
               }
            } }

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

