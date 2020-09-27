Set-StrictMode -Version Latest

Describe 'VSTeamPackage' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      ## Arrange
      Mock Show-Browser
      Mock _getInstance { return 'https://dev.azure.com/test' }
   }

   Context 'Show-VSTeamPackage' {
      It 'by name should call show-browser' {
         ## Arrange
         $p = [vsteam_lib.Package]::new($(Open-SampleFile 'Get-VSTeamPackage.json' -Index 0),
            '00000000-0000-0000-0000-000000000001')

         ## Act
         Show-VSTeamPackage $p

         ## Assert
         Should -Invoke Show-Browser
      }
   }
}