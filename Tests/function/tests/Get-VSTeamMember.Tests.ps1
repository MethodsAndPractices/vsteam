Set-StrictMode -Version Latest

Describe "VSTeamMember" {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Core' }
   }

   Context 'Get-VSTeamMember for specific project and team' {
      BeforeAll {
         ## Arrange
         Mock Invoke-RestMethod { return @{value = 'teams' } }
      }

      It 'should return teammembers' {
         ## Act
         Get-VSTeamMember -ProjectName TestProject -TeamId TestTeam

         ## Assert
         # Make sure it was called with the correct URI
         Should -Invoke Invoke-RestMethod -Exactly 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/projects/TestProject/teams/TestTeam/members?api-version=$(_getApiVersion Core)"
         }
      }
   }

   Context 'Get-VSTeamMember for specific project and team, with top' {
      BeforeAll {
         ## Arrange
         Mock Invoke-RestMethod { return @{value = 'teams' } }
      }

      It 'should return teammembers' {
         ## Act
         Get-VSTeamMember -ProjectName TestProject -TeamId TestTeam -Top 10

         ## Assert
         # Make sure it was called with the correct URI
         Should -Invoke Invoke-RestMethod -Exactly 1 -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/_apis/projects/TestProject/teams/TestTeam/members*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Uri -like "*`$top=10*"
         }
      }
   }

   Context 'Get-VSTeamMember for specific project and team, with skip' {
      BeforeAll {
         ## Arrange
         Mock Invoke-RestMethod { return @{value = 'teams' } }
      }

      It 'should return teammembers' {
         ## Act
         Get-VSTeamMember -ProjectName TestProject -TeamId TestTeam -Skip 5

         ## Assert
         # Make sure it was called with the correct URI
         Should -Invoke Invoke-RestMethod -Exactly 1 -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/_apis/projects/TestProject/teams/TestTeam/members*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Uri -like "*`$skip=5*"
         }
      }
   }

   Context 'Get-VSTeamMember for specific project and team, with top and skip' {
      BeforeAll {
         ## Arrange
         Mock Invoke-RestMethod { return @{value = 'teams' } }
      }

      It 'should return teammembers' {
         ## Act
         Get-VSTeamMember -ProjectName TestProject -TeamId TestTeam -Top 10 -Skip 5

         ## Assert
         # Make sure it was called with the correct URI
         Should -Invoke Invoke-RestMethod -Exactly 1 -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/_apis/projects/TestProject/teams/TestTeam/members*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Uri -like "*`$top=10*" -and
            $Uri -like "*`$skip=5*"
         }
      }
   }

   Context 'Get-VSTeamMember for specific team, fed through pipeline' {
      BeforeAll {
         ## Arrange
         Mock Invoke-RestMethod { return @{ value = 'teammembers' } }
      }

      It 'should return teammembers' {
         ## Act
         New-Object -TypeName PSObject -Prop @{ projectname = "TestProject"; name = "TestTeam" } | Get-VSTeamMember

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/projects/TestProject/teams/TestTeam/members?api-version=$(_getApiVersion Core)"
         }
      }
   }

   # Must be last because it sets [vsteam_lib.Versions]::Account to $null
   Context '_buildURL handles exception' {
      BeforeAll {
         # Arrange
         [vsteam_lib.Versions]::Account = $null
      }

      It 'should return approvals' {
         # Act / Assert
         { _buildURL -ProjectName project -TeamId 1 } | Should -Throw
      }
   }
}