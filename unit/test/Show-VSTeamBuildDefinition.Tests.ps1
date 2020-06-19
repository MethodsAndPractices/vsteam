Set-StrictMode -Version Latest

Describe 'VSTeamBuildDefinition' {
   BeforeAll {
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")
   
      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"
   
      Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable

      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter {
         $Uri -like "*_apis/projects*"
      }
      
      Mock Show-Browser
   }

   Context 'Show-VSTeamBuildDefinition' {
      it 'by ID should return url for mine' {
         Show-VSTeamBuildDefinition -projectName project -Id 15

         Should -Invoke Show-Browser -Exactly -Scope It -Times 1 -ParameterFilter {
            $url -eq 'https://dev.azure.com/test/project/_build/index?definitionId=15'
         }
      }

      it 'by type should return url for mine' {
         Show-VSTeamBuildDefinition -projectName project -Type Mine

         Should -Invoke Show-Browser -Exactly -Scope It -Times 1 -ParameterFilter {
            $url -eq 'https://dev.azure.com/test/project/_build/index?_a=mine&path=%5c'
         }
      }

      it 'type XAML should return url for XAML' {
         Show-VSTeamBuildDefinition -projectName project -Type XAML

         Should -Invoke Show-Browser -Exactly -Scope It -Times 1 -ParameterFilter {
            $url -eq 'https://dev.azure.com/test/project/_build/xaml&path=%5c'
         }
      }

      it 'type queued should return url for Queued' {
         Show-VSTeamBuildDefinition -projectName project -Type Queued

         Should -Invoke Show-Browser -Exactly -Scope It -Times 1 -ParameterFilter {
            $url -eq 'https://dev.azure.com/test/project/_build/index?_a=queued&path=%5c'
         }
      }

      it 'with path should return url for mine' {
         Show-VSTeamBuildDefinition -projectName project -path '\test'

         Should -Invoke Show-Browser -Exactly -Scope It -Times 1 -ParameterFilter {
            $url -like 'https://dev.azure.com/test/project/_Build/index?_a=allDefinitions&path=%5Ctest'
         }
      }

      it 'Mine with path missing \ should return url for mine with \ added' {
         Show-VSTeamBuildDefinition -projectName project -path 'test'

         Should -Invoke Show-Browser -Exactly -Scope It -Times 1 -ParameterFilter {
            $url -like 'https://dev.azure.com/test/project/_Build/index?_a=allDefinitions&path=%5Ctest'
         }
      }
   }
}