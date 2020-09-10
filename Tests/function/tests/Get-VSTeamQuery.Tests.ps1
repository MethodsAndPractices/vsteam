Set-StrictMode -Version Latest

Describe "VSTeam" {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
   }

   Context "Get-VSTeamQuery" {
      BeforeAll {
         ## Arrange
         Mock _callAPI { Open-SampleFile 'Get-VSTeamQuery.json' }
         Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Core' }
      }

      It 'with project name only should return queries' {
         ## Act
         Get-VSTeamQuery -ProjectName Test

         ## Assert
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
         ## Act
         Get-VSTeamQuery -ProjectName Test -Depth 2 -IncludeDeleted -Expand all

         ## Assert
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