Set-StrictMode -Version Latest

Describe "VSTeamFeeds" {
   BeforeAll {
      Import-Module SHiPS
      
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")
      
      . "$PSScriptRoot/../../Source/Classes/VSTeamLeaf.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamDirectory.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamFeed.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamFeed.ps1"
      . "$PSScriptRoot/../../Source/Classes/$sut"
   }
      
   Context 'Constructor' {
      BeforeAll {
         $feedResults = Get-Content "$PSScriptRoot\sampleFiles\feeds.json" -Raw | ConvertFrom-Json
         $singleResult = $feedResults.value[0]

         Mock Get-VSTeamFeed {
            return [VSTeamFeed]::new($singleResult)
         }

         $target = [VSTeamFeeds]::new('Feeds')
         $feed = $target.GetChildItem()[0]
      }

      It 'Should create Feeds' {
         $target | Should -Not -Be $null
      }

      It 'Should return feed' {
         $feed | Should -Not -Be $null
      }
   }
}