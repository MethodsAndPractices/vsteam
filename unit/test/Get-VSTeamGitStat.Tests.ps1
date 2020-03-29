Set-StrictMode -Version Latest

#region include
Import-Module SHiPS

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamLeaf.ps1"
. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamFeed.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Private/applyTypes.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe "TeamGitStat" {
   ## Arrange
   . "$PSScriptRoot\mocks\mockProjectNameDynamicParam.ps1"

   $singleResult = Get-Content "$PSScriptRoot\sampleFiles\gitStatSingleResult.json" -Raw | ConvertFrom-Json

   # Set the account to use for testing. A normal user would do this
   # using the Set-VSTeamAccount function.
   Mock _getInstance { return 'https://dev.azure.com/test' }

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