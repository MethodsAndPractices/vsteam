Describe "VSTeamExtension" {
   BeforeAll {
      Set-VSTeamAPIVersion -Target $env:API_VERSION

      $pat = $env:PAT
      $acct = $env:ACCT
      $email = $env:EMAIL
      $api = $env:API_VERSION

      $projectDescription = 'Project for VSTeam integration testing.'
      $newProjectName = 'TeamModuleIntegration' + [guid]::NewGuid().toString().substring(0, 5)

      $originalLocation = Get-Location

      Set-VSTeamAccount -Account $acct -PersonalAccessToken $pat -Version $api

      $existingProject = $(Get-VSTeamProject | Where-Object Description -eq $projectDescription)

      if ($existingProject) {
         $newProjectName = $existingProject.Name
      }
      else {
         Add-VSTeamProject -Name $newProjectName -Description $projectDescription | Should -Not -Be $null
      }
   }

   Context 'Add-VSTeamExtension' {
      It 'Should add SonarQube Extension' {
         $actual = Add-VSTeamExtension -PublisherId sonarsource -ExtensionId sonarqube

         $($actual | Where-Object name -eq SonarQube) | Should -Not -Be $null
      }

      It 'Add-VSTeamSonarQubeEndpoint Should add service endpoint' {
         { Add-VSTeamSonarQubeEndpoint -ProjectName $newProjectName -EndpointName 'TestSonarQube' `
               -SonarQubeURl 'http://sonarqube.somewhereIn.cloudapp.azure.com:9000' -PersonalAccessToken 'Faketoken' } | Should -Not -Throw
      }

      It 'Should remove SonarQube Extension' {
         $actual = Remove-VSTeamExtension -PublisherId sonarsource -ExtensionId sonarqube -Force

         $($actual | Where-Object name -eq SonarQube) | Should -Be $null
      }
   }
}