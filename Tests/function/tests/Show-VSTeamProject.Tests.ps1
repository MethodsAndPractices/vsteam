Set-StrictMode -Version Latest

Describe 'VSTeamProject' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      ## Arrange
      Mock Show-Browser
      Mock _getInstance { return 'https://dev.azure.com/test' }
   }

   Context 'Show-VSTeamProject' {
      It 'by ID should call start' {
         ## Act
         Show-VSTeamProject -Id 123456

         ## Assert
         Should -Invoke Show-Browser -Exactly -Times 1 -Scope It -ParameterFilter {
            $Url -eq "https://dev.azure.com/test/123456"
         }
      }

      It 'by nameed ProjectName parameter should call open' {
         ## Act
         Show-VSTeamProject -ProjectName ShowProject

         ## Assert
         Should -Invoke Show-Browser -Exactly -Times 1 -Scope It -ParameterFilter {
            $Url -eq "https://dev.azure.com/test/ShowProject"
         }
      }

      It 'by postion projectName parameter should call open' {
         ## Act
         Show-VSTeamProject ShowProject

         ## Assert
         Should -Invoke Show-Browser -Exactly -Times 1 -Scope It -ParameterFilter {
            $Url -eq "https://dev.azure.com/test/ShowProject"
         }
      }
   }
}