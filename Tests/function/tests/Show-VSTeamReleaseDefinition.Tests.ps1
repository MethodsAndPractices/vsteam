Set-StrictMode -Version Latest

Describe 'VSTeamReleaseDefinition' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      ## Arrange
      Mock _getApiVersion { return '1.0-unittest' } -ParameterFilter { $Service -eq 'Release' }

      Mock _getInstance { return 'https://dev.azure.com/test' }

      Mock Show-Browser
   }

   Context 'Show-VSTeamReleaseDefinition' {
      it 'by Id should return release definitions' {
         Show-VSTeamReleaseDefinition -projectName project -Id 15

         Should -Invoke Show-Browser -Exactly -Scope It -Times 1 -ParameterFilter {
            $url -eq 'https://dev.azure.com/test/project/_release?definitionId=15'
         }
      }
   }
}