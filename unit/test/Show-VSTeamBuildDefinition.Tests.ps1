Set-StrictMode -Version Latest

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/$sut"

Describe 'Show-VSTeamBuildDefinition' {
   Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable
      
   # Mock the call to Get-Projects by the dynamic parameter for ProjectName
   Mock Invoke-RestMethod { return @() } -ParameterFilter {
      $Uri -like "*_apis/projects*"
   }

   . "$PSScriptRoot\mocks\mockProjectNameDynamicParamNoPSet.ps1"

   Context 'Show-VSTeamBuildDefinition by ID' {
      Mock Show-Browser { }

      it 'should return url for mine' {
         Show-VSTeamBuildDefinition -projectName project -Id 15

         Assert-MockCalled Show-Browser -Exactly -Scope It -Times 1 -ParameterFilter {
            $url -eq 'https://dev.azure.com/test/project/_build/index?definitionId=15'
         }
      }
   }

   Context 'Show-VSTeamBuildDefinition Mine' {
      Mock Show-Browser { }

      it 'should return url for mine' {
         Show-VSTeamBuildDefinition -projectName project -Type Mine

         Assert-MockCalled Show-Browser -Exactly -Scope It -Times 1 -ParameterFilter {
            $url -eq 'https://dev.azure.com/test/project/_build/index?_a=mine&path=%5c'
         }
      }
   }

   Context 'Show-VSTeamBuildDefinition XAML' {
      Mock Show-Browser { }

      it 'should return url for XAML' {
         Show-VSTeamBuildDefinition -projectName project -Type XAML

         Assert-MockCalled Show-Browser -Exactly -Scope It -Times 1 -ParameterFilter {
            $url -eq 'https://dev.azure.com/test/project/_build/xaml&path=%5c'
         }
      }
   }

   Context 'Show-VSTeamBuildDefinition Queued' {
      Mock Show-Browser { }

      it 'should return url for Queued' {
         Show-VSTeamBuildDefinition -projectName project -Type Queued

         Assert-MockCalled Show-Browser -Exactly -Scope It -Times 1 -ParameterFilter {
            $url -eq 'https://dev.azure.com/test/project/_build/index?_a=queued&path=%5c'
         }
      }
   }

   Context 'Show-VSTeamBuildDefinition Mine with path' {
      Mock Show-Browser { }

      it 'should return url for mine' {
         Show-VSTeamBuildDefinition -projectName project -path '\test'

         Assert-MockCalled Show-Browser -Exactly -Scope It -Times 1 -ParameterFilter {
            $url -like 'https://dev.azure.com/test/project/_Build/index?_a=allDefinitions&path=%5Ctest'
         }
      }
   }

   Context 'Show-VSTeamBuildDefinition Mine with path missing \' {
      Mock Show-Browser { }

      it 'should return url for mine with \ added' {
         Show-VSTeamBuildDefinition -projectName project -path 'test'

         Assert-MockCalled Show-Browser -Exactly -Scope It -Times 1 -ParameterFilter {
            $url -like 'https://dev.azure.com/test/project/_Build/index?_a=allDefinitions&path=%5Ctest'
         }
      }
   }
}