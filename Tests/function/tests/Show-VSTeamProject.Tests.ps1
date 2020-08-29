Set-StrictMode -Version Latest

Describe 'VSTeamProject' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      Mock _getInstance { return 'https://dev.azure.com/test' }

      Mock Show-Browser
   }

   Context 'Show-VSTeamProject' {
      It 'by ID should call start' {
         Show-VSTeamProject -Id 123456

         Should -Invoke Show-Browser -Exactly -Times 1 -Scope It -ParameterFilter {
            $Url -eq "https://dev.azure.com/test/123456"
         }
      }

      It 'by nameed ProjectName parameter should call open' {
         Show-VSTeamProject -ProjectName ShowProject

         Should -Invoke Show-Browser -Exactly -Times 1 -Scope It -ParameterFilter {
            $Url -eq "https://dev.azure.com/test/ShowProject"
         }
      }

      It 'by postion projectName parameter should call open' {
         Show-VSTeamProject ShowProject

         Should -Invoke Show-Browser -Exactly -Times 1 -Scope It -ParameterFilter {
            $Url -eq "https://dev.azure.com/test/ShowProject"
         }
      }
   }
}