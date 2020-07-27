Set-StrictMode -Version Latest

Describe 'VSTeamProject' {
   BeforeAll {
      Import-Module SHiPS

      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamLeaf.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamDirectory.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProcess.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProcessCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamUserEntitlement.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamTeams.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamRepositories.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamReleaseDefinitions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamTask.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamAttempt.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamEnvironment.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamRelease.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamReleases.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamBuild.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamBuilds.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamQueues.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamBuildDefinitions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProject.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamGitRepository.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamBuildDefinitionProcessPhaseStep.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamBuildDefinitionProcessPhase.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamBuildDefinitionProcess.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamPool.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamQueue.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamBuildDefinition.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProcessTemplateCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/UncachedProjectCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProcessValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Classes/UncachedProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamQueue.ps1"
      . "$PSScriptRoot/../../Source/Public/Remove-VSTeamAccount.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamBuildDefinition.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamProcess.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamProject.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"

      $singleResult = [PSCustomObject]@{
         name        = 'Test'
         description = ''
         url         = ''
         id          = '123-5464-dee43'
         state       = ''
         visibility  = ''
         revision    = 0
         defaultTeam = [PSCustomObject]@{ }
         _links      = [PSCustomObject]@{ }
      }

      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unitTests' }
      Mock _callApi -ParameterFilter { $area -eq 'work' -and $resource -eq 'processes' } -MockWith {
         return [PSCustomObject]@{value = @(
               [PSCustomObject]@{
                  name   = 'Agile'
                  Typeid = '00000000-0000-0000-0000-000000000001' 
               },
               [PSCustomObject]@{
                  name   = 'CMMI'
                  Typeid = '00000000-0000-0000-0000-000000000002' 
               },
               [PSCustomObject]@{
                  name   = 'Scrum'
                  Typeid = '00000000-0000-0000-0000-000000000003' 
               }
            )
         }
      }         
   }

   Context 'Add-VSTeamProject' {
      BeforeAll {
         Mock Write-Progress

         # Add Project
         Mock Invoke-RestMethod { return @{status = 'inProgress'; id = '123-5464-dee43'; url = 'https://someplace.com' } } -ParameterFilter {
            $Method -eq 'Post' -and
            $Uri -eq "https://dev.azure.com/test/_apis/projects?api-version=$(_getApiVersion Core)"
         }

         # Track Progress
         Mock Invoke-RestMethod {
            # This $i is in the module. Because we use InModuleScope
            # we can see it
            if ($i -gt 9) {
               return @{status = 'succeeded' }
            }

            return @{status = 'inProgress' }
         } -ParameterFilter {
            $Uri -eq 'https://someplace.com'
         }

         # Get-VSTeamProject
         Mock Invoke-RestMethod { return $singleResult } -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/projects/Test?api-version=$(_getApiVersion Core)"
         }

      }
      #-Area 'work' -resource 'processes'       
      It 'with tfvc should create project with tfvc' {
         Add-VSTeamProject -Name Test -tfvc

         Should -Invoke Invoke-RestMethod -Times 1 -Scope It  -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/projects/Test?api-version=$(_getApiVersion Core)"
         }
         Should -Invoke Invoke-RestMethod -Times 1 -Scope It  -ParameterFilter {
            $Method -eq 'Post' -and
            $Uri -eq "https://dev.azure.com/test/_apis/projects?api-version=$(_getApiVersion Core)" -and
            $Body -eq '{"name": "Test", "description": "", "capabilities": {"versioncontrol": { "sourceControlType": "Tfvc"}, "processTemplate":{"templateTypeId": "6b724908-ef14-45cf-84f8-768b5384da45"}}}'
         }
      }
   }

   Context 'Add-VSTeamProject with Agile' {
      BeforeAll {
         Mock Invoke-RestMethod { return @{status = 'inProgress'; id = 1; url = 'https://someplace.com' } } -ParameterFilter { $Method -eq 'Post' -and $Uri -eq "https://dev.azure.com/test/_apis/projects?api-version=$(_getApiVersion Core)" }
         Mock _trackProjectProgress
         Mock Invoke-RestMethod { return $singleResult } -ParameterFilter { $Uri -eq "https://dev.azure.com/test/_apis/projects/Test?api-version=$(_getApiVersion Core)" }
      }

      It 'Should create project with Agile' {
         Add-VSTeamProject -ProjectName Test -processTemplate Agile

         Should -Invoke Invoke-RestMethod -Times 1 -ParameterFilter { $Uri -eq "https://dev.azure.com/test/_apis/projects/Test?api-version=$(_getApiVersion Core)" }
         Should -Invoke Invoke-RestMethod -Times 1 -ParameterFilter { $Method -eq 'Post' -and $Uri -eq "https://dev.azure.com/test/_apis/projects?api-version=$(_getApiVersion Core)" }
      }
   }

   Context 'Add-VSTeamProject with CMMI' {
      BeforeAll {
         Mock Invoke-RestMethod { return @{status = 'inProgress'; id = 1; url = 'https://someplace.com' } } -ParameterFilter { $Method -eq 'Post' -and $Uri -eq "https://dev.azure.com/test/_apis/projects?api-version=$(_getApiVersion Core)" }
         Mock _trackProjectProgress
         Mock Invoke-RestMethod { return $singleResult } -ParameterFilter { $Uri -eq "https://dev.azure.com/test/_apis/projects/Test?api-version=$(_getApiVersion Core)" }
         Mock Get-VSTeamProcess { return [PSCustomObject]@{
               name   = 'CMMI'
               id     = 1
               Typeid = '00000000-0000-0000-0000-000000000002' 
            } 
         }
      }

      It 'Should create project with CMMI' {
         Add-VSTeamProject -ProjectName Test -processTemplate CMMI

         Should -Invoke Invoke-RestMethod -Times 1 -ParameterFilter { $Uri -eq "https://dev.azure.com/test/_apis/projects/Test?api-version=$(_getApiVersion Core)" }
         Should -Invoke Invoke-RestMethod -Times 1 -ParameterFilter { $Method -eq 'Post' -and $Uri -eq "https://dev.azure.com/test/_apis/projects?api-version=$(_getApiVersion Core)" }
      }
   }

   Context 'Add-VSTeamProject throws error' {
      BeforeAll {
         Mock Invoke-RestMethod { return @{status = 'inProgress'; id = 1; url = 'https://someplace.com' } } -ParameterFilter { $Method -eq 'Post' -and $Uri -eq "https://dev.azure.com/test/_apis/projects?api-version=$(_getApiVersion Core)" }
         Mock Write-Error
         Mock _trackProjectProgress { throw 'Test error' }
         Mock Invoke-RestMethod { return $singleResult } -ParameterFilter { $Uri -eq "https://dev.azure.com/test/_apis/projects/Test?api-version=$(_getApiVersion Core)" }
      }

      It '_trackProjectProgress errors should throw' {
         { Add-VSTeamProject -projectName Test -processTemplate CMMI } | Should -Throw
      }
   }
}
