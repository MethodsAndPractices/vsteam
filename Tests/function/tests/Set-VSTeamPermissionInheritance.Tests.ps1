Set-StrictMode -Version Latest

Describe 'VSTeamPermissionInheritance' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$baseFolder/Source/Classes/VSTeamPermissionInheritance.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamProject.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamBuildDefinition.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamReleaseDefinition.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamGitRepository.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamAccessControlList.ps1"
      
      $gitRepoResult = Get-Content "$sampleFiles\singleGitRepo.json" -Raw | ConvertFrom-Json
      $buildDefresults = Get-Content "$sampleFiles\buildDefAzD.json" -Raw | ConvertFrom-Json
      $releaseDefresults = Get-Content "$sampleFiles\releaseDefAzD.json" -Raw | ConvertFrom-Json
      $accesscontrollistsResult = Get-Content "$sampleFiles\repoAccesscontrollists.json" -Raw | ConvertFrom-Json
      $gitRepoHierarchyUpdateResults = Get-Content "$sampleFiles\gitReopHierarchyQuery_Update.json" -Raw | ConvertFrom-Json
      $buildDefHierarchyUpdateResults = Get-Content "$sampleFiles\buildDefHierarchyQuery_Update.json" -Raw | ConvertFrom-Json
      $releaseDefHierarchyUpdateResults = Get-Content "$sampleFiles\releaseDefHierarchyQuery_Update.json" -Raw | ConvertFrom-Json

      $singleResult = [PSCustomObject]@{
         name        = 'Project'
         description = ''
         url         = ''
         id          = '123-5464-dee43'
         state       = ''
         visibility  = ''
         revision    = [long]0
         defaultTeam = [PSCustomObject]@{ }
         _links      = [PSCustomObject]@{ }
      }

      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Build' -or $Service -eq 'Release' -or $Service -eq 'Git' }

      Mock _callAPI { return $singleResult } -ParameterFilter {
         $Resource -eq 'projects' -and
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
            $Method -eq 'POST' -and
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
            $Method -eq 'POST' -and
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
            $Method -eq 'POST' -and
            $Body -like '*2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87*' -and
            $Body -like '*repoV2/123-5464-dee43/00000000-0000-0000-0000-000000000001*' -and
            $Uri -like "*https://dev.azure.com/test/_apis/Contribution/HierarchyQuery/123-5464-dee43*" -and
            $Uri -like "*api-version=$(_getApiVersion Git)*"
         }
      }
   }
}