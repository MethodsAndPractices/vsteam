Set-StrictMode -Version Latest

Describe 'VSTeamWorkItem' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      
      ## Arrange
      Mock Show-Browser
      Mock _getInstance { return 'https://dev.azure.com/test' }
   }

   Context 'Show-VSTeamWorkItem' {
      it 'should return url for mine' {
         ## Act
         Show-VSTeamWorkItem -projectName project -Id 15

         ## Assert
         Should -Invoke Show-Browser -Exactly -Scope It -Times 1 -ParameterFilter { 
            $url -eq 'https://dev.azure.com/test/project/_workitems/edit/15' 
         }
      }
   }
}