Set-StrictMode -Version Latest

InModuleScope VSTeam {
   Describe 'Users VSTS' {
      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable
   
      # You have to set the version or the api-version will not be added when
      # [VSTeamVersions]::Graph = ''
      [VSTeamVersions]::Graph = '5.0'

      Context 'Test-VSTeamMembership' {
         Mock Invoke-RestMethod {  } -Verifiable

         $UserDescriptor = 'aad.OTcyOTJkNzYtMjc3Yi03OTgxLWIzNDMtNTkzYmM3ODZkYjlj'
         $GroupDescriptor = 'vssgp.Uy0xLTktMTU1MTM3NDI0NS04NTYwMDk3MjYtNDE5MzQ0MjExNy0yMzkwNzU2MTEwLTI3NDAxNjE4MjEtMC0wLTAtMC0x'

         $result = Test-VSTeamMembership -MemberDescriptor $UserDescriptor -ContainerDescriptor $GroupDescriptor
         It 'Should test membership' {
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Method -eq "Head" -and
               $Uri -like "https://vssps.dev.azure.com/test/_apis/graph/memberships/$UserDescriptor/$GroupDescriptor*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Graph)*"
            }
            $result | Should Be $true
         }
      }

      Context 'Add-VSTeamMembership' {
         Mock Invoke-RestMethod { } -Verifiable

         $UserDescriptor = 'aad.OTcyOTJkNzYtMjc3Yi03OTgxLWIzNDMtNTkzYmM3ODZkYjlj'
         $GroupDescriptor = 'vssgp.Uy0xLTktMTU1MTM3NDI0NS04NTYwMDk3MjYtNDE5MzQ0MjExNy0yMzkwNzU2MTEwLTI3NDAxNjE4MjEtMC0wLTAtMC0x'

         $null = Add-VSTeamMembership -MemberDescriptor $UserDescriptor -ContainerDescriptor $GroupDescriptor
         It 'Should add membership' {
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Method -eq "Put" -and
               $Uri -like "https://vssps.dev.azure.com/test/_apis/graph/memberships/$UserDescriptor/$GroupDescriptor*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Graph)*"
            }
         }
      }

      Context 'Remove-VSTeamMembership' {
         Mock Invoke-RestMethod { } -Verifiable

         $UserDescriptor = 'aad.OTcyOTJkNzYtMjc3Yi03OTgxLWIzNDMtNTkzYmM3ODZkYjlj'
         $GroupDescriptor = 'vssgp.Uy0xLTktMTU1MTM3NDI0NS04NTYwMDk3MjYtNDE5MzQ0MjExNy0yMzkwNzU2MTEwLTI3NDAxNjE4MjEtMC0wLTAtMC0x'

         $null = Remove-VSTeamMembership -MemberDescriptor $UserDescriptor -ContainerDescriptor $GroupDescriptor -Force
         It 'Should remove a membership' {
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Method -eq "Delete" -and
               $Uri -like "https://vssps.dev.azure.com/test/_apis/graph/memberships/$UserDescriptor/$GroupDescriptor*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Graph)*"
            }
         }
      }

      Context 'Get-VSTeamMembership for Member' {
         Mock Invoke-RestMethod { } -Verifiable

         $UserDescriptor = 'aad.OTcyOTJkNzYtMjc3Yi03OTgxLWIzNDMtNTkzYmM3ODZkYjlj'

         $null = Get-VSTeamMembership -MemberDescriptor $UserDescriptor
         It "Should get a container's members" {
            # This should stop the call to cache projects
            [VSTeamProjectCache]::timestamp = (Get-Date).Minute

            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Method -eq "Get" -and
               $Uri -like "https://vssps.dev.azure.com/test/_apis/graph/memberships/$MemberDescriptor*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Graph)*"
            }
         }
      }

      Context 'Get-VSTeamMembership for Group' {
         Mock Invoke-RestMethod { } -Verifiable

         $GroupDescriptor = 'vssgp.Uy0xLTktMTU1MTM3NDI0NS04NTYwMDk3MjYtNDE5MzQ0MjExNy0yMzkwNzU2MTEwLTI3NDAxNjE4MjEtMC0wLTAtMC0x'

         $null = Get-VSTeamMembership -ContainerDescriptor $GroupDescriptor
         It "Should get a container's members" {
            # This should stop the call to cache projects
            [VSTeamProjectCache]::timestamp = (Get-Date).Minute

            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Method -eq "Get" -and
               $Uri -like "https://vssps.dev.azure.com/test/_apis/graph/memberships/$GroupDescriptor*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Graph)*" -and
               $Uri -like "*direction=Down*"
            }
         }
      }
   }
}
