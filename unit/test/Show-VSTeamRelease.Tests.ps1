Set-StrictMode -Version Latest

Describe 'VSTeamRelease' {
   BeforeAll {
      Import-Module SHiPS
      
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")
      
      . "$PSScriptRoot/../../Source/Classes/VSTeamLeaf.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamFeed.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamBuild.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamReleaseDefinition.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"
      
      ## Arrange
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unittest' } -ParameterFilter { $Service -eq 'Release' }

      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter { $Uri -like "*_apis/projects*" }

      Mock Show-Browser
   }

   Context 'Show-VSTeamRelease' {
      it 'by Id should show release' {
         ## Act
         Show-VSTeamRelease -projectName project -Id 15

         ## Assert
         Should -Invoke Show-Browser -Exactly -Scope It -Times 1 -ParameterFilter {
            $url -eq 'https://dev.azure.com/test/project/_release?releaseId=15'
         }
      }

      ## Act / Assert
      it 'with invalid Id should throw' {
         { Show-VSTeamRelease -projectName project -Id 0 } | Should -Throw
      }
   }
}