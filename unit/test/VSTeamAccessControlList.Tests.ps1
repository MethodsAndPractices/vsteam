Set-StrictMode -Version Latest

#region include
Import-Module SHiPS

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamLeaf.ps1"
. "$here/../../Source/Classes/VSTeamAccessControlEntry.ps1"
. "$here/../../Source/Classes/$sut"
#endregion

Describe "VSTeamAccessControlList" {
   $accessControlListResult = Get-Content "$PSScriptRoot\sampleFiles\accessControlListResult.json" -Raw | ConvertFrom-Json

   Context "Constructor" {

      $target = [VSTeamAccessControlList]::new($accessControlListResult.value[0])
      
      It "toString should return token" {
         $target.ToString() | Should be '1ba198c0-7a12-46ed-a96b-f4e77554c6d4'
      }
   }
}