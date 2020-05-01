Set-StrictMode -Version Latest

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/$sut"

Describe 'Show-VSTeam' {
   Context 'Show-VSTeam' {
      Mock _getInstance { return 'https://dev.azure.com/test' }
      
      Mock Show-Browser -Verifiable

      Show-VSTeam

      It 'Should open browser' {
         Assert-VerifiableMock
      }
   }
}