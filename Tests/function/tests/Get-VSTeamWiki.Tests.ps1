Set-StrictMode -Version Latest

Describe 'VSTeamWiki' {
   BeforeAll {
      $FakeOrg = 'myOrg'           
      
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      
      Mock _getInstance { return "https://dev.azure.com/$($FakeOrg)" }      
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Wiki' }
   }

   Context 'Get-VSTeamWiki' {
      BeforeAll {
         $FakeProject = 'project'
         $FakeId = 1111
         $FakeName = 'wkName'

         Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamWiki.json' }
         Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamWiki.json' -Index 0 } -ParameterFilter { 
            $Uri -like "*$FakeName*" 
         }
         Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamWiki.json' -Index 0 } -ParameterFilter { 
            $Uri -like "*$FakeId*" 
         }
      }
      It 'No parameters should return all published wikis for all projects' {
         ## Act
         Get-VSTeamWiki
         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -eq "https://dev.azure.com/$($FakeOrg)/_apis/wiki/wikis?api-version=$(_getApiVersion Wiki)"            
         }
      } 
      
      It 'Project name parameter should return wikis for the selected project' {
         ## Act
         Get-VSTeamWiki -projectName $FakeProject

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -eq "https://dev.azure.com/$($FakeOrg)/$($FakeProject)/_apis/wiki/wikis?api-version=$(_getApiVersion Wiki)"            
         }
      }      

      It 'Passing a name should return Wiki details' {
         ## Act
         Get-VSTeamWiki -projectName $FakeProject -name $FakeName

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -eq "https://dev.azure.com/$($FakeOrg)/$($FakeProject)/_apis/wiki/wikis/$($FakeName)?api-version=$(_getApiVersion Wiki)"           
         }
      }

      It 'Passing an Id should return Wiki details' {
         $FakeId = 1111
         ## Act
         Get-VSTeamWiki -projectName $FakeProject -WikiId $FakeId

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -eq "https://dev.azure.com/$($FakeOrg)/$($FakeProject)/_apis/wiki/wikis/$($FakeId)?api-version=$(_getApiVersion Wiki)"           
         }
      }
   }
}