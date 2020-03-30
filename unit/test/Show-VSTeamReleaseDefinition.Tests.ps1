Set-StrictMode -Version Latest

#region include
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/Get-VSTeamProject.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe 'VSTeamReleaseDefinition' {
   ## Arrange
   [VSTeamVersions]::Release = '1.0-unittest'
   
   . "$PSScriptRoot\mocks\mockProjectNameDynamicParamNoPSet.ps1"

   # Mock the call to Get-Projects by the dynamic parameter for ProjectName
   Mock Invoke-RestMethod { return @() } -ParameterFilter { $Uri -like "*_apis/projects*" }

   Context 'Show-VSTeamReleaseDefinition' {
      Mock Show-Browser { }
      Mock _getInstance { return 'https://dev.azure.com/test' }
      
      it 'by Id should return release definitions' {
         Show-VSTeamReleaseDefinition -projectName project -Id 15

         Assert-MockCalled Show-Browser -Exactly -Scope It -Times 1 -ParameterFilter {
            $url -eq 'https://dev.azure.com/test/project/_release?definitionId=15'
         }
      }
   }
}