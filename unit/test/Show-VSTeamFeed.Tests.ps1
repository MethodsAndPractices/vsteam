Set-StrictMode -Version Latest

Describe 'VSTeamFeed' {
   BeforeAll {
      Import-Module SHiPS

      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"

      Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable

      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter {
         $Uri -like "*_apis/projects*"
      }

      Mock Show-Browser
   }

   Context 'Show-VSTeamFeed' {
      It 'by name should call show-browser' {
         Show-VSTeamFeed -Name module

         Should -Invoke Show-Browser
      }

      It 'by id should call show-browser' {
         Show-VSTeamFeed -Id '00000000-0000-0000-0000-000000000000'

         Should -Invoke Show-Browser
      }
   }
}