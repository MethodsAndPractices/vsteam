Set-StrictMode -Version Latest

Describe 'VSTeamProject' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      . "$baseFolder/Source/Classes/VSTeamLeaf.ps1"
      . "$baseFolder/Source/Classes/VSTeamDirectory.ps1"
      . "$baseFolder/Source/Classes/VSTeamTask.ps1"
      . "$baseFolder/Source/Classes/VSTeamAttempt.ps1"
      . "$baseFolder/Source/Classes/VSTeamEnvironment.ps1"
      . "$baseFolder/Source/Private/applyTypes.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamQueue.ps1"
      . "$baseFolder/Source/Public/Remove-VSTeamAccount.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamBuildDefinition.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamProject.ps1"

      Mock _getApiVersion { return '1.0-unitTests' }
      Mock _getInstance { return 'https://dev.azure.com/test' }

      $singleResult = [PSCustomObject]@{
         name        = 'Test'
         description = ''
         url         = ''
         id          = '123-5464-dee43'
         state       = ''
         visibility  = ''
         revision    = [long]0
         defaultTeam = [PSCustomObject]@{ }
         _links      = [PSCustomObject]@{ }
      }
   }

   Context 'Update-VSTeamProject' {
      BeforeAll {
         Mock Invoke-RestMethod {
            return $singleResult
         }
         
         Mock Invoke-RestMethod {
            return $singleResult
         } -ParameterFilter { $Uri -eq "https://dev.azure.com/test/_apis/projects/Test?api-version=$(_getApiVersion Core)" }
         
         Mock Invoke-RestMethod {
            return @{status = 'inProgress'; url = 'https://someplace.com' }
         } -ParameterFilter { $Method -eq 'Patch' }
         
         Mock _trackProjectProgress

         Mock Invoke-RestMethod { return $singleResult } -ParameterFilter { $Uri -eq "https://dev.azure.com/test/_apis/projects/Testing123?api-version=$(_getApiVersion Core)" }
      }

      It 'with no op by id should not call Invoke-RestMethod' {
         Update-VSTeamProject -id '123-5464-dee43'

         Should -Invoke Invoke-RestMethod -Exactly 0
      }

      It 'with newName should change name' {
         Update-VSTeamProject -ProjectName Test -newName Testing123 -Force

         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter { $Uri -eq "https://dev.azure.com/test/_apis/projects/Test?api-version=$(_getApiVersion Core)" }
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter { $Method -eq 'Patch' -and $Body -eq '{"name": "Testing123"}' }
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter { $Uri -eq "https://dev.azure.com/test/_apis/projects/Testing123?api-version=$(_getApiVersion Core)" }
      }

      It 'with newDescription should change description' {
         Update-VSTeamProject -ProjectName Test -newDescription Testing123 -Force

         Should -Invoke Invoke-RestMethod -Exactly -Times 2 -Scope It -ParameterFilter { $Uri -eq "https://dev.azure.com/test/_apis/projects/Test?api-version=$(_getApiVersion Core)" }
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter { $Method -eq 'Patch' -and $Body -eq '{"description": "Testing123"}' }
      }

      It 'with new name and description should not call Invoke-RestMethod' {
         Update-VSTeamProject -ProjectName Test -newName Testing123 -newDescription Testing123 -Force

         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter { $Uri -eq "https://dev.azure.com/test/_apis/projects/Test?api-version=$(_getApiVersion Core)" }
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter { $Method -eq 'Patch' }
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter { $Uri -eq "https://dev.azure.com/test/_apis/projects/Testing123?api-version=$(_getApiVersion Core)" }
      }
   }
}