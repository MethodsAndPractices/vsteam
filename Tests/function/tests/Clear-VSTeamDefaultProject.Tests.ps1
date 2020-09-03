Set-StrictMode -Version Latest

Describe 'VSTeamDefaultProject' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      . "$baseFolder/Source/Classes/VSTeamLeaf.ps1"
      . "$baseFolder/Source/Classes/VSTeamDirectory.ps1"
      . "$baseFolder/Source/Private/applyTypes.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamQueue.ps1"
      . "$baseFolder/Source/Public/Remove-VSTeamAccount.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamBuildDefinition.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamProcess.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamProject.ps1"

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