Describe "PS Drive Full exercise" {
   BeforeAll {
      Set-VSTeamAPIVersion -Target $env:API_VERSION

      $pat = $env:PAT
      $acct = $env:ACCT
      $email = $env:EMAIL
      $api = $env:API_VERSION

      $projectDescription = 'Project for VSTeam integration testing.'
      $newProjectName = 'TeamModuleIntegration-' + [guid]::NewGuid().toString().substring(0, 5)

      $originalLocation = Get-Location

      Set-VSTeamAccount -Account $acct -PersonalAccessToken $pat -Version $api -Drive int

      $existingProject = $(Get-VSTeamProject | Where-Object Description -eq $projectDescription)

      if($existingProject) {
         $newProjectName = $existingProject.Name
      } else {
         Add-VSTeamProject -Name $newProjectName -Description $projectDescription | Should -Not -Be $null
      }
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
         $projectChildren | Should -Not -Be $null
      }

      It 'Should list Teams' {
         Set-Location 'Teams'
         $teamsChildren = Get-ChildItem
         $teamsChildren | Should -Not -Be $null
      }
   }

   AfterAll {
      # Put everything back
      Set-Location $originalLocation
   }
}