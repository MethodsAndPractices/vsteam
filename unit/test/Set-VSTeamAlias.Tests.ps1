Set-StrictMode -Version Latest

#region include
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Public/$sut"
#endregion

Describe "VSTeamAlias" {
   Context "Set-VSTeamAlias" {
      It "Should not throw" {
         { Set-VSTeamAlias -Force | Should Not Throw }
      }
   }
}