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

   Context 'Show-VSTeamRelease' {
      ## Arrange
      Mock Show-Browser { }

      it 'by Id should show release' {
         ## Act
         Show-VSTeamRelease -projectName project -Id 15

         ## Assert
         Assert-MockCalled Show-Browser -Exactly -Scope It -Times 1 -ParameterFilter {
            $url -eq 'https://dev.azure.com/test/project/_release?releaseId=15'
         }
      }

      ## Act / Assert
      it 'with invalid Id should throw' {
         { Show-VSTeamRelease -projectName project -Id 0 } | Should throw
      }
   }
}