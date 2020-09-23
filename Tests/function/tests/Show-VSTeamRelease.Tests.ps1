Set-StrictMode -Version Latest

Describe 'VSTeamRelease' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      
      ## Arrange
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unittest' } -ParameterFilter { $Service -eq 'Release' }

      Mock Show-Browser
   }

   Context 'Show-VSTeamRelease' {
      it 'by Id should show release' {
         ## Act
         Show-VSTeamRelease -projectName project -Id 15

         ## Assert
         Should -Invoke Show-Browser -Exactly -Scope It -Times 1 -ParameterFilter {
            $url -eq 'https://dev.azure.com/test/project/_release?releaseId=15'
         }
      }

      it 'with invalid Id should throw' {
         ## Act / Assert
         { Show-VSTeamRelease -projectName project -Id 0 } | Should -Throw
      }
   }
}