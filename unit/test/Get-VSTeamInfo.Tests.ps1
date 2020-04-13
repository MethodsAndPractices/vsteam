Set-StrictMode -Version Latest

#region include
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe 'VSTeamInfo' {
   ## Arrange
   Context 'Get-VSTeamInfo' {
      AfterAll {
         $Global:PSDefaultParameterValues.Remove("*:projectName")
      }

      It 'should return account and default project' {
         [VSTeamVersions]::Account = "mydemos"
         $Global:PSDefaultParameterValues['*:projectName'] = 'TestProject'

         ## Act
         $info = Get-VSTeamInfo

         ## Assert
         $info.Account | Should Be "mydemos"
         $info.DefaultProject | Should Be "TestProject"
      }
   }
}