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

      Context 'Add-VSTeamPolicy' {
         Mock Invoke-RestMethod

         Add-VSTeamPolicy -ProjectName Demo -type babcf51f-d853-43a2-9b05-4a64ca577be0 -enabled -blocking -settings @{
            MinimumApproverCount = 1;
            scope = @(@{
               refName = "refs/heads/master";
               matchKind = "Exact";
               repositoryId = "10000000-0000-0000-0000-0000000000001"
            })
         }

         It 'Should add the policy' {
            Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter { 
               $Method -eq 'Post' -and
               $Uri -eq "https://test.visualstudio.com/Demo/_apis/policy/configurations/?api-version=$($VSTeamVersionTable.Core)" -and 
               $Body -eq '{"isBlocking":true,"isEnabled":true,"type":{"id":"babcf51f-d853-43a2-9b05-4a64ca577be0"},"settings":{"scope":[{"repositoryId":"10000000-0000-0000-0000-0000000000001","matchKind":"Exact","refName":"refs/heads/master"}],"MinimumApproverCount":1}}'
            }
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
            Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter { 
               $Method -eq 'Put' -and
               $Uri -eq "https://test.visualstudio.com/Demo/_apis/policy/configurations/1?api-version=$($VSTeamVersionTable.Core)" -and 
               $Body -eq '{"isBlocking":true,"isEnabled":true,"type":{"id":"babcf51f-d853-43a2-9b05-4a64ca577be0"},"settings":{"scope":[{"repositoryId":"20000000-0000-0000-0000-0000000000002","matchKind":"Exact","refName":"refs/heads/release"}],"MinimumApproverCount":1}}'
            }
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
   }
}