Set-StrictMode -Version Latest

Describe "ProcessValidateAttribute" {
   BeforeAll {
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamProcess.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProcessCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProcessTemplateCompleter.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Classes/$sut"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamProcess.ps1"
   }

   Context "Existing Process" {
      BeforeAll {
         Mock Get-VSTeamProcess {
            return @(
               [PSCustomObject]@{ Name = "Test1"; url = 'http://bogus.none/100' },
               [PSCustomObject]@{ Name = "Test2"; url = 'http://bogus.none/101' }
            )
         }

         [VSTeamProcessCache]::Invalidate()
      }

      It "should not throw if name is in the list and should populate cache on first call" {
         $target = [ProcessValidateAttribute]::new()
         { $target.Validate("Test1", $null) } | Should -Not -Throw

         Should -Invoke -CommandName Get-VSTeamProcess -Times 1 -Exactly

         [VSTeamProcessCache]::processes.Count | should -BeGreaterThan 0

         [VSTeamProcessCache]::timestamp | should -BeGreaterOrEqual 0
      }

      It "should throw if name is not in list " {
         $target = [ProcessValidateAttribute]::new()

         { $target.Validate("Test", $null) } | Should -Throw
      }
   }

   Context "No Processes" {
      BeforeAll {
         Mock Get-VSTeamProcess {
            return @()
         }

         [VSTeamProcessCache]::Invalidate()
      }

      It "list is empty and should not throw" {
         $target = [ProcessValidateAttribute]::new()

         { $target.Validate("Test", $null) } | Should -Not -Throw
      }
   }
}