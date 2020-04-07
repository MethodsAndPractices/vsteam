Set-StrictMode -Version Latest
$env:Testing=$true
# The InModuleScope command allows you to perform white-box unit testing on the
# internal \(non-exported\) code of a Script Module, ensuring the module is loaded.
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

   Describe "Git VSTS" {
      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable

      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter {
         $Uri -like "*_apis/projects*"
      }
   Mock Invoke-RestMethod { return $singleResult }

   Context 'Get-VSTeamGitStat' {
      It 'should return multiple results' {
         ## Act
         Get-VSTeamGitStat -ProjectName Test -RepositoryId 00000000-0000-0000-0000-000000000000

         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*/Test/*" -and
            $Uri -like "*repositories/00000000-0000-0000-0000-000000000000/stats/branches*"
         }
      }

      It 'by branch name should return multiple results' {
         ## Act
         Get-VSTeamGitStat -ProjectName Test -RepositoryId 00000000-0000-0000-0000-000000000000 -BranchName develop

         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*/Test/*" -and
            $Uri -like "*repositories/00000000-0000-0000-0000-000000000000/stats/branches*" -and
            $Uri -like "*name=develop*"
         }
      }

      It 'by tag should return multiple results' {
         ## Act
         Get-VSTeamGitStat -ProjectName Test -RepositoryId 00000000-0000-0000-0000-000000000000 -BranchName "develop" -VersionType "tag" -Version "test"

         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*/Test/*" -and
            $Uri -like "*repositories/00000000-0000-0000-0000-000000000000/stats/branches*" -and
            $Uri -like "*baseVersionDescriptor.versionType=tag*" -and
            $Uri -like "*baseVersionDescriptor.version=test*"
         }
      }

      It 'by tag with options should return multiple results' {
         ## Act
         Get-VSTeamGitStat -ProjectName Test -RepositoryId 00000000-0000-0000-0000-000000000000 -BranchName "develop" -VersionType "tag" -Version "test" -VersionOptions previousChange

         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*/Test/*" -and
            $Uri -like "*repositories/00000000-0000-0000-0000-000000000000/stats/branches*" -and
            $Uri -like "*baseVersionDescriptor.versionType=tag*" -and
            $Uri -like "*baseVersionDescriptor.version=test*" -and
            $Uri -like "*baseVersionDescriptor.versionOptions=previousChange*"
         }
      }

      It 'by commit should throw because of invalid parameters' {
         ## Act / Assert
         { Get-VSTeamGitStat -ProjectName Test -RepositoryId 00000000-0000-0000-0000-000000000000 -VersionType commit -Version '' } | Should Throw
      }
   }
   }
}