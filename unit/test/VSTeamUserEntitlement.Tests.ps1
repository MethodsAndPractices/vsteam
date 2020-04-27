Set-StrictMode -Version Latest

#region include
Import-Module SHiPS

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamLeaf.ps1"
. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Private/applyTypes.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Classes/$sut"
#endregion

Describe 'VSTeamUserEntitlement' -Tag 'Classes', 'Unit' {   
   Context 'ToString' {
      $obj = [PSCustomObject]@{
         displayName = 'Test User'
         id          = '1'
         uniqueName  = 'test@email.com'
      }

      $target = [VSTeamUserEntitlement]::new($obj, 'Test Project')

      It 'should return displayname' {
         $target.ToString() | Should Be 'Test User'
      }
   }
}