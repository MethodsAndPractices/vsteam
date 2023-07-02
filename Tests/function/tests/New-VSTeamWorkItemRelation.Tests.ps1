Set-StrictMode -Version Latest

Describe 'VSTeamWorkItemRelation' {
      BeforeAll {
         . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
         . "$baseFolder/Source/Public/Get-VSTeamWorkItem.ps1"

         Mock _getInstance { return 'https://dev.azure.com/test' }
         Mock _getApiVersion { return '5.0-unitTests' } -ParameterFilter { $Service -eq 'Core' }
         Mock Get-VSTeamWorkItem {
            return [PSCustomObject]@{
               Id = 55
               Title = "my title"
            }
         }

         $relations = Open-SampleFile 'Get-VSTeamWorkItemRelationTypePSObject.json'
         $relationsDict = [System.Collections.Generic.Dictionary[string, string]]::new()
         foreach ($r in $relations) {
            $relationsDict.Add($r.Name, $r.ReferenceName)
         }
         [vsteam_lib.RelationTypeCache]::Update($relationsDict);
   
      }

      Context 'New-VSTeamWorkItemRelation' {
         It 'Sould return a Relation object' {
            $expected = [PSCustomObject]@{
               Id = 55
               Operation = "add"
               RelationType = "System.LinkTypes.Hierarchy-Reverse"
               Comment = "MyComment"
            }

            $actual = New-VSTeamWorkItemRelation -RelationType Parent -Id 55 -Comment "MyComment"

            $actual.Id | Should -Be $expected.Id
            $actual.Operation | Should -Be $expected.Operation
            $actual.RelationType | Should -Be $expected.RelationType
            $actual.Comment | Should -Be $expected.Comment
         }


         It 'With list pipeline should return an array of relations' {
            $actual = 55, 66, 77 | New-VSTeamWorkItemRelation -RelationType Child

            $actual | Should -HaveCount 3
            $actual[0].Id | Should -Be "55"
            $actual[1].Id | Should -Be "66"
            $actual[2].Id | Should -Be "77"
            $actual[0].RelationType | Should -Be "System.LinkTypes.Hierarchy-Forward"
         }

         It 'With chained calls should return an array of relations' {
            $actual = New-VSTeamWorkItemRelation -RelationType Child -Id 55 |
                      New-VSTeamWorkItemRelation -RelationType Child -Id 66 | 
                      New-VSTeamWorkItemRelation -RelationType Child -Id 77

            $actual | Should -HaveCount 3
            $actual[0].Id | Should -Be "55"
            $actual[1].Id | Should -Be "66"
            $actual[2].Id | Should -Be "77"
            $actual[0].RelationType | Should -Be "System.LinkTypes.Hierarchy-Forward"          
         }

         It 'With WorkItem in the pipeline should use the workItem.Id' {
            $actual = Get-VSTeamWorkItem -Id 55 | New-VSTeamWorkItemRelation -RelationType Child
            $actual.Id | Should -Be "55"
            $actual.Operation | Should -Be "add"
            $actual.RelationType | Should -Be "System.LinkTypes.Hierarchy-Forward"          
         }

         It 'Objects have vsteam_lib.WorkItemRelation TypeName' {
            $actual = New-VSTeamWorkItemRelation -RelationType Child -Id 55 |
                      New-VSTeamWorkItemRelation -RelationType Child -Id 66
            $actual[0].PSObject.TypeNames | Should -Contain "vsteam_lib.WorkItemRelation"
            $actual[1].PSObject.TypeNames | Should -Contain "vsteam_lib.WorkItemRelation"
         }

         It 'With Index paramter ID nor RelationType are needed' {
            $actual = New-VSTeamWorkItemRelation -Index 0 -Operation Remove 
            $actual.Id | Should -BeNullOrEmpty
            $actual.RelationType | Should -BeNullOrEmpty
         }
      }
}