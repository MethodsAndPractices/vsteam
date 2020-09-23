Set-StrictMode -Version Latest

Describe 'VSTeamProject' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$baseFolder/Source/Public/Get-VSTeamProject.ps1"

      Mock _getApiVersion { return '1.0-unitTests' }
      Mock _getInstance { return 'https://dev.azure.com/test' }
   }

   Context 'Update-VSTeamProject' {
      BeforeAll {
         Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamProject-NamePeopleTracker.json' }
         
         Mock Invoke-RestMethod {
            return @{ status = 'inProgress'; url = 'https://someplace.com' }
         } -ParameterFilter {
            $Method -eq 'Patch' 
         }

         Mock _trackProjectProgress
      }

      It 'with no op by id should not call Invoke-RestMethod' {
         ## Act
         Update-VSTeamProject -id '123-5464-dee43'

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly 0
      }

      It 'with newName should change name' {
         ## Act
         Update-VSTeamProject -ProjectName Test -newName Testing123 -Force

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/projects/Test?api-version=$(_getApiVersion Core)" 
         }
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Method -eq 'Patch' -and $Body -eq '{"name": "Testing123"}' 
         }
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter { 
            $Uri -eq "https://dev.azure.com/test/_apis/projects/Testing123?api-version=$(_getApiVersion Core)" 
         }
      }

      It 'with newDescription should change description' {
         ## Act
         Update-VSTeamProject -ProjectName Test -newDescription Testing123 -Force

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 2 -Scope It -ParameterFilter { 
            $Uri -eq "https://dev.azure.com/test/_apis/projects/Test?api-version=$(_getApiVersion Core)" 
         }
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter { 
            $Method -eq 'Patch' -and $Body -eq '{"description": "Testing123"}' 
         }
      }

      It 'with new name and description should not call Invoke-RestMethod' {
         ## Act
         Update-VSTeamProject -ProjectName Test -newName Testing123 -newDescription Testing123 -Force

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter { 
            $Uri -eq "https://dev.azure.com/test/_apis/projects/Test?api-version=$(_getApiVersion Core)" 
         }
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter { 
            $Method -eq 'Patch' 
         }
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter { 
            $Uri -eq "https://dev.azure.com/test/_apis/projects/Testing123?api-version=$(_getApiVersion Core)" 
         }
      }
   }
}