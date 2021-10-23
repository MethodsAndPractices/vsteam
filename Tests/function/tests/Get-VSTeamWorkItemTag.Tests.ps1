Set-StrictMode -Version Latest

Describe 'VSTeamWorkItemTag' {
   BeforeAll {
      $FakeOrg = 'myOrg'           
      
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      
      Mock _getInstance { return "https://dev.azure.com/$($FakeOrg)" }      
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Work Item Tracking' }
   }

   Context 'Get-VSTeamWorkItemTag' {
      BeforeAll {
         $FakeProject = 'project'
         $FakeId = 1111
         $FakeName = 'tagName'

         Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamWorkItemTag.json' }
         Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamWorkItemTag.json' -Index 0 } -ParameterFilter { 
            $Uri -like "*$FakeName*" 
         }
         Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamWorkItemTag.json' -Index 0 } -ParameterFilter { 
            $Uri -like "*$FakeId*" 
         }
      }
      
      It 'Project name parameter should return all work item tags for the selected project' {
         ## Act
         Get-VSTeamWorkItemTag -ProjectName $FakeProject

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -eq "https://dev.azure.com/$($FakeOrg)/$($FakeProject)/_apis/wit/tags?api-version=$(_getApiVersion Work Item Tracking)"            
         }
      }      

      It 'Passing a name should return work item tag details' {
         ## Act
         Get-VSTeamWorkItemTag -ProjectName $FakeProject -TagIdOrName $FakeName

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -eq "https://dev.azure.com/$($FakeOrg)/$($FakeProject)/_apis/wit/tags/$($FakeName)?api-version=$(_getApiVersion Work Item Tracking)"           
         }
      }

      It 'Passing an Id should return work item tag details' {
         $FakeId = 1111
         ## Act
         Get-VSTeamWorkItemTag -ProjectName $FakeProject -TagIdOrName $FakeId

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -eq "https://dev.azure.com/$($FakeOrg)/$($FakeProject)/_apis/wit/tags/$($FakeId)?api-version=$(_getApiVersion Work Item Tracking)"           
         }
      }
   }
}