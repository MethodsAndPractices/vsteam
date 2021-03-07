Set-StrictMode -Version Latest

Describe 'VSTeamBuildDefinition' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
   
      ## Arrange
      Mock Show-Browser
      Mock _getInstance { return 'https://dev.azure.com/test' }      
   }

   Context 'Show-VSTeamBuildDefinition' {
      it 'by ID should return url for mine' {
         ## Act
         Show-VSTeamBuildDefinition -projectName project -Id 15

         ## Assert
         Should -Invoke Show-Browser -Exactly -Scope It -Times 1 -ParameterFilter {
            $url -eq 'https://dev.azure.com/test/project/_build/index?definitionId=15'
         }
      }

      it 'by type should return url for mine' {
         ## Act
         Show-VSTeamBuildDefinition -projectName project -Type Mine

         ## Assert
         Should -Invoke Show-Browser -Exactly -Scope It -Times 1 -ParameterFilter {
            $url -eq 'https://dev.azure.com/test/project/_build/index?_a=mine&path=%5c'
         }
      }

      it 'type XAML should return url for XAML' {
         ## Act
         Show-VSTeamBuildDefinition -projectName project -Type XAML

         ## Assert
         Should -Invoke Show-Browser -Exactly -Scope It -Times 1 -ParameterFilter {
            $url -eq 'https://dev.azure.com/test/project/_build/xaml&path=%5c'
         }
      }

      it 'type queued should return url for Queued' {
         ## Act
         Show-VSTeamBuildDefinition -projectName project -Type Queued

         ## Assert
         Should -Invoke Show-Browser -Exactly -Scope It -Times 1 -ParameterFilter {
            $url -eq 'https://dev.azure.com/test/project/_build/index?_a=queued&path=%5c'
         }
      }

      it 'with path should return url for mine' {
         ## Act
         Show-VSTeamBuildDefinition -projectName project -path '\test'

         ## Assert
         Should -Invoke Show-Browser -Exactly -Scope It -Times 1 -ParameterFilter {
            $url -like 'https://dev.azure.com/test/project/_Build/index?_a=allDefinitions&path=%5Ctest'
         }
      }

      it 'Mine with path missing \ should return url for mine with \ added' {
         ## Act
         Show-VSTeamBuildDefinition -projectName project -path 'test'

         ## Assert
         Should -Invoke Show-Browser -Exactly -Scope It -Times 1 -ParameterFilter {
            $url -like 'https://dev.azure.com/test/project/_Build/index?_a=allDefinitions&path=%5Ctest'
         }
      }
   }
}