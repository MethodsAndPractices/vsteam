Set-StrictMode -Version Latest

Import-Module SHiPS

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamLeaf.ps1"
. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamFeed.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/$sut"

$results = Get-Content "$PSScriptRoot\sampleFiles\feeds.json" -Raw | ConvertFrom-Json

Describe 'Feeds' {
   Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable
      
   # Mock the call to Get-Projects by the dynamic parameter for ProjectName
   Mock Invoke-RestMethod { return @() } -ParameterFilter {
      $Uri -like "*_apis/projects*"
   }

   Context 'Get-VSTeamFeed with no parameters' {
      [VSTeamVersions]::Packaging = '4.0'
      Mock _supportsFeeds { return $true }
      Mock Invoke-RestMethod { return $results }

      it 'Should return all the Feeds' {
         Get-VSTeamFeed

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://feeds.dev.azure.com/test/_apis/packaging/feeds?api-version=$([VSTeamVersions]::packaging)"
         }
      }
   }

   Context 'Get-VSTeamFeed with id parameter' {
      [VSTeamVersions]::Packaging = '4.0'
      Mock _supportsFeeds { return $true }
      Mock Invoke-RestMethod { return $results.value[0] }

      it 'Should return one feed' {
         Get-VSTeamFeed -id '00000000-0000-0000-0000-000000000000'

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://feeds.dev.azure.com/test/_apis/packaging/feeds/00000000-0000-0000-0000-000000000000?api-version=$([VSTeamVersions]::packaging)"
         }
      }
   }

   Context 'Get-VSTeamFeed throws' {
      [VSTeamVersions]::Packaging = ''
      Mock _supportsFeeds { return $false }

      it 'Should throw' {
         { Get-VSTeamFeed } | Should throw
      }
   }
}