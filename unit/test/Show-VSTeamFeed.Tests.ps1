Set-StrictMode -Version Latest

Describe 'VSTeamFeed' {
   BeforeAll {
      Import-Module SHiPS
      Add-Type -Path "$PSScriptRoot/../../dist/bin/vsteam-lib.dll"

      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")
      
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"

      # Prime the project cache with an empty list. This will make sure
      # any project name used will pass validation and Get-VSTeamProject 
      # will not need to be called.
      [vsteam_lib.ProjectCache]::Update([string[]]@())

      Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable

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