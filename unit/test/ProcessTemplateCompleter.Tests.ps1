Set-StrictMode -Version Latest

Describe "ProcessTemplateCompleter" {
   BeforeAll {
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamProcessCache.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Classes/$sut"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamProcess.ps1"
      

      Mock _hasProcessTemplateCacheExpired { return $true }
      Mock Get-VSTeamProcess {
         $processes =  @(
            [PSCustomObject]@{Name = "Scrum";            url='http://bogus.none/1'; ID = "6b724908-ef14-45cf-84f8-768b5384da45"},
            [PSCustomObject]@{Name = "Basic";            url='http://bogus.none/2'; ID = "b8a3a935-7e91-48b8-a94c-606d37c3e9f2"},
            [PSCustomObject]@{Name = "CMMI";             url='http://bogus.none/3'; ID = "27450541-8e31-4150-9947-dc59f998fc01"},
            [PSCustomObject]@{Name = "Agile";            url='http://bogus.none/4'; ID = "adcc42ab-9882-485e-a3ed-7678f01f66bc"},
            [PSCustomObject]@{Name = "Scrum With Space"; url='http://bogus.none/5'; ID = "12345678-0000-0000-0000-000000000000"}
         )
         if ($name) {return $processes.where({$_.name -like $name})}
         else       {return $processes}  
      }
   }

   Context "names with spaces" {
      BeforeAll {
         [VSTeamProcessCache]::invalidate()
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