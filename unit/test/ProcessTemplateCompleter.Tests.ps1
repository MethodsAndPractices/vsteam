Set-StrictMode -Version Latest

Describe "ProcessTemplateCompleter" {
   BeforeAll {
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamProcess.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProcessCache.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Classes/$sut"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamProcess.ps1"

      Mock Get-VSTeamProcess {
          return @(
            [PSCustomObject]@{Name = "Scrum";            url='http://bogus.none/1'},
            [PSCustomObject]@{Name = "Basic";            url='http://bogus.none/2'},
            [PSCustomObject]@{Name = "CMMI";             url='http://bogus.none/3'},
            [PSCustomObject]@{Name = "Agile";            url='http://bogus.none/4'},
            [PSCustomObject]@{Name = "Scrum With Space"; url='http://bogus.none/5'}
         ) 
      }
   }

   Context "names with spaces" {
      BeforeAll {
         [VSTeamProcessCache]::Invalidate()
         $target = [ProcessTemplateCompleter]::new()
      }
      It "should populate cache on the first call" {
         $null = $target.CompleteArgument("", "", "", $null, @{ })
         Should -Invoke -CommandName Get-VSTeamProcess  -Times 1 -Exactly 
         [VSTeamProcessCache]::urls.Count      | Should -BeGreaterThan 0
         [VSTeamProcessCache]::processes.Count | should -BeGreaterThan 0
         [VSTeamProcessCache]::timestamp       | should -BeGreaterOrEqual 0
      }

      It "should return process templates with quotes where needed" {
         $actual = $target.CompleteArgument("", "", "", $null, @{ })
         $actual[-1].ListItemText  | Should -BeGreaterThan $actual[0].ListItemText  #Expect items to be sorted
         $actual[4].CompletionText | Should -Be "'Scrum With Space'"                #Test data puts 'Scrum With Space' in slot #4
         $actual.count             | Should -Be 5                                   #Test data is 5 items 
      }

      It "should filter to the expected templates" {
         $actual = $target.CompleteArgument("", "", "SCR", $null, @{ })  
         $actual.count                                                    | Should -Be 2           #Should get 2 items form test data
         $actual | Where-Object -Property CompletionText -NotLike "*SCR*" | Should -BeNullOrEmpty  #and both should be like *scr*
      }
   }
}