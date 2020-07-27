Describe "PS Drive Full exercise" {
   BeforeAll {
      . "$PSScriptRoot/testprep.ps1"

      Set-TestPrep
      $target = Set-Project

      $originalLocation = Get-Location
   }

   Context 'PS Drive full exercise' {
      BeforeAll {
         New-PSDrive -Name int -PSProvider SHiPS -Root 'VSTeam#VSTeamAccount'
         $actual = Set-Location int: -PassThru
      }

      It 'Should be able to mount drive' {
         $actual | Should -Not -Be $null
      }

      It 'Should list projects' {
         $projects = Get-ChildItem
         $projects | Should -Not -Be $null
      }

      It 'Should list Builds, Releases and Teams under project' {
         Set-Location $target.Name
         $projectChildren = Get-ChildItem
         Start-Sleep -Seconds 2
         $projectChildren | Should -Not -Be $null
      }
      
      # Have to do some more research
      # It 'Should list Teams' {
      #    Start-Sleep -Seconds 2
      #    Set-Location 'Teams'
      #    Start-Sleep -Seconds 2
      #    $teamsChildren = Get-ChildItem
      #    $teamsChildren | Should -Not -Be $null
      # }
   }

   AfterAll {
      # Put everything back
      Set-Location $originalLocation
   }
}