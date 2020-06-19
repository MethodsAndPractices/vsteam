Set-StrictMode -Version Latest

Describe "VSTeamMember" {
   BeforeAll {
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")
   
      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/Set-VSTeamAPIVersion.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"
   

      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Core' }
   }

   Context 'Get-VSTeamMember for specific project and team' {
      BeforeAll {
         Mock Invoke-RestMethod { return @{value = 'teams' } }
      }

      It 'Should return teammembers' {
         Get-VSTeamMember -ProjectName TestProject -TeamId TestTeam
         # Make sure it was called with the correct URI
         Should -Invoke Invoke-RestMethod -Exactly 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/projects/TestProject/teams/TestTeam/members?api-version=$(_getApiVersion Core)"
         }
      }
   }

   Context 'Get-VSTeamMember for specific project and team, with top' {
      BeforeAll {
         Mock Invoke-RestMethod { return @{value = 'teams' } }
      }

      It 'Should return teammembers' {
         Get-VSTeamMember -ProjectName TestProject -TeamId TestTeam -Top 10
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
         Mock Invoke-RestMethod { return @{value = 'teams' } }
      }

      It 'Should return teammembers' {
         Get-VSTeamMember -ProjectName TestProject -TeamId TestTeam -Skip 5
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
         Mock Invoke-RestMethod { return @{value = 'teams' } }
      }

      It 'Should return teammembers' {
         Get-VSTeamMember -ProjectName TestProject -TeamId TestTeam -Top 10 -Skip 5
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
         Mock Invoke-RestMethod { return @{value = 'teammembers' } }
      }

      It 'Should return teammembers' {
         New-Object -TypeName PSObject -Prop @{projectname = "TestProject"; name = "TestTeam" } | Get-VSTeamMember

         Should -Invoke Invoke-RestMethod -Exactly 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/projects/TestProject/teams/TestTeam/members?api-version=$(_getApiVersion Core)"
         }
      }
   }

   # Must be last because it sets [VSTeamVersions]::Account to $null
   Context '_buildURL handles exception' {
      BeforeAll {

         # Arrange
         [VSTeamVersions]::Account = $null
      }

      It 'should return approvals' {

         # Act
         { _buildURL -ProjectName project -TeamId 1 } | Should -Throw
      }
   }
}