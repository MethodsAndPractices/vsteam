Set-StrictMode -Version Latest

InModuleScope policyTypes {
   
   # Set the account to use for testing. A normal user would do this
   # using the Add-VSTeamAccount function.
   [VSTeamVersions]::Account = 'https://test.visualstudio.com'

   $results = [PSCustomObject]@{
      value = [PSCustomObject]@{ }
   }

   $singleResult = [PSCustomObject]@{ }

   Describe "Policies VSTS" {

      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter {
         $Uri -like "*_apis/projects*" 
      }
      
      Context 'Get-VSTeamPolicyType by project' {
         Mock Invoke-RestMethod { return $results } -Verifiable

         Get-VSTeamPolicyType -ProjectName Demo

         It 'Should return policies' {
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/Demo/_apis/policy/types/?api-version=$([VSTeamVersions]::Core)"
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
               $Uri -eq "https://test.visualstudio.com/Demo/_apis/policy/types/90a51335-0c53-4a5f-b6ce-d9aff3ea60e0?api-version=$([VSTeamVersions]::Core)"
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