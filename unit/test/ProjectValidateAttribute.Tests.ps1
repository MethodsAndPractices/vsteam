Set-StrictMode -Version Latest

Describe "ProjectValidateAttribute" {
   BeforeAll {
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Classes/$sut"
   }

   Context "Existing Project" {
      BeforeAll {
         Mock _hasProjectCacheExpired { return $true }
         Mock _getProjects { return @("Test1", "Test2") }
      }

      It "it is not in list and should throw" {
         $target = [ProjectValidateAttribute]::new()

         { $target.Validate("Test", $null) } | Should -Throw
      }

      It "it is in list and should not throw" {
         $target = [ProjectValidateAttribute]::new()

         { $target.Validate("Test1", $null) } | Should -Not -Throw
      }
   }

   Context "No Projects" {
      BeforeAll {
         Mock _getProjects { return @() }
         Mock _hasProjectCacheExpired { return $true }
      }

      It "list is empty and should not throw" {
         $target = [ProjectValidateAttribute]::new()

         { $target.Validate("Test", $null) } | Should -Not -Throw
      }
   }
}