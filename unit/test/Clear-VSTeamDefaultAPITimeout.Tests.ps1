Set-StrictMode -Version Latest

Describe 'VSTeamDefaultAPITimeout' -Tag 'APITimeout' {
   BeforeAll {
      Import-Module SHiPS

      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"
   }

   Context 'Clear-VSTeamDefaultAPITimeout on Non Windows' {
      BeforeAll {
         Mock _isOnWindows { return $false }
      }

      AfterAll {
         $Global:PSDefaultParameterValues.Remove("*-vsteam*:vsteamApiTimeout")
      }

      It 'should clear default timeout' {
         $Global:PSDefaultParameterValues['*-vsteam*:vsteamApiTimeout'] = 10

         Clear-VSTeamDefaultAPITimeout

         $Global:PSDefaultParameterValues['*-vsteam*:vsteamApiTimeout'] | Should -BeNullOrEmpty
      }
   }

   Context 'Clear-VSTeamDefaultAPITimeout as Non-Admin on Windows' {
      BeforeAll {
         Mock _isOnWindows { return $true }
         Mock _testAdministrator { return $false }
      }

      AfterAll {
         $Global:PSDefaultParameterValues.Remove("*-vsteam*:vsteamApiTimeout")
      }

      It 'should clear default timeout' {
         $Global:PSDefaultParameterValues['*-vsteam*:vsteamApiTimeout'] = 11

         Clear-VSTeamDefaultAPITimeout

         $Global:PSDefaultParameterValues['*-vsteam*:vsteamApiTimeout'] | Should -BeNullOrEmpty
      }
   }

   Context 'Clear-VSTeamDefaultAPITimeout as Admin on Windows' {
      BeforeAll {
         Mock _isOnWindows { return $true }
         Mock _testAdministrator { return $true }
      }

      AfterAll {
         $Global:PSDefaultParameterValues.Remove("*-vsteam*:vsteamApiTimeout")
      }

      It 'should clear default timeout' {
         $Global:PSDefaultParameterValues['*-vsteam*:vsteamApiTimeout'] = 12

         Clear-VSTeamDefaultAPITimeout

         $Global:PSDefaultParameterValues['*-vsteam*:vsteamApiTimeout'] | Should -BeNullOrEmpty
      }
   }
}