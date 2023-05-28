Set-StrictMode -Version Latest

Describe 'VSTeamWorkItemRelationType' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamWorkItemRelationType.json' }
      Mock _getApiVersion { return '5.0-unitTests' } -ParameterFilter { $Service -eq 'Core' }
   }

   Context 'Get-VSTeamWorkItemRelationType' {
      It 'Should return relations default to WorkItemLink' {
         ## Act
         Get-VSTeamWorkItemRelationType

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/wit/workitemrelationtypes?api-version=$(_getApiVersion Core)"
         }
      }

      It 'With All parameter should return 2 relation types' {
         ## Act
         $relationTypes = Get-VSTeamWorkItemRelationType -Usage All

         ## Assert
         $relationTypes | Select-Object Usage -Unique | Should -HaveCount 2
      }
   }
}