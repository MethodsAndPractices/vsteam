Set-StrictMode -Version Latest

Describe "VSTeam" {
   BeforeAll {
      Import-Module SHiPS
   
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamLeaf.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamTeam.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"
   }

   Context "Add-VSTeam" {
      BeforeAll {   
         $singleResult = Get-Content "$PSScriptRoot\sampleFiles\get-vsteam.json" -Raw | ConvertFrom-Json
      
         Mock _callAPI { return $singleResult }
         # These two lines will force a refresh of the project
         # cache and return an empty list.
         Mock _getProjects { return @() }
         Mock _hasProjectCacheExpired { return $true }
         Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Core' }
      }

      It 'with team name only should create a team' {
         Add-VSTeam -ProjectName Test -TeamName "TestTeam"

         Should -Invoke _callAPI -Exactly -Times 1 -Scope It -ParameterFilter {
            $NoProject -eq $true -and
            $Area -eq 'projects' -and
            $Resource -eq 'Test' -and
            $Method -eq 'Post' -and
            $ContentType -eq 'application/json' -and
            $Body -eq '{ "name": "TestTeam", "description": "" }'
            $Version -eq '1.0-unitTests'
         }
      }

      It 'with team name and description should create a team' {
         Add-VSTeam -ProjectName Test -TeamName "TestTeam" -Description "Test Description"

         Should -Invoke _callAPI -Exactly -Times 1 -Scope It -ParameterFilter {
            $NoProject -eq $true -and
            $Area -eq 'projects' -and
            $Resource -eq 'Test' -and
            $Method -eq 'Post' -and
            $ContentType -eq 'application/json' -and
            $Body -eq '{ "name": "TestTeam", "description": "Test Description" }'
            $Version -eq '1.0-unitTests'
         }
      }
   }
}