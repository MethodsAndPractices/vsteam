Set-StrictMode -Version Latest

Describe "VSTeam" {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      . "$baseFolder/Source/Private/applyTypes.ps1"
   }

   Context "Get-VSTeamQuery" {
      BeforeAll {
         $results = Get-Content "$sampleFiles\Get-VSTeamQuery.json" -Raw | ConvertFrom-Json

         Mock _callAPI { return $results }

         Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Core' }
      }

      It 'with project name only should return queries' {
         Get-VSTeamQuery -ProjectName Test

         Should -Invoke _callAPI -Exactly -Times 1 -Scope It -ParameterFilter {
            $ProjectName -eq 'Test' -and
            $Area -eq 'wit' -and
            $Resource -eq 'queries' -and
            $QueryString['$depth'] -eq "1" -and
            $QueryString['$expand'] -eq "none" -and
            $QueryString['$includeDeleted'] -eq $false -and
            $Version -eq '1.0-unitTests'
         }
      }

      It 'with project name and options should create a team' {
         Get-VSTeamQuery -ProjectName Test -Depth 2 -IncludeDeleted -Expand all

         Should -Invoke _callAPI -Exactly -Times 1 -Scope It -ParameterFilter {
            $ProjectName -eq 'Test' -and
            $Area -eq 'wit' -and
            $Resource -eq 'queries' -and
            $QueryString['$depth'] -eq "2" -and
            $QueryString['$expand'] -eq "all" -and
            $QueryString['$includeDeleted'] -eq $true -and
            $Version -eq '1.0-unitTests'
         }
      }
   }
}