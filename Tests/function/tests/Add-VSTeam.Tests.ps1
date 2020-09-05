Set-StrictMode -Version Latest

Describe "VSTeam" {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      Mock _callAPI { Open-SampleFile Get-VSTeam.json }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Core' }
   }

   Context "Add-VSTeam" {
      It 'with team name only should create a team' {
         Add-VSTeam -ProjectName Test -TeamName "TestTeam"

         Should -Invoke _callAPI -Exactly -Times 1 -Scope It -ParameterFilter {
            $NoProject -eq $true -and
            $Resource -eq 'projects/Test/teams' -and
            $Method -eq 'POST' -and
            $Body -eq '{ "name": "TestTeam", "description": "" }' -and
            $Version -eq '1.0-unitTests'
         }
      }

      It 'with team name and description should create a team' {
         Add-VSTeam -ProjectName Test -TeamName "TestTeam" -Description "Test Description"

         Should -Invoke _callAPI -Exactly -Times 1 -Scope It -ParameterFilter {
            $NoProject -eq $true -and
            $Resource -eq 'projects/Test/teams' -and
            $Method -eq 'POST' -and
            $Body -eq '{ "name": "TestTeam", "description": "Test Description" }' -and
            $Version -eq '1.0-unitTests'
         }
      }
   }
}