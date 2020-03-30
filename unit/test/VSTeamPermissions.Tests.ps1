Set-StrictMode -Version Latest

#region include
Import-Module SHiPS

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamLeaf.ps1"
. "$here/../../Source/Classes/VSTeamDirectory.ps1"
. "$here/../../Source/Classes/VSTeamGroups.ps1"
. "$here/../../Source/Classes/VSTeamUsers.ps1"
. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Private/applyTypes.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/Get-VSTeamUser.ps1"
. "$here/../../Source/Public/Get-VSTeamGroup.ps1"
. "$here/../../Source/Classes/$sut"
#endregion

Describe "VSTeamPermissions" {
   Context "Constructor" {
      Mock Get-VSTeamUser { return [VSTeamGroup]::new(@{ }) }
      Mock Get-VSTeamGroup { return [VSTeamGroup]::new(@{ }) }

      $permissions = [VSTeamPermissions]::new('Permissions')

      It 'Should create Permissions' {
         $permissions | Should Not Be $null
         $permissions.GetChildItem().Count | Should Be 2
      }

      $groups = $permissions.GetChildItem()[0]
      $users = $permissions.GetChildItem()[1]

      It 'Should return groups' {
         $groups | Should Not Be $null
      }

      It 'Should return users' {
         $users | Should Not Be $null
      }
   }
}