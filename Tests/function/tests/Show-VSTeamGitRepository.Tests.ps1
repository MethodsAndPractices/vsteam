Set-StrictMode -Version Latest

Describe "VSTeamGitRepository" {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

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