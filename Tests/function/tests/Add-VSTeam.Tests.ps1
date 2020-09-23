Set-StrictMode -Version Latest

Describe "VSTeam" {
   BeforeAll {
      # Prepares everything for the tests below.
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      # The index parameter returns that instance of the value array
      # in the sample json file
      Mock _callAPI { Open-SampleFile 'Get-VSTeam.json' -Index 0 }

      # The Parameter Filter makes sure this mock is only called if the
      # function under test request the correct service version
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Core' }
   }

   Context "Add-VSTeam" -Tag 'Add' {
      It 'should create a team with team name only' {
         $team = Add-VSTeam -ProjectName Test `
            -TeamName "Test Team"

         $team | Should -Not -Be $null -Because 'Team must be returned'
         $team.Name | Should -Be 'Test Team' -Because 'Name must be set'
         $team.ProjectName | Should -Be 'Test' -Because 'Project Name must match'
         $team.Id | Should -Be "00000000-0000-0000-0000-000000000000" -Because 'Id must be set'

         Should -Invoke _callAPI -Exactly -Times 1 -Scope It -ParameterFilter {
            $Method -eq 'POST' -and
            $NoProject -eq $true -and
            $Resource -eq 'projects/Test/teams' -and
            $Body -eq '{ "name": "Test Team", "description": "" }' -and
            $Version -eq '1.0-unitTests'
         }
      }

      It 'should create a team with team name and description' {
         $team = Add-VSTeam -ProjectName Test `
            -TeamName "Test Team" `
            -Description "The default project team."

         $team | Should -Not -Be $null -Because 'Team must be returned'
         $team.ProjectName | Should -Be 'Test' -Because 'Project Name must match'
         $team.Id | Should -Be "00000000-0000-0000-0000-000000000000" -Because 'Id must be set'
         $team.Description | Should -Be 'The default project team.' -Because 'Description must be set'

         Should -Invoke _callAPI -Exactly -Times 1 -Scope It -ParameterFilter {
            $Method -eq 'POST' -and
            $NoProject -eq $true -and
            $Resource -eq 'projects/Test/teams' -and
            $Body -eq '{ "name": "Test Team", "description": "The default project team." }' -and
            $Version -eq '1.0-unitTests'
         }
      }
   }
}