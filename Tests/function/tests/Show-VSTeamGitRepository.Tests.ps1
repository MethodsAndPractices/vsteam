Set-StrictMode -Version Latest

Describe "VSTeamGitRepository" {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
   
      . "$baseFolder/Source/Classes/VSTeamLeaf.ps1"
      . "$baseFolder/Source/Classes/VSTeamDirectory.ps1"
      . "$baseFolder/Source/Classes/VSTeamTask.ps1"
      . "$baseFolder/Source/Classes/VSTeamAttempt.ps1"
      . "$baseFolder/Source/Classes/VSTeamEnvironment.ps1"
      . "$baseFolder/Source/Private/common.ps1"
      . "$baseFolder/Source/Private/applyTypes.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamQueue.ps1"
      . "$baseFolder/Source/Public/Remove-VSTeamAccount.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamBuildDefinition.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamProject.ps1"
      . "$baseFolder/Source/Private/applyTypes.ps1"

      Mock Show-Browser
      Mock _getInstance { return 'https://dev.azure.com/test' }
   }

   Context 'Show-VSTeamGitRepository' {
      it 'by project should return url for mine' {
         Show-VSTeamGitRepository -projectName project

         Should -Invoke Show-Browser -Exactly -Times 1 -Scope It -ParameterFilter {
            $url -eq 'https://dev.azure.com/test/_git/project'
         }
      }

      it 'by remote url should return url for mine' {
         Show-VSTeamGitRepository -RemoteUrl 'https://dev.azure.com/test/_git/project'

         Should -Invoke Show-Browser -Exactly -Times 1 -Scope It -ParameterFilter {
            $url -eq 'https://dev.azure.com/test/_git/project'
         }
      }
   }
}