Set-StrictMode -Version Latest

#region include
Import-Module SHiPS

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamLeaf.ps1"
. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamFeed.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Private/applyTypes.ps1"
. "$here/../../Source/Public/Get-VSTeamBuild.ps1"
. "$here/../../Source/Public/Get-VSTeamReleaseDefinition.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe 'VSTeamRelease' {
   ## Arrange
   [VSTeamVersions]::Release = '1.0-unittest'
   
   . "$PSScriptRoot\mocks\mockProjectNameDynamicParamNoPSet.ps1"

   Mock _getInstance { return 'https://dev.azure.com/test' }
   
   # Mock the call to Get-Projects by the dynamic parameter for ProjectName
   Mock Invoke-RestMethod { return @() } -ParameterFilter { $Uri -like "*_apis/projects*" }

   Context 'Remove-VSTeamRelease' {
      Mock Invoke-RestMethod
      Mock Invoke-RestMethod { throw 'error' } -ParameterFilter { $Uri -like "*101*" }

      It 'by Id should remove release' {
         ## Act
         Remove-VSTeamRelease -ProjectName project -Id 15 -Force

         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Delete' -and
            $Uri -eq "https://vsrm.dev.azure.com/test/project/_apis/release/releases/15?api-version=$([VSTeamVersions]::Release)"
         }
      }

      It 'by Id should throw' {
         ## Act / Assert
         { Remove-VSTeamRelease -ProjectName project -Id 101 -Force } | Should Throw
      }
   }
}