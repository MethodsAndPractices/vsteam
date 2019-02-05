Set-StrictMode -Version Latest

InModuleScope VSTeam {
   [VSTeamVersions]::Account = 'https://dev.azure.com/test'

   Describe "TeamMembers" {
      . "$PSScriptRoot\mocks\mockProjectNameDynamicParam.ps1"
        
      Context 'Get-VSTeamMember for specific project and team' {
         Mock Invoke-RestMethod { return @{value = 'teams'}}

         It 'Should return teammembers' {
            Get-VSTeamMember -ProjectName TestProject -TeamId TestTeam
            # Make sure it was called with the correct URI
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/_apis/projects/TestProject/teams/TestTeam/members?api-version=$([VSTeamVersions]::Core)"
            }
         }
      }

      Context 'Get-VSTeamMember for specific project and team, with top' {
         Mock Invoke-RestMethod { return @{value = 'teams'}}

         It 'Should return teammembers' {
            Get-VSTeamMember -ProjectName TestProject -TeamId TestTeam -Top 10
            # Make sure it was called with the correct URI
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -like "*https://dev.azure.com/test/_apis/projects/TestProject/teams/TestTeam/members*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
               $Uri -like "*`$top=10*"
            }
         }            
      }

      Context 'Get-VSTeamMember for specific project and team, with skip' {
         Mock Invoke-RestMethod { return @{value = 'teams'}}

         It 'Should return teammembers' {                
            Get-VSTeamMember -ProjectName TestProject -TeamId TestTeam -Skip 5
            # Make sure it was called with the correct URI
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -like "*https://dev.azure.com/test/_apis/projects/TestProject/teams/TestTeam/members*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
               $Uri -like "*`$skip=5*"
            }
         }
      }

      Context 'Get-VSTeamMember for specific project and team, with top and skip' {
         Mock Invoke-RestMethod { return @{value = 'teams'}}

         It 'Should return teammembers' {                
            Get-VSTeamMember -ProjectName TestProject -TeamId TestTeam -Top 10 -Skip 5
            # Make sure it was called with the correct URI
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -like "*https://dev.azure.com/test/_apis/projects/TestProject/teams/TestTeam/members*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
               $Uri -like "*`$top=10*" -and
               $Uri -like "*`$skip=5*"
            }
         }            
      }

      Context 'Get-VSTeamMember for specific team, fed through pipeline' {
         Mock Invoke-RestMethod { return @{value = 'teammembers'}}

         It 'Should return teammembers' {
            New-Object -TypeName PSObject -Prop @{projectname = "TestProject"; name = "TestTeam"} | Get-VSTeamMember
            
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/_apis/projects/TestProject/teams/TestTeam/members?api-version=$([VSTeamVersions]::Core)"                    
            }
         }
      }

      # Must be last because it sets [VSTeamVersions]::Account to $null
      Context '_buildURL handles exception' {
         
         # Arrange
         [VSTeamVersions]::Account = $null
         
         It 'should return approvals' {
         
            # Act
            { _buildURL -ProjectName project -TeamId 1 } | Should Throw
         }
      }
   }
}