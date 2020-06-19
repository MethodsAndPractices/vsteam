Set-StrictMode -Version Latest

Describe 'VSTeamProject' {
   BeforeAll {

      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"

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