Set-StrictMode -Version Latest

Describe 'VSTeamDirectAssignment' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$baseFolder/Source/Public/Invoke-VSTeamRequest.ps1"
   }

   Context 'Preview Mode' {
      It 'Should call API with ruleOption and select as 1 and grouprules respectively' {
         # Arrange
         Mock Invoke-VSTeamRequest { return @{ value = 'preview-response' } }

         # Act
         $result = Remove-VSTeamDirectAssignment -Preview

         # Assert
         $result | Should -Be 'preview-response'
         Assert-MockCalled Invoke-VSTeamRequest -Exactly 1 -ParameterFilter {
            $QueryString['ruleOption'] -eq '1' -and
            $QueryString['select'] -eq 'grouprules'
         }
      }
   }

   Context 'Non-Preview Mode' {
      It 'Should call API with ruleOption as 0 and select as grouprules' {
         # Arrange
         Mock Invoke-VSTeamRequest { return @{ value = 'non-preview-response' } }

         # Act
         $result = Remove-VSTeamDirectAssignment

         # Assert
         $result | Should -Be 'non-preview-response'
         Assert-MockCalled Invoke-VSTeamRequest -Exactly 1 -ParameterFilter {
            $QueryString['ruleOption'] -eq '0' -and
            $QueryString['select'] -eq 'grouprules'
         }
      }

      It 'Should chunk UserIds into groups of 20' {
         # Arrange
         $userIds = 1..45
         Mock Invoke-VSTeamRequest { return @{ value = 'chunk-response' } }

         # Act
         $result = Remove-VSTeamDirectAssignment -UserIds $userIds

         # Assert
         $result | Should -Be @('chunk-response', 'chunk-response', 'chunk-response')
         Assert-MockCalled Invoke-VSTeamRequest -Exactly 3
      }

      It 'Should not chunk when UserIds are less than or equal to 20' {
         # Arrange
         $userIds = 1..20
         Mock Invoke-VSTeamRequest { return @{ value = 'small-chunk-response' } }

         # Act
         $result = Remove-VSTeamDirectAssignment -UserIds $userIds

         # Assert
         $result | Should -Be 'small-chunk-response'
         Assert-MockCalled Invoke-VSTeamRequest -Exactly 1
      }
   }
}
