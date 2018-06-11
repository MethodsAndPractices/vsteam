Set-StrictMode -Version Latest

Get-Module VSTeam | Remove-Module -Force

Import-Module $PSScriptRoot\..\..\src\team.psm1 -Force
Import-Module $PSScriptRoot\..\..\src\policies.psm1 -Force

InModuleScope policies {
   
   # Set the account to use for testing. A normal user would do this
   # using the Add-VSTeamAccount function.
   $VSTeamVersionTable.Account = 'https://test.visualstudio.com'

   $results = [PSCustomObject]@{
      value = [PSCustomObject]@{ }
   }

   $singleResult = [PSCustomObject]@{ }

   Describe "Policies VSTS" {
      
      Context 'Get-VSTeamPolicy by project' {
         Mock Invoke-RestMethod { return $results } -Verifiable

         Get-VSTeamPolicy -ProjectName Demo

         It 'Should return policies' {
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/Demo/_apis/policy/configurations/?api-version=$($VSTeamVersionTable.Core)"
            }
         }
      }

      Context 'Get-VSTeamPolicy by project and id' {
         Mock Invoke-RestMethod { return $results } -Verifiable

         Get-VSTeamPolicy -ProjectName Demo -Id 4

         It 'Should return the policy' {
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/Demo/_apis/policy/configurations/4?api-version=$($VSTeamVersionTable.Core)"
            }
         }
      }

      Context 'Get-VSTeamPolicy by project throws' {
         Mock Invoke-RestMethod { throw 'Error' }

         It 'Should throw' {
            { Get-VSTeamPolicy -ProjectName Demo } | Should Throw
         }
      }

      Context 'Get-VSTeamPolicy by project and id throws' {
         Mock Invoke-RestMethod { throw 'Error' }

         It 'Should throw' {
            { Get-VSTeamPolicy -ProjectName Demo -Id 4 } | Should Throw
         }
      }

      Context 'Remove-VSTeamPolicy by id' {
         Mock Invoke-RestMethod

         Remove-VSTeamPolicy -ProjectName Demo -id 4 -Force

         It 'Should delete the policy' {
            Assert-MockCalled Invoke-RestMethod -ParameterFilter {
               $Method -eq 'Delete' -and
               $Uri -eq "https://test.visualstudio.com/Demo/_apis/policy/configurations/4?api-version=$($VSTeamVersionTable.Core)"
            }
         }
      }

      Context 'Remove-VSTeamPolicy by id throws' {
         Mock Invoke-RestMethod { throw 'Error' }

         It 'Should throw' {
            { Remove-VSTeamPolicy -ProjectName Demo -id 4 -Force } | Should Throw
         }
      }

      Context 'Add-VSTeamPolicy' {
         Mock Invoke-RestMethod {
            # If this test fails uncomment the line below to see how the mock was called.
            #Write-Host $args
         }

         Add-VSTeamPolicy -ProjectName Demo -type babcf51f-d853-43a2-9b05-4a64ca577be0 -enabled -blocking -settings @{
            MinimumApproverCount = 1;
            scope = @(@{
               refName = "refs/heads/master";
               matchKind = "Exact";
               repositoryId = "10000000-0000-0000-0000-0000000000001"
            })
         }

         It 'Should add the policy' {
            # With PowerShell core the order of the boty string is not the 
            # same from run to run!  So instead of testing the entire string
            # matches I have to search for the portions I expect but can't
            # assume the order. 
            # The general string should look like this:
            # '{"isBlocking":true,"isEnabled":true,"type":{"id":"babcf51f-d853-43a2-9b05-4a64ca577be0"},"settings":{"scope":[{"repositoryId":"10000000-0000-0000-0000-0000000000001","matchKind":"Exact","refName":"refs/heads/master"}],"MinimumApproverCount":1}}'
            Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter { 
               $Method -eq 'Post' -and
               $Uri -eq "https://test.visualstudio.com/Demo/_apis/policy/configurations/?api-version=$($VSTeamVersionTable.Core)" -and 
               $Body -like '*"isBlocking":true*' -and
               $Body -like '*"isEnabled":true*' -and
               $Body -like '*"type":{"id":"babcf51f-d853-43a2-9b05-4a64ca577be0"}*' -and
               $Body -like '*"MinimumApproverCount":1*' -and
               $Body -like '*"settings":*' -and
               $Body -like '*"scope":*' -and
               $Body -like '*"repositoryId":"10000000-0000-0000-0000-0000000000001"*' -and
               $Body -like '*"matchKind":"Exact"*' -and
               $Body -like '*"refName":"refs/heads/master"*'
            }
         }
      }

      Context 'Add-VSTeamPolicy throws' {
         Mock Invoke-RestMethod { throw 'Error' }

         It 'Should throw' {
            { Add-VSTeamPolicy -ProjectName Demo -type babcf51f-d853-43a2-9b05-4a64ca577be0 -enabled -blocking -settings @{
               MinimumApproverCount = 1;
               scope = @(@{
                  refName = "refs/heads/master";
                  matchKind = "Exact";
                  repositoryId = "10000000-0000-0000-0000-0000000000001"
               })
            } } | Should Throw
         }
      }

      Context 'Update-VSTeamPolicy' {
         Mock Invoke-RestMethod

         Update-VSTeamPolicy -ProjectName Demo -id 1 -type babcf51f-d853-43a2-9b05-4a64ca577be0 -enabled -blocking -settings @{
            MinimumApproverCount = 1;
            scope = @(@{
               refName = "refs/heads/release";
               matchKind = "Exact";
               repositoryId = "20000000-0000-0000-0000-0000000000002"
            })
         }

         It 'Should add the policy' {
            # With PowerShell core the order of the boty string is not the 
            # same from run to run!  So instead of testing the entire string
            # matches I have to search for the portions I expect but can't
            # assume the order. 
            # The general string should look like this:
            #'{"isBlocking":true,"isEnabled":true,"type":{"id":"babcf51f-d853-43a2-9b05-4a64ca577be0"},"settings":{"scope":[{"repositoryId":"20000000-0000-0000-0000-0000000000002","matchKind":"Exact","refName":"refs/heads/release"}],"MinimumApproverCount":1}}'
            Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter { 
               $Method -eq 'Put' -and
               $Uri -eq "https://test.visualstudio.com/Demo/_apis/policy/configurations/1?api-version=$($VSTeamVersionTable.Core)" -and 
               $Body -like '*"isBlocking":true*' -and
               $Body -like '*"isEnabled":true*' -and
               $Body -like '*"type":*' -and
               $Body -like '*"id":"babcf51f-d853-43a2-9b05-4a64ca577be0"*' -and
               $Body -like '*"settings":*' -and
               $Body -like '*"scope":*' -and
               $Body -like '*"repositoryId":"20000000-0000-0000-0000-0000000000002"*' -and
               $Body -like '*"matchKind":"Exact"*' -and
               $Body -like '*"refName":"refs/heads/release"*' -and
               $Body -like '*"MinimumApproverCount":1*'
            }
         }
      }

      Context 'Update-VSTeamPolicy throws' {
         Mock Invoke-RestMethod { throw 'Error' }

         It 'Should add the policy' {
            { Update-VSTeamPolicy -ProjectName Demo -id 1 -type babcf51f-d853-43a2-9b05-4a64ca577be0 -enabled -blocking -settings @{
               MinimumApproverCount = 1;
               scope = @(@{
                  refName = "refs/heads/release";
                  matchKind = "Exact";
                  repositoryId = "20000000-0000-0000-0000-0000000000002"
               })
            } } | Should Throw
         }
      }

      Context 'Get-VSTeamPolicyType by project' {
         Mock Invoke-RestMethod { return $results } -Verifiable

         Get-VSTeamPolicyType -ProjectName Demo

         It 'Should return policies' {
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/Demo/_apis/policy/types/?api-version=$($VSTeamVersionTable.Core)"
            }
         }
      }

      Context 'Get-VSTeamPolicyType by project throws' {
         Mock Invoke-RestMethod { throw 'Error' }

         It 'Should throw' {
            { Get-VSTeamPolicyType -ProjectName Demo } | Should Throw
         }
      }

      Context 'Get-VSTeamPolicyType by id' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         Get-VSTeamPolicyType -ProjectName Demo -id 90a51335-0c53-4a5f-b6ce-d9aff3ea60e0

         It 'Should return policies' {
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/Demo/_apis/policy/types/90a51335-0c53-4a5f-b6ce-d9aff3ea60e0?api-version=$($VSTeamVersionTable.Core)"
            }
         }
      }

      Context 'Get-VSTeamPolicyType by id throws' {
         Mock Invoke-RestMethod { throw 'Error' }

         It 'Should return policies' {
            { Get-VSTeamPolicyType -ProjectName Demo -id 90a51335-0c53-4a5f-b6ce-d9aff3ea60e0 } | Should Throw
         }
      }
   }
}