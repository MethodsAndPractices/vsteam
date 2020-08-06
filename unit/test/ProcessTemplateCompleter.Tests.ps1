Set-StrictMode -Version Latest

Describe "ProcessTemplateCompleter" {
   BeforeAll {
      Add-Type -Path "$PSScriptRoot/../../dist/bin/vsteam-lib.dll"
      
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamProcess.ps1"
      . "$PSScriptRoot/../../Source/Classes/$sut"

      Mock Get-VSTeamProcess {
         return @(
            [PSCustomObject]@{ Name = "Agile" },
            [PSCustomObject]@{ Name = "CMMI" },
            [PSCustomObject]@{ Name = "Scrum" },
            [PSCustomObject]@{ Name = "Scrum With Space" },
            [PSCustomObject]@{ Name = "Basic" }
         )
      }
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