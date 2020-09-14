Set-StrictMode -Version Latest

Describe 'VSTeamPermissionInheritance' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$baseFolder/Source/Public/Get-VSTeamProject.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamBuildDefinition.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamReleaseDefinition.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamGitRepository.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamAccessControlList.ps1"

      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter {
         $Service -eq 'HierarchyQuery'
      }

      Mock _callAPI { Open-SampleFile 'Get-VSTeamProject-NamePeopleTracker.json' } -ParameterFilter {
         $Resource -eq 'projects' -and
         $id -eq 'project' -and
         $Version -eq "$(_getApiVersion Core)" -and
         $IgnoreDefaultProject -eq $true
      }

      Mock _useWindowsAuthenticationOnPremise { return $true }
   }

   Context 'Set-VSTeamPermissionInheritance buildDef' {
      BeforeAll {
         Mock _callAPI { Open-SampleFile 'buildDefAzD.json' } -ParameterFilter {
            $Area -eq 'build' -and
            $Resource -eq 'definitions' -and
            $Version -eq "$(_getApiVersion Build)"
         }

         Mock Invoke-RestMethod { Open-SampleFile 'buildDefHierarchyQuery_Update.json' }
      }

      It 'should return true' {
         Set-VSTeamPermissionInheritance -projectName project `
            -Name dynamTest-Docker-CI `
            -resourceType BuildDefinition `
            -NewState $false `
            -Force

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'POST' -and
            $Body -like '*00000000-0000-0000-0000-000000000000/1432*' -and
            $Body -like '*33344d9c-fc72-4d6f-aba5-fa317101a7e9*' -and
            $Uri -like "*https://dev.azure.com/test/_apis/Contribution/HierarchyQuery/00000000-0000-0000-0000-000000000000*" -and
            $Uri -like "*api-version=$(_getApiVersion HierarchyQuery)*"
         }
      }
   }

   Context 'Set-VSTeamPermissionInheritance releaseDef' {
      BeforeAll {
         Mock Invoke-RestMethod { Open-SampleFile 'releaseDefHierarchyQuery_Update.json' }
         Mock Get-VSTeamReleaseDefinition { Open-SampleFile 'releaseDefAzD.json' -ReturnValue }
      }

      It 'should return true' {
         Set-VSTeamPermissionInheritance -projectName project -Name PTracker-CD -resourceType ReleaseDefinition -NewState $false -Force

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'POST' -and
            $Body -like '*c788c23e-1b46-4162-8f5e-d7585343b5de*' -and
            $Body -like '*00000000-0000-0000-0000-000000000000//2*' -and
            $Uri -like "*https://dev.azure.com/test/_apis/Contribution/HierarchyQuery/00000000-0000-0000-0000-000000000000*" -and
            $Uri -like "*api-version=$(_getApiVersion HierarchyQuery)*"
         }
      }
   }

   Context 'Set-VSTeamPermissionInheritance repository' {
      BeforeAll {
         Mock Get-VSTeamGitRepository { Open-SampleFile 'singleGitRepo.json' }
         Mock Invoke-RestMethod { Open-SampleFile 'gitReopHierarchyQuery_Update.json' }
         Mock Get-VSTeamAccessControlList { Open-SampleFile 'repoAccesscontrollists.json' }
      }

      It 'should return true' {
         Set-VSTeamPermissionInheritance -projectName project -Name project -resourceType Repository -NewState $false -Force

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'POST' -and
            $Body -like '*2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87*' -and
            $Body -like '*repoV2/00000000-0000-0000-0000-000000000000/00000000-0000-0000-0000-000000000001*' -and
            $Uri -like "*https://dev.azure.com/test/_apis/Contribution/HierarchyQuery/00000000-0000-0000-0000-000000000000*" -and
            $Uri -like "*api-version=$(_getApiVersion HierarchyQuery)*"
         }
      }
   }
}