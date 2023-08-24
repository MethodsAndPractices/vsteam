Set-StrictMode -Version Latest

Describe 'VSTeamWorkItemRelation' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$baseFolder/Source/Public/New-VSTeamWorkItemRelation.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamWorkItem.ps1"


      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamWorkItem-Id55-After.json' }
      Mock _getApiVersion { return '5.0-unitTests' } -ParameterFilter { $Service -eq 'Core' }
   }

   Context 'Get-VSTeamWorkItemRelation' {
      It 'Should return relations' {
         ## Act
         $relation = Get-VSTeamWorkItemRelation -Id 55

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/wit/workitems/55?api-version=$(_getApiVersion Core)&`$Expand=Relations"
         }
         $relation.Id | Should -Be 80
         $relation.RelationType | Should -Be "System.LinkTypes.Hierarchy-Reverse"
         $relation.Comment | Should -Be "Added from AzFunction"
      }
   }
}