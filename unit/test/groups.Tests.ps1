Set-StrictMode -Version Latest

InModuleScope VSTeam {

   # Set the account to use for testing. A normal user would do this
   # using the Set-VSTeamAccount function.
   [VSTeamVersions]::Account = 'https://dev.azure.com/test'

   $projectResult = [PSCustomObject]@{
      name        = 'Test Project Public'
      description = ''
      url         = ''
      id          = '010d06f0-00d5-472a-bb47-58947c230876'
      state       = ''
      visibility  = ''
      revision    = 0
      defaultTeam = [PSCustomObject]@{}
      _links      = [PSCustomObject]@{}
   }

   $scopeResult = Get-Content "$PSScriptRoot\sampleFiles\descriptor.scope.TestProject.json" -Raw | ConvertFrom-Json
   $groupListResult = Get-Content "$PSScriptRoot\sampleFiles\groups.json" -Raw | ConvertFrom-Json
   $groupSingleResult = Get-Content "$PSScriptRoot\sampleFiles\groupsSingle.json" -Raw | ConvertFrom-Json

   Describe 'Groups VSTS' {
      Context 'Get-VSTeamGroup by project' {
         Mock Get-VSTeamProject { return $projectResult } -Verifiable
         Mock Get-VSTeamDescriptor { return $scopeResult } -Verifiable
         Mock Invoke-RestMethod { return $groupListResult } -Verifiable

         Get-VSTeamGroup -ProjectName "Test Project Public"

         It 'Should return groups' {
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -eq "https://vssps.dev.azure.com/test/_apis/graph/groups?api-version=$([VSTeamVersions]::Graph)&scopeDescriptor=scp.ZGU5ODYwOWEtZjRiMC00YWEzLTgzOTEtODI4ZDU2MDI0MjU2"
            }
         }
      }

      Context 'Get-VSTeamGroup by scopeDescriptor' {
         Mock Invoke-RestMethod { return $groupListResult } -Verifiable

         Get-VSTeamGroup -ScopeDescriptor scp.ZGU5ODYwOWEtZjRiMC00YWEzLTgzOTEtODI4ZDU2MDI0MjU2

         It 'Should return groups' {
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -eq "https://vssps.dev.azure.com/test/_apis/graph/groups?api-version=$([VSTeamVersions]::Graph)&scopeDescriptor=scp.ZGU5ODYwOWEtZjRiMC00YWEzLTgzOTEtODI4ZDU2MDI0MjU2"
            }
         }
      }

      Context 'Get-VSTeamGroup by descriptor' {
         Mock Invoke-RestMethod { return $groupSingleResult } -Verifiable

         Get-VSTeamGroup -GroupDescriptor 'vssgp.Uy0xLTktMTU1MTM3NDI0NS04NTYwMDk3MjYtNDE5MzQ0MjExNy0yMzkwNzU2MTEwLTI3NDAxNjE4MjEtMC0wLTAtMC0x'

         It 'Should return the group' {
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -eq "https://vssps.dev.azure.com/test/_apis/graph/groups/vssgp.Uy0xLTktMTU1MTM3NDI0NS04NTYwMDk3MjYtNDE5MzQ0MjExNy0yMzkwNzU2MTEwLTI3NDAxNjE4MjEtMC0wLTAtMC0x?api-version=$([VSTeamVersions]::Graph)"
            }
         }
      }

      Context 'Get-VSTeamGroup by project throws' {
         Mock Invoke-RestMethod { throw 'Error' }

         It 'Should throw' {
            { Get-VSTeamGroup -ProjectName Demo } | Should Throw
         }
      }

      Context 'Get-VSTeamGroup by descriptor throws' {
         Mock Invoke-RestMethod { throw 'Error' }

         It 'Should throw' {
            { Get-VSTeamGroup -GroupDescriptor  } | Should Throw
         }
      }
   }
}