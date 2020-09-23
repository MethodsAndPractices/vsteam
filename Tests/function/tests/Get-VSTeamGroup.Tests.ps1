Set-StrictMode -Version Latest

Describe "VSTeamGroup" {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$baseFolder/Source/Public/Get-VSTeamProject.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamDescriptor.ps1"
   }
   
   Context 'Get-VSTeamGroup' {
      Context 'Services' {
         BeforeAll {
            # You have to set the version or the api-version will not be added when versions = ''
            Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Graph' }

            # Set the account to use for testing. A normal user would do this
            # using the Set-VSTeamAccount function.
            Mock _getInstance { return 'https://dev.azure.com/test' }

            Mock _supportsGraph
            Mock Invoke-RestMethod { Open-SampleFile 'groups.json' }
            Mock Get-VSTeamProject { Open-SampleFile 'projectResult.json' } -ParameterFilter {
               $Name -like "Test Project Public"
            }
         }

         It 'should return groups by project' {            
            Mock Get-VSTeamDescriptor { return [vsteam_lib.Descriptor]::new($(Open-SampleFile 'descriptor.scope.TestProject.json')) }

            Get-VSTeamGroup -ProjectName "Test Project Public"

            # With PowerShell core the order of the query string is not the
            # same from run to run!  So instead of testing the entire string
            # matches I have to search for the portions I expect but can't
            # assume the order.
            # The general string should look like this:
            # "https://vssps.dev.azure.com/test/_apis/graph/groups?api-version=$(_getApiVersion Graph)&scopeDescriptor=scp.ZGU5ODYwOWEtZjRiMC00YWEzLTgzOTEtODI4ZDU2MDI0MjU2"
            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -like "https://vssps.dev.azure.com/test/_apis/graph/groups*" -and
               $Uri -like "*api-version=$(_getApiVersion Graph)*" -and
               $Uri -like "*scopeDescriptor=scp.ZGU5ODYwOWEtZjRiMC00YWEzLTgzOTEtODI4ZDU2MDI0MjU2*"
            }
         }

         It 'should return groups by scopeDescriptor' {
            Get-VSTeamGroup -ScopeDescriptor scp.ZGU5ODYwOWEtZjRiMC00YWEzLTgzOTEtODI4ZDU2MDI0MjU2

            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -like "https://vssps.dev.azure.com/test/_apis/graph/groups*" -and
               $Uri -like "*api-version=$(_getApiVersion Graph)*" -and
               $Uri -like "*scopeDescriptor=scp.ZGU5ODYwOWEtZjRiMC00YWEzLTgzOTEtODI4ZDU2MDI0MjU2*"
            }
         }

         It 'should return groups by subjectTypes' {
            Get-VSTeamGroup -SubjectTypes vssgp, aadgp

            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -like "https://vssps.dev.azure.com/test/_apis/graph/groups*" -and
               $Uri -like "*api-version=$(_getApiVersion Graph)*" -and
               $Uri -like "*subjectTypes=vssgp,aadgp*"
            }
         }

         It 'should return groups by subjectTypes and scopeDescriptor' {
            Get-VSTeamGroup -ScopeDescriptor scp.ZGU5ODYwOWEtZjRiMC00YWEzLTgzOTEtODI4ZDU2MDI0MjU2 -SubjectTypes vssgp, aadgp

            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -like "https://vssps.dev.azure.com/test/_apis/graph/groups*" -and
               $Uri -like "*api-version=$(_getApiVersion Graph)*" -and
               $Uri -like "*subjectTypes=vssgp,aadgp*" -and
               $Uri -like "*scopeDescriptor=scp.ZGU5ODYwOWEtZjRiMC00YWEzLTgzOTEtODI4ZDU2MDI0MjU2*"
            }
         }

         It 'should return the group by descriptor' {
            Mock Invoke-RestMethod { Open-SampleFile 'groupsSingle.json' }

            Get-VSTeamGroup -GroupDescriptor 'vssgp.Uy0xLTktMTU1MTM3NDI0NS04NTYwMDk3MjYtNDE5MzQ0MjExNy0yMzkwNzU2MTEwLTI3NDAxNjE4MjEtMC0wLTAtMC0x'

            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -like "https://vssps.dev.azure.com/test/_apis/graph/groups/vssgp.Uy0xLTktMTU1MTM3NDI0NS04NTYwMDk3MjYtNDE5MzQ0MjExNy0yMzkwNzU2MTEwLTI3NDAxNjE4MjEtMC0wLTAtMC0x*" -and
               $Uri -like "*api-version=$(_getApiVersion Graph)*"
            }
         }

         It 'Should throw' {
            Mock Invoke-RestMethod { throw 'Error' }
            { Get-VSTeamGroup -ProjectName Demo } | Should -Throw
         }

         It 'Should throw' {
            Mock Invoke-RestMethod { throw 'Error' }
            { Get-VSTeamGroup -GroupDescriptor } | Should -Throw
         }
      }
   }

   Context 'Server' {
      BeforeAll {
         # Set the account to use for testing. A normal user would do this
         # using the Set-VSTeamAccount function.
         Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' }
         Mock _callAPI

         Mock _getApiVersion { return 'TFS2017' }
         Mock _getApiVersion { return '' } -ParameterFilter { $Service -eq 'Graph' }

         # The Graph API is not supported on TFS
         Mock _supportsGraph { throw 'This account does not support the graph API.' }
      }

      It 'Should throw' {
         { Get-VSTeamGroup } | Should -Throw
      }

      It 'should not call _callAPI' {
         Should -Invoke _callAPI -Exactly -Times 0 -Scope Context
      }
   }
}

