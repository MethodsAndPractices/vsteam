Set-StrictMode -Version Latest

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Private/applyTypes.ps1"
. "$here/../../Source/Public/$sut"

Describe 'Get-VSTeamResourceArea' {
   Context 'Get-VSTeamResourceArea' {
      Mock _callAPI { return @{
            value = @{ }
         }
      }

      $actual = Get-VSTeamResourceArea

      It 'Should return resources' {
         $actual | Should Not Be $null
      }
   }
}