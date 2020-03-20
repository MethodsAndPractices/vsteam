Set-StrictMode -Version Latest

#region include
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Private/applyTypes.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe 'VSTeamResourceArea' {
   Context 'Get-VSTeamResourceArea' {
      ## Arrange
      Mock _callAPI { return @{ value = @{ } } }

      It 'Should return resources' {
         ## Act
         $actual = Get-VSTeamResourceArea

         ## Assert
         $actual | Should Not Be $null
      }
   }
}