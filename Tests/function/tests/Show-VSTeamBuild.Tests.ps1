Set-StrictMode -Version Latest

Describe 'VSTeamBuild' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      ## Arrange
      Mock Show-Browser
      Mock _getInstance { return 'https://dev.azure.com/test' }
   }

   Context 'Show-VSTeamBuild' {
      it 'By ID should return url for mine' {
         ## Act
         Show-VSTeamBuild -projectName project -Id 15

         ## Assert
         Should -Invoke Show-Browser -Exactly -Scope It -Times 1 -ParameterFilter { 
            $url -eq 'https://dev.azure.com/test/project/_build/index?buildId=15' 
         }
      }
   }
}