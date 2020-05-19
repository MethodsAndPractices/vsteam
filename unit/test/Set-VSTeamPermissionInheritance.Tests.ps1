Set-StrictMode -Version Latest

Describe 'VSTeamPermissionInheritance' {
   BeforeAll {
      Import-Module SHiPS
      
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")
      
      . "$PSScriptRoot/../../Source/Classes/VSTeamLeaf.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamDirectory.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamUserEntitlement.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamTeams.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamRepositories.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamReleaseDefinitions.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Classes/UncachedProjectCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/UncachedProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamSecurityNamespace.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamPermissionInheritance.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamTask.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamAttempt.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamEnvironment.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamRelease.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamReleases.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamBuild.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamBuilds.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamPool.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamQueue.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamQueues.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamBuildDefinitionProcessPhaseStep.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamBuildDefinitionProcessPhase.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamBuildDefinitionProcess.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProject.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamGitRepository.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamBuildDefinition.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamBuildDefinitions.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamProject.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamBuildDefinition.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamReleaseDefinition.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamGitRepository.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamAccessControlList.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"
      
      $gitRepoResult = Get-Content "$PSScriptRoot\sampleFiles\singleGitRepo.json" -Raw | ConvertFrom-Json
      $buildDefresults = Get-Content "$PSScriptRoot\sampleFiles\buildDefAzD.json" -Raw | ConvertFrom-Json
      $releaseDefresults = Get-Content "$PSScriptRoot\sampleFiles\releaseDefAzD.json" -Raw | ConvertFrom-Json
      $accesscontrollistsResult = Get-Content "$PSScriptRoot\sampleFiles\repoAccesscontrollists.json" -Raw | ConvertFrom-Json
      $gitRepoHierarchyUpdateResults = Get-Content "$PSScriptRoot\sampleFiles\gitReopHierarchyQuery_Update.json" -Raw | ConvertFrom-Json
      $buildDefHierarchyUpdateResults = Get-Content "$PSScriptRoot\sampleFiles\buildDefHierarchyQuery_Update.json" -Raw | ConvertFrom-Json
      $releaseDefHierarchyUpdateResults = Get-Content "$PSScriptRoot\sampleFiles\releaseDefHierarchyQuery_Update.json" -Raw | ConvertFrom-Json

      $singleResult = [PSCustomObject]@{
         name        = 'Project'
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
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Build' -or $Service -eq 'Release' -or $Service -eq 'Git' }

      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter { $Uri -like "*_apis/projects*" }

      Mock _callAPI { return $singleResult } -ParameterFilter {
         $Area -eq 'projects' -and
         $id -eq 'project' -and
         $Version -eq "$(_getApiVersion Core)" -and
         $IgnoreDefaultProject -eq $true
      }

      Mock _useWindowsAuthenticationOnPremise { return $true }
   }

   Context 'Set-VSTeamPermissionInheritance buildDef' {
      BeforeAll {
         Mock _callAPI { return $buildDefresults } -ParameterFilter {
            $Area -eq 'build' -and
            $Resource -eq 'definitions' -and
            $Version -eq "$(_getApiVersion Build)"
         }

         Mock Invoke-RestMethod {
            # If this test fails uncomment the line below to see how the mock was called.
            # Write-Host $args
            # Write-Host $(_getApiVersion Build)

            return $buildDefHierarchyUpdateResults
         }
      }

      It 'should return true' {
         Set-VSTeamPermissionInheritance -projectName project -Name dynamTest-Docker-CI -resourceType BuildDefinition -NewState $false -Force

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Post' -and
            $Body -like '*123-5464-dee43/1432*' -and
            $Body -like '*33344d9c-fc72-4d6f-aba5-fa317101a7e9*' -and
            $Uri -like "*https://dev.azure.com/test/_apis/Contribution/HierarchyQuery/123-5464-dee43*" -and
            $Uri -like "*api-version=$(_getApiVersion Build)*"
         }
      }
   }

   Context 'Set-VSTeamPermissionInheritance releaseDef' {
      BeforeAll {
         Mock Get-VSTeamReleaseDefinition { return $releaseDefresults.value }
         Mock Invoke-RestMethod {
            # If this test fails uncomment the line below to see how the mock was called.
            # Write-Host $args
            # Write-Host $(_getApiVersion Release)

            return $releaseDefHierarchyUpdateResults
         }
      }

      It 'should return true' {
         Set-VSTeamPermissionInheritance -projectName project -Name PTracker-CD -resourceType ReleaseDefinition -NewState $false -Force

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Post' -and
            $Body -like '*c788c23e-1b46-4162-8f5e-d7585343b5de*' -and
            $Body -like '*123-5464-dee43//2*' -and
            $Uri -like "*https://dev.azure.com/test/_apis/Contribution/HierarchyQuery/123-5464-dee43*" -and
            $Uri -like "*api-version=$(_getApiVersion Release)*"
         }
      }
   }

   Context 'Set-VSTeamPermissionInheritance repository' {
      BeforeAll {
         Mock Get-VSTeamGitRepository { return $gitRepoResult }
         Mock Get-VSTeamAccessControlList { return $accesscontrollistsResult.value }

         Mock Invoke-RestMethod {
            # If this test fails uncomment the line below to see how the mock was called.
            #Write-Host $args
            #Write-Host $(_getApiVersion Git)

            return $gitRepoHierarchyUpdateResults
         }
      }

      It 'should return true' {
         Set-VSTeamPermissionInheritance -projectName project -Name project -resourceType Repository -NewState $false -Force

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Post' -and
            $Body -like '*2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87*' -and
            $Body -like '*repoV2/123-5464-dee43/00000000-0000-0000-0000-000000000001*' -and
            $Uri -like "*https://dev.azure.com/test/_apis/Contribution/HierarchyQuery/123-5464-dee43*" -and
            $Uri -like "*api-version=$(_getApiVersion Git)*"
         }
      }
   }
}