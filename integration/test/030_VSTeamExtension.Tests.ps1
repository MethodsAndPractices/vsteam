Describe "VSTeamExtension" {
   BeforeAll {
      . "$PSScriptRoot/testprep.ps1"

      Set-TestPrep

      Set-Project
   }

   Context 'Add-VSTeamExtension' {
      It 'Should add SonarQube Extension' {
         $actual = Add-VSTeamExtension -PublisherId 'sonarsource' -ExtensionId 'sonarqube'

         $($actual | Where-Object name -eq SonarQube) | Should -Not -Be $null
      }

      It 'Should remove SonarQube Extension' {
         $actual = Remove-VSTeamExtension -PublisherId sonarsource -ExtensionId sonarqube -Force

         $($actual | Where-Object name -eq SonarQube) | Should -Be $null
      }
   }
}