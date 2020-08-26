Set-StrictMode -Version Latest

Describe "VSTeam" {
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
   }

   Context "Add-VSTeam" {
      BeforeAll {
         $singleResult = Get-Content "$PSScriptRoot\sampleFiles\get-vsteam.json" -Raw | ConvertFrom-Json

         Mock _callAPI { return $singleResult }

         Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Core' }
      }

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