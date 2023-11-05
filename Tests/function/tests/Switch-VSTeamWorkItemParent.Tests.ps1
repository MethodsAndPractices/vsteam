Set-StrictMode -Version Latest

Describe "VSTeamWorkItemParent" {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$baseFolder/Source/Public/Get-VSTeamWorkItem.ps1"
      . "$baseFolder/Source/Public/Update-VSTeamWorkItem.ps1"
      . "$baseFolder/Source/Public/New-VSTeamWorkItemRelation.ps1"

      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unitTests' } #-ParameterFilter { $Service -eq 'Core' }
      Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamWorkItem-Id16.json' } -ParameterFilter { $Uri -like '*/_apis/wit/workitems/16*' }
      Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamWorkItem-Id16-After.json' } -ParameterFilter { $Uri -like '*/_apis/wit/workitems/16*' -and $Method -eq 'Patch' }
      Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamWorkItem-Id55-Before.json' } -ParameterFilter { $Uri -like '*/_apis/wit/workitems/55*' }
      Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamWorkItem-Id55-After.json' } -ParameterFilter { $Uri -like '*/_apis/wit/workitems/55*' -and $Method -eq 'Patch' }
      Mock New-VSTeamWorkItemRelation { return [PSCustomObject]@{ Operation = 'remove'; Index = 0 }} -ParameterFilter { $index -eq 0 }
      Mock New-VSTeamWorkItemRelation { return [PSCustomObject]@{ Id = 80; RelationType = 'System.LinkTypes.Hierarchy-Reverse'; Operation = 'add'; Index = '-' }} -ParameterFilter { $id -eq 80 }
      Mock New-VSTeamWorkItemRelation { return @(
         [PSCustomObject]@{ Operation = 'remove'; Index = 0 }
         [PSCustomObject]@{ Id = 80; RelationType = 'System.LinkTypes.Hierarchy-Reverse'; Operation = 'add'; Index = '-' }
      )} -ParameterFilter { $id -eq 80 -and $InputObject -ne $null}
   }

   Context 'Switch-VSTeamWorkItemParent' {
      It 'replaces old parent with new one' {
         $actual = Switch-VSTeamWorkItemParent -Id 55 -ParentId 80

         $actual.Fields."System.Parent" | Should -Be 80
         Should -Invoke Invoke-RestMethod -Exactly -Times 2 -Scope It
         Should -Invoke New-VSTeamWorkItemRelation -Exactly -Times 2 -Scope It
      }
      It 'should not replace the parent if new parent is the same than old parent' {
         $actual = Switch-VSTeamWorkItemParent -Id 55 -ParentId 70

         $actual.Fields."System.Parent" | Should -Be 70
         Should -Invoke New-VSTeamWorkItemRelation -Exactly -Times 0 -Scope It
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter { $Uri -like '*/_apis/wit/workitems/55*' }
      }

      It 'with AddParent it should add the parent if workitem did not have one' {
         $actual = Switch-VSTeamWorkItemParent -Id 16 -ParentId 80 -AddParent

         $actual.Fields."System.Parent" | Should -Be 80
         Should -Invoke Invoke-RestMethod -Exactly -Times 2 -Scope It
         Should -Invoke New-VSTeamWorkItemRelation -Exactly -Times 1 -Scope It
      }

      It 'without AddParent it should NOT add the parent if workitem did not have one' {
         $actual = Switch-VSTeamWorkItemParent -Id 16 -ParentId 80

         $actual.Fields."System.Parent" | Should -BeNullOrEmpty
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It
         Should -Invoke New-VSTeamWorkItemRelation -Exactly -Times 0 -Scope It
      }

   }
}