Set-StrictMode -Version Latest

Describe 'VSTeamApproval' -Tag 'unit', 'approvals' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      
      ## Arrange
      Mock Show-Browser -Verifiable
   }

   Context 'Show-VSTeamApproval' {      
      It 'should open in browser' {
         ## Act
         Show-VSTeamApproval -projectName project -ReleaseDefinitionId 1

         ## Assert
         Should -InvokeVerifiable
      }
   }
}