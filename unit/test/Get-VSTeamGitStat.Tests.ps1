Set-StrictMode -Version Latest

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

$singleResult = Get-Content "$PSScriptRoot\sampleFiles\gitStatSingleResult.json" -Raw | ConvertFrom-Json
$multipleResults = Get-Content "$PSScriptRoot\sampleFiles\gitStatMultipleResults.json" -Raw | ConvertFrom-Json

Describe "TeamGitStat" {
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