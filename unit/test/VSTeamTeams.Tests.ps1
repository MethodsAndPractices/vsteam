Set-StrictMode -Version Latest

Describe "VSTeamTeams" {
   BeforeAll {
      Import-Module SHiPS

      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamLeaf.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamDirectory.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamTeam.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeam.ps1"
      . "$PSScriptRoot/../../Source/Classes/$sut"
   }

   Context "Constructor" {
      BeforeAll {
         Mock Get-VSTeam { return [VSTeamTeam]::new(@{
                  name        = ''
                  ProjectName = ''
                  description = ''
                  id          = 1
               }, 'TestProject')
         }

         $teams = [VSTeamTeams]::new('Teams', 'TestProject')
         $team = $teams.GetChildItem()[0]
      }

      It 'Should create Teams' {
         $teams | Should -Not -Be $null
      }

      It 'Should return team' {
         $team | Should -Not -Be $null
      }
   }
}