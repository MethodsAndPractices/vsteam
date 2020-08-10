Set-StrictMode -Version Latest

Describe 'VSTeamRelease' {
   BeforeAll {
      Import-Module SHiPS
      Add-Type -Path "$PSScriptRoot/../../dist/bin/vsteam-lib.dll"

      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamLeaf.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamFeed.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamBuild.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamReleaseDefinition.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamProject"
      . "$PSScriptRoot/../../Source/Public/$sut"

      # Invalidate the cache to force a call to Get-VSTeamProject so the
      # test can control what is returned.
      [vsteam_lib.ProjectCache]::Invalidate()
      Mock Get-VSTeamProject { return @(@{Name = "VSTeamRelease"}) }
      $Global:PSDefaultParameterValues.Remove("*-vsteam*:projectName")

      ## Arrange
      Mock _getApiVersion { return '1.0-unittest' } -ParameterFilter { $Service -eq 'Release' }

      Mock _getInstance { return 'https://dev.azure.com/test' }
   }

   Context 'Remove-VSTeamRelease' {
      BeforeAll {
         Mock Invoke-RestMethod
         Mock Invoke-RestMethod { throw 'error' } -ParameterFilter { $Uri -like "*101*" }
      }

      It 'by Id should remove release' {
         ## Act
         Remove-VSTeamRelease -ProjectName VSTeamRelease -Id 15 -Force

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Delete' -and
            $Uri -eq "https://vsrm.dev.azure.com/test/VSTeamRelease/_apis/release/releases/15?api-version=$(_getApiVersion Release)"
         }
      }

      It 'by Id should throw' {
         ## Act / Assert
         { Remove-VSTeamRelease -ProjectName VSTeamRelease -Id 101 -Force } | Should -Throw
      }
   }
}