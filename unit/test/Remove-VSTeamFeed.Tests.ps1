Set-StrictMode -Version Latest

Import-Module SHiPS

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/$sut"

Describe 'Feeds' {
   Mock _supportsFeeds { return $true }
   Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable
      
   # Mock the call to Get-Projects by the dynamic parameter for ProjectName
   Mock Invoke-RestMethod { return @() } -ParameterFilter {
      $Uri -like "*_apis/projects*"
   }

   Context 'Remove-VSTeamFeed' {
      [VSTeamVersions]::Packaging = '4.0'
      Mock Invoke-RestMethod

      It 'should delete feed' {
         Remove-VSTeamFeed -id '00000000-0000-0000-0000-000000000000' -Force

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Delete' -and
            $Uri -eq "https://feeds.dev.azure.com/test/_apis/packaging/feeds/00000000-0000-0000-0000-000000000000?api-version=$([VSTeamVersions]::packaging)"
         }
      }
   }
}