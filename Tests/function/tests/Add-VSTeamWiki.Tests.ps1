Set-StrictMode -Version Latest

Describe 'VSTeamWiki' {
   BeforeAll {
      $FakeOrg = 'myOrg'           
      
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      
      Mock _getInstance { return "https://dev.azure.com/$($FakeOrg)" }      
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Wiki' }
      Mock Get-VSTeamProject {return Open-SampleFile 'Get-VSTeamProject.json' }      
   }

   Context 'Add-VSTeamWiki' {
      BeforeAll {         
         Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamWiki.json' -Index 0 } -ParameterFilter { 
            ($body | ConvertFrom-Json -Depth 10).Type -eq 'codeWiki'  
         }
         Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamWiki.json' -Index 1 } -ParameterFilter { 
            ($body | ConvertFrom-Json -Depth 10).Type -eq 'projectWiki'
         }
      }
      It 'Not Specifying wiki type should defult to projectWiki' {
         ## Act
         Add-VSTeamWiki -ProjectName 'project' -Name 'myWiki2'
         
         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -eq "https://dev.azure.com/$($FakeOrg)/_apis/wiki/wikis?api-version=$(_getApiVersion Wiki)"  -and
            $Method -eq 'POST' -and
            ($Body | ConvertFrom-Json -Depth 10).Type -eq 'ProjectWiki' -and
            ($Body | ConvertFrom-Json -Depth 10).Name -eq 'myWiki2'
         }
      }
            
      It 'Specifying type repositoryId, branch and mapped Path should create a codeWiki type' {
         ## Act
         Add-VSTeamWiki -ProjectName 'project' `
            -Name 'myWiki1' `
            -repositoryId 1111 `
            -branch 'main' `
            -mappedPath '/.Docs'
         
            ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -eq "https://dev.azure.com/$($FakeOrg)/_apis/wiki/wikis?api-version=$(_getApiVersion Wiki)"  -and
            $Method -eq 'POST' -and
            ($Body | ConvertFrom-Json -Depth 10).Type -eq 'codeWiki' -and
            ($Body | ConvertFrom-Json -Depth 10).Name -eq 'myWiki1' -and
            ($Body | ConvertFrom-Json -Depth 10).RepositoryId -eq 1111 -and
            ($Body | ConvertFrom-Json -Depth 10).Version.Version -eq 'main' -and
            ($Body | ConvertFrom-Json -Depth 10).MappedPath -eq '/.Docs'            
         }
      }
   }
}