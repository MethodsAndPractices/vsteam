Set-StrictMode -Version Latest

Describe "ProcessValidateAttribute" {
   BeforeAll {
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamProcessCache.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Classes/$sut"
   }

   Context "Existing Process" {
      BeforeAll {
         Mock _hasProcessTemplateCacheExpired { return $true }
         Mock _getProcesses { return @(@{Name='Test1';Id=''},@{Name='Test2';Id=''})}
      }

      It "it is not in list and should throw" {
         $target = [ProcessValidateAttribute]::new()

         { $target.Validate("Test", $null) } | Should -Throw
      }

      It "it is in list and should not throw" {
         $target = [ProcessValidateAttribute]::new()

         { $target.Validate("Test1", $null) } | Should -Not -Throw
      }
   }

   Context "No Processes" {
      BeforeAll {
         Mock _getProcesses { return @() }
         Mock _hasProcessTemplateCacheExpired { return $true }
      }

      It "list is empty and should not throw" {
         $target = [ProcessValidateAttribute]::new()

         { $target.Validate("Test", $null) } | Should -Not -Throw
      }
   }
}