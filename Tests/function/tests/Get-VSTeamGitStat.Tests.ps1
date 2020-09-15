Set-StrictMode -Version Latest

Describe "TeamGitStat" {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock Invoke-RestMethod { Open-SampleFile 'gitStatSingleResult.json' }
   }

   Context 'Get-VSTeamGitStat' {
      It 'should return multiple results' {
         ## Act
         Get-VSTeamGitStat -ProjectName Test -RepositoryId 00000000-0000-0000-0000-000000000000

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*/Test/*" -and
            $Uri -like "*repositories/00000000-0000-0000-0000-000000000000/stats/branches*"
         }
      }

      It 'by branch name should return multiple results' {
         ## Act
         Get-VSTeamGitStat -ProjectName Test -RepositoryId 00000000-0000-0000-0000-000000000000 -BranchName develop

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*/Test/*" -and
            $Uri -like "*repositories/00000000-0000-0000-0000-000000000000/stats/branches*" -and
            $Uri -like "*name=develop*"
         }
      }

      It 'by tag should return multiple results' {
         ## Act
         Get-VSTeamGitStat -ProjectName Test -RepositoryId 00000000-0000-0000-0000-000000000000 -BranchName "develop" -VersionType "tag" -Version "test"

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*/Test/*" -and
            $Uri -like "*repositories/00000000-0000-0000-0000-000000000000/stats/branches*" -and
            $Uri -like "*baseVersionDescriptor.versionType=tag*" -and
            $Uri -like "*baseVersionDescriptor.version=test*"
         }
      }

      It 'by tag with options should return multiple results' {
         ## Act
         Get-VSTeamGitStat -ProjectName Test `
            -RepositoryId 00000000-0000-0000-0000-000000000000 `
            -BranchName "develop" `
            -VersionType "tag" `
            -Version "test" `
            -VersionOptions previousChange

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*/Test/*" -and
            $Uri -like "*repositories/00000000-0000-0000-0000-000000000000/stats/branches*" -and
            $Uri -like "*baseVersionDescriptor.versionType=tag*" -and
            $Uri -like "*baseVersionDescriptor.version=test*" -and
            $Uri -like "*baseVersionDescriptor.versionOptions=previousChange*"
         }
      }

      It 'by commit should throw because of invalid parameters' {
         ## Act / Assert
         { Get-VSTeamGitStat -ProjectName Test `
               -RepositoryId 00000000-0000-0000-0000-000000000000 `
               -VersionType commit `
               -Version '' } | Should -Throw
      }
   }
}