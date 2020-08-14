Set-StrictMode -Version Latest

Describe 'VSTeam' {
   BeforeAll {
      Add-Type -Path "$PSScriptRoot/../../dist/bin/vsteam-lib.dll"
      
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"

      Mock _getInstance { return 'https://dev.azure.com/test' }

      Mock Show-Browser -Verifiable
   }

   Context 'Show-VSTeam' {
      It 'Should open browser' {
         Show-VSTeam
         
         Should -InvokeVerifiable
      }
   }
}