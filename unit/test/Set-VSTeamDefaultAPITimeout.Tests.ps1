Set-StrictMode -Version Latest

Describe 'VSTeamDefaultAPITimeout' -Tag 'APITimeout' {
   BeforeAll {
      Import-Module SHiPS

      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"
   }

   Context 'Set-VSTeamDefaultAPITimeout' {
      AfterAll {
         $Global:PSDefaultParameterValues.Remove("*-vsteam*:vsteamApiTimeout")
      }

      It 'should set default timeout' {
         Set-VSTeamDefaultAPITimeout 12

         $Global:PSDefaultParameterValues['*-vsteam*:vsteamApiTimeout'] | Should -Be 12
      }

      It 'should update default timeout' {
         $Global:PSDefaultParameterValues['*-vsteam*:vsteamApiTimeout'] = 10

         Set-VSTeamDefaultAPITimeout -TimeoutSec 20

         $Global:PSDefaultParameterValues['*-vsteam*:vsteamApiTimeout'] | Should -Be 20
      }
   }

   Context 'Set-VSTeamDefaultAPITimeout on Non Windows' {
      BeforeAll {
         Mock _isOnWindows { return $false } -Verifiable
      }

      AfterAll {
         $Global:PSDefaultParameterValues.Remove("*-vsteam*:vsteamApiTimeout")
      }

      It 'should set default timeout' {
         Set-VSTeamDefaultAPITimeout 16

         Should -InvokeVerifiable
         $Global:PSDefaultParameterValues['*-vsteam*:vsteamApiTimeout'] | Should -Be 16
      }
   }

   Context 'Set-VSTeamDefaultAPITimeout As Admin on Windows' {
      BeforeAll {
         Mock _isOnWindows { return $true }
         Mock _testAdministrator { return $true } -Verifiable
      }

      AfterAll {
         $Global:PSDefaultParameterValues.Remove("*-vsteam*:vsteamApiTimeout")
      }

      It 'should set default timeout' {
         Set-VSTeamDefaultAPITimeout 13

         Should -InvokeVerifiable
         $Global:PSDefaultParameterValues['*-vsteam*:vsteamApiTimeout'] | Should -Be 13
      }
   }
}