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

   # The Graph API is not supported on TFS
   Describe "Groups TFS Errors" {
     Context 'Get-VSTeamGroup' {
         Mock _callAPI { throw 'Should not be called' } -Verifiable

         It 'Should throw' {
            Set-VSTeamAPIVersion TFS2017

            { Get-VSTeamGroup } | Should Throw
         }

         It '_callAPI should be called once to get projects' {
            Assert-MockCalled _callAPI -Exactly 1
         }
      }
   }

   Describe 'Groups VSTS' {
      # You have to set the version or the api-version will not be added when 
      # [VSTeamVersions]::Graph = ''
      [VSTeamVersions]::Graph = '5.0'
      
      Context 'Get-VSTeamGroup by project' {
         Mock Get-VSTeamProject { return $projectResult } -Verifiable
         Mock Get-VSTeamDescriptor { return  [VSTeamDescriptor]::new($scopeResult) } -Verifiable
         Mock Invoke-RestMethod {
            # If this test fails uncomment the line below to see how the mock was called.
            # Write-Host $args
         
            return $groupListResult 
         } -Verifiable

         Get-VSTeamGroup -ProjectName "Test Project Public"

         It 'Should return groups' {
            # With PowerShell core the order of the query string is not the
            # same from run to run!  So instead of testing the entire string
            # matches I have to search for the portions I expect but can't
            # assume the order.
            # The general string should look like this:
            # "https://vssps.dev.azure.com/test/_apis/graph/groups?api-version=$([VSTeamVersions]::Graph)&scopeDescriptor=scp.ZGU5ODYwOWEtZjRiMC00YWEzLTgzOTEtODI4ZDU2MDI0MjU2"
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -like "https://vssps.dev.azure.com/test/_apis/graph/groups*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Graph)*" -and
               $Uri -like "*scopeDescriptor=scp.ZGU5ODYwOWEtZjRiMC00YWEzLTgzOTEtODI4ZDU2MDI0MjU2*"
            }
         }
      }

      Context 'Get-VSTeamGroup by scopeDescriptor' {
         Mock Invoke-RestMethod { return $groupListResult } -Verifiable

         Get-VSTeamGroup -ScopeDescriptor scp.ZGU5ODYwOWEtZjRiMC00YWEzLTgzOTEtODI4ZDU2MDI0MjU2

         It 'Should return groups' {
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -like "https://vssps.dev.azure.com/test/_apis/graph/groups*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Graph)*" -and
               $Uri -like "*scopeDescriptor=scp.ZGU5ODYwOWEtZjRiMC00YWEzLTgzOTEtODI4ZDU2MDI0MjU2*"
            }
         }
      }

      Context 'Get-VSTeamGroup by subjectTypes' {
         Mock Invoke-RestMethod { return $groupListResult } -Verifiable

         Get-VSTeamGroup -SubjectTypes vssgp,aadgp

         It 'Should return groups' {
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -like "https://vssps.dev.azure.com/test/_apis/graph/groups*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Graph)*" -and
               $Uri -like "*subjectTypes=vssgp,aadgp*"
            }
         }
      }

      Context 'Get-VSTeamGroup by subjectTypes and scopeDescriptor' {
         Mock Invoke-RestMethod { return $groupListResult } -Verifiable

         Get-VSTeamGroup -ScopeDescriptor scp.ZGU5ODYwOWEtZjRiMC00YWEzLTgzOTEtODI4ZDU2MDI0MjU2 -SubjectTypes vssgp,aadgp

         It 'Should return groups' {
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -like "https://vssps.dev.azure.com/test/_apis/graph/groups*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Graph)*" -and
               $Uri -like "*subjectTypes=vssgp,aadgp*" -and
               $Uri -like "*scopeDescriptor=scp.ZGU5ODYwOWEtZjRiMC00YWEzLTgzOTEtODI4ZDU2MDI0MjU2*"
            }
         }
      }

      Context 'Get-VSTeamGroup by descriptor' {
         Mock Invoke-RestMethod { return $groupSingleResult } -Verifiable

         Get-VSTeamGroup -GroupDescriptor 'vssgp.Uy0xLTktMTU1MTM3NDI0NS04NTYwMDk3MjYtNDE5MzQ0MjExNy0yMzkwNzU2MTEwLTI3NDAxNjE4MjEtMC0wLTAtMC0x'

         It 'Should return the group' {
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -like "https://vssps.dev.azure.com/test/_apis/graph/groups/vssgp.Uy0xLTktMTU1MTM3NDI0NS04NTYwMDk3MjYtNDE5MzQ0MjExNy0yMzkwNzU2MTEwLTI3NDAxNjE4MjEtMC0wLTAtMC0x*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Graph)*"
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