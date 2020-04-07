Set-StrictMode -Version Latest

#region include
Import-Module SHiPS

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamLeaf.ps1"
. "$here/../../Source/Classes/VSTeamDirectory.ps1"
. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamFeed.ps1"
. "$here/../../Source/Private/applyTypes.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/Get-VSTeamFeed.ps1"
. "$here/../../Source/Classes/$sut"
#endregion

Describe "VSTeamFeeds" {
   Context 'Constructor' {
      $feedResults = Get-Content "$PSScriptRoot\sampleFiles\feeds.json" -Raw | ConvertFrom-Json
      $singleResult = $feedResults.value[0]

      Mock Get-VSTeamFeed {
         return [VSTeamFeed]::new($singleResult)
      }

      $target = [VSTeamFeeds]::new('Feeds')

      It 'Should create Feeds' {
         $target | Should Not Be $null
      }

      $feed = $target.GetChildItem()[0]

      It 'Should return feed' {
         $feed | Should Not Be $null
      }
   }
}