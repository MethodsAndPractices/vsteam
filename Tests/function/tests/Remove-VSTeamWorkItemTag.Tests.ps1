Set-StrictMode -Version Latest

Describe 'VSTeamWorkItemTag' {
   BeforeAll {
      $FakeOrg = 'myOrg'           
      
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      
      Mock _getInstance { return "https://dev.azure.com/$($FakeOrg)" }      
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Work Item Tracking' }
      Mock Get-VSTeamProject {return Open-SampleFile 'Get-VSTeamProject.json' }            
   }

   Context 'Remove-VSTeamWorkItemTag' {
      BeforeAll {
         $FakeProjectName = 'test'
         $FakeTagId = '00000000-0000-0000-0000-000000000000'   
         $FakeTagName = 'myTag'
      }
      
      It 'remove by id, should remove tag' {
         ## Act                  
         Remove-VSTeamWorkItemTag -ProjectName $FakeProjectName -TagIdOrName $FakeTagId
         
         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -eq "https://dev.azure.com/$($FakeOrg)/_apis/wit/tags/$($FakeTagId)?api-version=$(_getApiVersion Work Item Tracking)"  -and
            $Method -eq 'DELETE' 
         }
      }

      It 'remove by name, should remove tag' {
         ## Act                  
         Remove-VSTeamWorkItemTag -ProjectName $FakeProjectName -TagIdOrName $FakeTagName
         
         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -eq "https://dev.azure.com/$($FakeOrg)/_apis/wit/tags/$($FakeTagName)?api-version=$(_getApiVersion Work Item Tracking)"  -and
            $Method -eq 'DELETE' 
         }
      }
   }
}