Set-StrictMode -Version Latest

Describe 'VSTeamReleaseDefinition' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      ## Arrange
      Mock Show-Browser
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unittest' } -ParameterFilter { 
         $Service -eq 'Release' 
      }
   }

   Context 'Show-VSTeamReleaseDefinition' {
      it 'by Id should return release definitions' {
         ## Act
         Show-VSTeamReleaseDefinition -projectName project -Id 15

         ## Assert
         Should -Invoke Show-Browser -Exactly -Scope It -Times 1 -ParameterFilter {
            $url -eq 'https://dev.azure.com/test/project/_release?definitionId=15'
         }
      }
   }
}