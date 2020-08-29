Set-StrictMode -Version Latest

Describe 'VSTeamBuild' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable

      Mock Show-Browser
   }

   Context 'Show-VSTeamBuild' {
      it 'By ID should return url for mine' {
         Show-VSTeamBuild -projectName project -Id 15

         Should -Invoke Show-Browser -Exactly -Scope It -Times 1 -ParameterFilter { $url -eq 'https://dev.azure.com/test/project/_build/index?buildId=15' }
      }
   }
}