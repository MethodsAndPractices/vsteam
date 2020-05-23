Describe "VSTeamProject" {
   BeforeAll {
      Set-VSTeamAPIVersion -Target $env:API_VERSION

      $pat = $env:PAT
      $acct = $env:ACCT
      $email = $env:EMAIL
      $api = $env:API_VERSION

      $projectDescription = 'Project for VSTeam integration testing.'
      $newProjectName = 'TeamModuleIntegration-' + [guid]::NewGuid().toString().substring(0, 5)

      Set-VSTeamAccount -Account $acct -PersonalAccessToken $pat -Version $api

      $existingProject = $(Get-VSTeamProject | Where-Object Description -eq $projectDescription)

      if ($existingProject) {
         $newProjectName = $existingProject.Name
      }
      else {
         Add-VSTeamProject -Name $newProjectName -Description $projectDescription | Should -Not -Be $null
      }
   }

   Context 'Remove-VSTeamProject' {
      It 'should remove Project' {
         Set-VSTeamAPIVersion $env:API_VERSION

         # I have noticed that if the delete happens too soon you will get a
         # 400 response and told to try again later. So this test needs to be
         # retried. We need to wait a minute after the rename before we try
         # and delete
         Start-Sleep -Seconds 15

         Get-VSTeamProject -Name $newProjectName | Remove-VSTeamProject -Force

         Start-Sleep -Seconds 15

         $(Get-VSTeamProject | Where-Object name -eq $newProjectName) | Should -Be $null
      }
   }
}