Set-StrictMode -Version Latest

Describe 'VSTeamApproval' -Tag 'unit', 'approvals' {
   BeforeAll {
      Add-Type -Path "$PSScriptRoot/../../dist/bin/vsteam-lib.dll"
      
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")
      
      
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"

      # Prime the project cache with an empty list. This will make sure
      # any project name used will pass validation and Get-VSTeamProject 
      # will not need to be called.
      [vsteam_lib.ProjectCache]::Update([string[]]@())
      
      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' }

      Mock Show-Browser -Verifiable
   }

   Context 'Show-VSTeamApproval' {      
      It 'should open in browser' {
         Show-VSTeamApproval -projectName project -ReleaseDefinitionId 1

         Should -InvokeVerifiable
      }
   }
}