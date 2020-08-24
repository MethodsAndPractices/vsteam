Set-StrictMode -Version Latest

Describe 'VSTeamDefaultProject' {
   BeforeAll {
      Import-Module SHiPS
      Add-Type -Path "$PSScriptRoot/../../dist/bin/vsteam-lib.dll"

      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamLeaf.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamDirectory.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamTask.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamAttempt.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamEnvironment.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamRelease.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamQueue.ps1"
      . "$PSScriptRoot/../../Source/Public/Remove-VSTeamAccount.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamBuildDefinition.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamProcess.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamProject.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"

      Mock _getInstance { return 'https://dev.azure.com/test' }
   }

   Context 'Clear-VSTeamDefaultProject on Non Windows' {
      BeforeAll {
         Mock _isOnWindows { return $false }
      }

      AfterAll {
         $Global:PSDefaultParameterValues.Remove("*-vsteam*:projectName")
      }

      It 'should clear default project' {
         $Global:PSDefaultParameterValues['*-vsteam*:projectName'] = 'MyProject'

         Clear-VSTeamDefaultProject

         $Global:PSDefaultParameterValues['*-vsteam*:projectName'] | Should -BeNullOrEmpty
      }
   }

   Context 'Clear-VSTeamDefaultProject as Non-Admin on Windows' {
      BeforeAll {
         Mock _isOnWindows { return $true }
         Mock _testAdministrator { return $false }
      }

      AfterAll {
         $Global:PSDefaultParameterValues.Remove("*-vsteam*:projectName")
      }

      It 'should clear default project' {
         $Global:PSDefaultParameterValues['*-vsteam*:projectName'] = 'MyProject'

         Clear-VSTeamDefaultProject

         $Global:PSDefaultParameterValues['*-vsteam*:projectName'] | Should -BeNullOrEmpty
      }
   }

   Context 'Clear-VSTeamDefaultProject as Admin on Windows' {
      BeforeAll {
         Mock _isOnWindows { return $true }
         Mock _testAdministrator { return $true }
      }

      AfterAll {
         $Global:PSDefaultParameterValues.Remove("*-vsteam*:projectName")
      }

      It 'should clear default project' {
         $Global:PSDefaultParameterValues['*-vsteam*:projectName'] = 'MyProject'

         Clear-VSTeamDefaultProject

         $Global:PSDefaultParameterValues['*-vsteam*:projectName'] | Should -BeNullOrEmpty
      }
   }
}