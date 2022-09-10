Set-StrictMode -Version Latest

Describe 'VSTeamProject' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$baseFolder/Source/Public/Get-VSTeamProject.ps1"

      Mock _getApiVersion { return '1.0-unitTests' }
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _invalidate
   }

   Context 'Update-VSTeamProject' {
      BeforeAll {

         Mock Get-VSTeamProject { Open-SampleFile 'Get-VSTeamProject-NamePeopleTracker.json' }

         Mock Invoke-RestMethod {
            return @{ status = 'inProgress'; url = 'https://someplace.com' }
         } -ParameterFilter {
            $Method -eq 'Patch'
         }

         Mock _trackProjectProgress
      }

      It 'with no op by id should not call Invoke-RestMethod' {
         ## Act
         Update-VSTeamProject -id '99081ca0-ec76-4a6b-840f-e70344e8784f' -Force

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly 1 -Scope It
      }

      It 'with newName should change name' {
         ## Act
.         Update-VSTeamProject -ProjectName Test -newName Testing123 -Force

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/projects/00000000-0000-0000-0000-000000000000?api-version=$(_getApiVersion Core)"
         }
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Method -eq 'Patch' -and $Body -like '*"name"*"Testing123"*'
         }
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/projects/00000000-0000-0000-0000-000000000000?api-version=$(_getApiVersion Core)"
         }
      }

      It 'with newDescription should change description' {
         ## Act
         Update-VSTeamProject -ProjectName Test -newDescription Testing123 -Force

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/projects/00000000-0000-0000-0000-000000000000?api-version=$(_getApiVersion Core)"
         }
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Method -eq 'Patch' -and $Body -like '*"description"*"Testing123"*'
         }
      }

      It 'with new name and description should not call Invoke-RestMethod' {
         ## Act
         Update-VSTeamProject -ProjectName Test -newName Testing123 -newDescription Testing123 -Force

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/projects/00000000-0000-0000-0000-000000000000?api-version=$(_getApiVersion Core)"
         }
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Method -eq 'Patch'
         }
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/projects/00000000-0000-0000-0000-000000000000?api-version=$(_getApiVersion Core)"
         }
      }

      It 'should change to public project' {
         ## Act
         Update-VSTeamProject -ProjectName Test -Visibility public -Force

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/projects/00000000-0000-0000-0000-000000000000?api-version=$(_getApiVersion Core)" -and
            $Method -eq 'Patch' -and $Body -like '*"visibility"*"public"}'
         }
      }
   }
}