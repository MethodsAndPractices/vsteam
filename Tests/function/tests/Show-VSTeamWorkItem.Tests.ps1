Set-StrictMode -Version Latest

Describe 'VSTeamWorkItem' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      . "$baseFolder/Source/Private/applyTypes.ps1"

      Mock _getInstance { return 'https://dev.azure.com/test' }

      Mock Show-Browser
   }

   Context 'Show-VSTeamWorkItem' {
      it 'should return url for mine' {
         Show-VSTeamWorkItem -projectName project -Id 15

         Should -Invoke Show-Browser -Exactly -Scope It -Times 1 -ParameterFilter { $url -eq 'https://dev.azure.com/test/project/_workitems/edit/15' }
      }
   }
}