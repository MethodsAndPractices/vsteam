Set-StrictMode -Version Latest

Describe "ProcessTemplateCompleter" {
   BeforeAll {
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamProcessCache.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Classes/$sut"

      Mock _hasProcessTemplateCacheExpired { return $true }
      Mock _getProcesses { return @("Scrum", "Basic", "CMMI", "Agile", "Scrum With Space") }
   }

   Context "names with spaces" {
      BeforeAll {
         $target = [ProcessTemplateCompleter]::new()

         $actual = $target.CompleteArgument("", "", "", $null, @{ })
      }

      It "should return process templates" {
         $actual.count | Should -Be 5
      }

      It "should quote the names with space" {
         $actual[4].CompletionText | Should -Be "'Scrum With Space'"
      }
   }
}