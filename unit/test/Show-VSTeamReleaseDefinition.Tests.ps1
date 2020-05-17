Set-StrictMode -Version Latest

Describe 'VSTeamReleaseDefinition' {
   BeforeAll {
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamProject.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"

      ## Arrange
      Mock _getApiVersion { return '1.0-unittest' } -ParameterFilter { $Service -eq 'Release' }

      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter { $Uri -like "*_apis/projects*" }

      Mock _getInstance { return 'https://dev.azure.com/test' }

      Mock Show-Browser
   }

   Context 'Show-VSTeamReleaseDefinition' {
      it 'by Id should return release definitions' {
         Show-VSTeamReleaseDefinition -projectName project -Id 15

         Should -Invoke Show-Browser -Exactly -Scope It -Times 1 -ParameterFilter {
            $url -eq 'https://dev.azure.com/test/project/_release?definitionId=15'
         }
      }
   }
}