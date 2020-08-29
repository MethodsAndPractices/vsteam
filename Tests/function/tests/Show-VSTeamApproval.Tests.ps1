Set-StrictMode -Version Latest

Describe 'VSTeamApproval' -Tag 'unit', 'approvals' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      
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