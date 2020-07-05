Describe "PS Drive Full exercise" {
   BeforeAll {
      . "$PSScriptRoot/testprep.ps1"

      Set-TestPrep
      Set-Project

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

      It 'Should list Builds, Releases and Teams' {
         Set-Location $newProjectName
         $projectChildren = Get-ChildItem
         Start-Sleep -Seconds 2
         $projectChildren | Should -Not -Be $null
      }

      # I have noticed this test hanging lately trying to acquire data from Teams
      # Might be a race condition from creation of project to calling this
      # Not sure if a delay might help.
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