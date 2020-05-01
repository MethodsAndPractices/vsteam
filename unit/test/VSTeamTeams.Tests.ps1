Set-StrictMode -Version Latest

#region include
Import-Module SHiPS

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamLeaf.ps1"
. "$here/../../Source/Classes/VSTeamDirectory.ps1"
. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Classes/VSTeamTeam.ps1"
. "$here/../../Source/Private/applyTypes.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/Get-VSTeam.ps1"
. "$here/../../Source/Classes/$sut"
#endregion

Describe "VSTeamTeams" {
   Context "Constructor" {
      Mock Get-VSTeam { return [VSTeamTeam]::new(@{
               name        = ''
               ProjectName = ''
               description = ''
               id          = 1
            }, 'TestProject') }

      $teams = [VSTeamTeams]::new('Teams', 'TestProject')

      It 'Should create Teams' {
         $teams | Should Not Be $null
      }

      $team = $teams.GetChildItem()[0]

      It 'Should return team' {
         $team | Should Not Be $null
      }
   }
}