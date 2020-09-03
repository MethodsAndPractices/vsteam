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

   Context 'Set-VSTeamDefaultProject' {
      AfterAll {
         $Global:PSDefaultParameterValues.Remove("*-vsteam*:projectName")
      }

      It 'should set default project' {
         Set-VSTeamDefaultProject 'DefaultProject'

         $Global:PSDefaultParameterValues['*-vsteam*:projectName'] | Should -Be 'DefaultProject'
      }

      It 'should update default project' {
         $Global:PSDefaultParameterValues['*-vsteam*:projectName'] = 'DefaultProject'

         Set-VSTeamDefaultProject -Project 'NextProject'

         $Global:PSDefaultParameterValues['*-vsteam*:projectName'] | Should -Be 'NextProject'
      }
   }

   Context 'Set-VSTeamDefaultProject on Non Windows' {
      BeforeAll {
         Mock _isOnWindows { return $false } -Verifiable
      }

      AfterAll {
         $Global:PSDefaultParameterValues.Remove("*-vsteam*:projectName")
      }

      It 'should set default project' {
         Set-VSTeamDefaultProject 'MyProject'

         Should -InvokeVerifiable
         $Global:PSDefaultParameterValues['*-vsteam*:projectName'] | Should -Be 'MyProject'
      }
   }

   Context 'Set-VSTeamDefaultProject As Admin on Windows' {
      BeforeAll {
         Mock _isOnWindows { return $true }
         Mock _testAdministrator { return $true } -Verifiable
      }

      AfterAll {
         $Global:PSDefaultParameterValues.Remove("*-vsteam*:projectName")
      }

      It 'should set default project' {
         Set-VSTeamDefaultProject 'MyProject'

         Should -InvokeVerifiable
         $Global:PSDefaultParameterValues['*-vsteam*:projectName'] | Should -Be 'MyProject'
      }
   }
}