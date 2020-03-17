Set-StrictMode -Version Latest

$env:Testing=$true
InModuleScope VSTeam {
   $singleResult = [PSCustomObject]@{
      commit        = [PSCustomObject]@{
         commitId  = '67cae2b029dff7eb3dc062b49403aaedca5bad8d'
         author    = [PSCustomObject]@{
            name  = '"Chuck Reinhart'
            email = 'fabrikamfiber3@hotmail.com'
            date  = '2014-01-29T23:52:56Z'
         }
         committer = [PSCustomObject]@{
            name  = '"Chuck Reinhart'
            email = 'fabrikamfiber3@hotmail.com'
            date  = '2014-01-29T23:52:56Z'
         }
         comment   = 'home page'
         url       = 'https://dev.azure.com/fabrikam/_apis/git/repositories/278d5cd2-584d-4b63-824a-2ba458937249/commits/67cae2b029dff7eb3dc062b49403aaedca5bad8d'
      }
      name          = 'develop'
      aheadCount    = 1
      behindCount   = 17
      isBaseVersion = $false
   }

   $multipleResults = [PSCustomObject]@{
      count = 3
      value = @(
         [PSCustomObject]@{
            commit        = [PSCustomObject]@{
               commitId  = '67cae2b029dff7eb3dc062b49403aaedca5bad8d'
               author    = [PSCustomObject]@{
                  name  = '"Chuck Reinhart'
                  email = 'fabrikamfiber3@hotmail.com'
                  date  = '2014-01-29T23:52:56Z'
               }
               committer = [PSCustomObject]@{
                  name  = '"Chuck Reinhart'
                  email = 'fabrikamfiber3@hotmail.com'
                  date  = '2014-01-29T23:52:56Z'
               }
               comment   = 'home page'
               url       = 'https://dev.azure.com/fabrikam/_apis/git/repositories/278d5cd2-584d-4b63-824a-2ba458937249/commits/67cae2b029dff7eb3dc062b49403aaedca5bad8d'
            }
            name          = 'develop'
            aheadCount    = 1
            behindCount   = 17
            isBaseVersion = $false
         },
         [PSCustomObject]@{
            commit        = [PSCustomObject]@{
               parents   = @('fe17a84cc2dfe0ea3a2202ab4dbac0706058e41f')
               treeId    = '8263e7232a2331c563d737e4fc4e9c66a8286c63'
               commitId  = '23d0bc5b128a10056dc68afece360d8a0fabb014'
               author    = [PSCustomObject]@{
                  name  = 'Norman Paulk'
                  email = 'Fabrikamfiber16@hotmail.com'
                  date  = '2014-06-30T18:10:55Z'
               }
               committer = [PSCustomObject]@{
                  name  = 'Norman Paulk'
                  email = 'Fabrikamfiber16@hotmail.com'
                  date  = '2014-06-30T18:10:55Z'
               }
               comment   = 'Better description for hello world\n'
               url       = 'https://dev.azure.com/fabrikam/_apis/git/repositories/278d5cd2-584d-4b63-824a-2ba458937249/commits/23d0bc5b128a10056dc68afece360d8a0fabb014'
            }
            name          = 'master'
            aheadCount    = 0
            behindCount   = 0
            isBaseVersion = $true
         },
         [PSCustomObject]@{
            commit        = [PSCustomObject]@{
               parents   = @('fe17a84cc2dfe0ea3a2202ab4dbac0706058e41f')
               treeId    = '8263e7232a2331c563d737e4fc4e9c66a8286c63'
               commitId  = '23d0bc5b128a10056dc68afece360d8a0fabb014'
               author    = [PSCustomObject]@{
                  name  = 'Norman Paulk'
                  email = 'Fabrikamfiber16@hotmail.com'
                  date  = '2014-06-30T18:10:55Z'
               }
               committer = [PSCustomObject]@{
                  name  = 'Norman Paulk'
                  email = 'Fabrikamfiber16@hotmail.com'
                  date  = '2014-06-30T18:10:55Z'
               }
               comment   = 'Better description for hello world\n'
               url       = 'https://dev.azure.com/fabrikam/_apis/git/repositories/278d5cd2-584d-4b63-824a-2ba458937249/commits/23d0bc5b128a10056dc68afece360d8a0fabb014'
            }
            name          = 'npaulk/feature'
            aheadCount    = 0
            behindCount   = 0
            isBaseVersion = $true
         }
      )
   }

   Describe "Git VSTS" {
      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable
   
      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter {
         $Uri -like "*_apis/projects*"
      }

      . "$PSScriptRoot\mocks\mockProjectNameDynamicParam.ps1"

      Context 'Get-VSTeamGitStat' {
         Mock Invoke-RestMethod { return $multipleResults } -Verifiable -ParameterFilter {
            $Uri -like "*/Test/*" -and
            $Uri -like "*repositories/00000000-0000-0000-0000-000000000000/stats/branches*"
         }

         Get-VSTeamGitStat -ProjectName Test -RepositoryId 00000000-0000-0000-0000-000000000000

         It 'Should return multiple results' {
            Assert-VerifiableMock
         }
      }

      Context 'Get-VSTeamGitStat by name' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable -ParameterFilter {
            $Uri -like "*/Test/*" -and
            $Uri -like "*repositories/00000000-0000-0000-0000-000000000000/stats/branches*" -and
            $Uri -like "*name=develop*"
         }

         Get-VSTeamGitStat -ProjectName Test -RepositoryId 00000000-0000-0000-0000-000000000000 -BranchName develop

         It 'Should return multiple results' {
            Assert-VerifiableMock
         }
      }

      Context 'Get-VSTeamGitStat by tag' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable -ParameterFilter {
            $Uri -like "*/Test/*" -and
            $Uri -like "*repositories/00000000-0000-0000-0000-000000000000/stats/branches*" -and
            $Uri -like "*baseVersionDescriptor.versionType=tag*" -and
            $Uri -like "*baseVersionDescriptor.version=test*"
         }

         Get-VSTeamGitStat -ProjectName Test -RepositoryId 00000000-0000-0000-0000-000000000000 -BranchName "develop" -VersionType "tag" -Version "test"

         It 'Should return multiple results' {
            Assert-VerifiableMock
         }
      }

      Context 'Get-VSTeamGitStat by tag with options' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable -ParameterFilter {
            $Uri -like "*/Test/*" -and
            $Uri -like "*repositories/00000000-0000-0000-0000-000000000000/stats/branches*" -and
            $Uri -like "*baseVersionDescriptor.versionType=tag*" -and
            $Uri -like "*baseVersionDescriptor.version=test*" -and
            $Uri -like "*baseVersionDescriptor.versionOptions=previousChange*"
         }

         Get-VSTeamGitStat -ProjectName Test -RepositoryId 00000000-0000-0000-0000-000000000000 -BranchName "develop" -VersionType "tag" -Version "test" -VersionOptions previousChange

         It 'Should return multiple results' {
            Assert-VerifiableMock
         }
      }

      Context 'Get-VSTeamGitStat by commit throws' {
         Mock Invoke-RestMethod { return $singleResult }

         It 'Should throw because of invalid parameters' {
            { Get-VSTeamGitStat -ProjectName Test -RepositoryId 00000000-0000-0000-0000-000000000000 -VersionType commit -Version '' } | Should Throw
         }
      }

      Context 'Get-VSTeamGitStat by id throws' {
         Mock Invoke-RestMethod { throw [System.Net.WebException] "Test Exception." }

         It 'Should return a single repo by id' {
            { Get-VSTeamGitStat -ProjectName Test -RepositoryId 00000000-0000-0000-0000-000000000000 } | Should Throw
         }
      }
   }
}