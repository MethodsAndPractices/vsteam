Set-StrictMode -Version Latest

# This is an undocumented API
Describe 'VSTeamPermissionInheritance' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$baseFolder/Source/Public/Get-VSTeamProject.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamBuildDefinition.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamReleaseDefinition.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamGitRepository.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamAccessControlList.ps1"
   }

   Context 'Get-VSTeamPermissionInheritance' {
      BeforeAll {
         ## Arrange
         Mock _supportsHierarchyQuery
         Mock _getInstance { return 'https://dev.azure.com/test' }
         Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter {
            $Service -eq 'HierarchyQuery'
         }

         Mock Get-VSTeamProject { Open-SampleFile 'projectResult.json' } -ParameterFilter {
            $Name -like 'project'
         }
         Mock Get-VSTeamGitRepository { Open-SampleFile 'singleGitRepo.json' }
         Mock Get-VSTeamBuildDefinition { Open-SampleFile 'buildDefAzD.json' -ReturnValue }
         Mock Get-VSTeamReleaseDefinition { Open-SampleFile 'releaseDefAzD.json' -ReturnValue }
         Mock Get-VSTeamAccessControlList { Open-SampleFile 'repoAccesscontrollists.json' -ReturnValue }
         Mock Invoke-RestMethod { Open-SampleFile 'releaseDefHierarchyQuery.json' } -ParameterFilter {
            $Body -like '*c788c23e-1b46-4162-8f5e-d7585343b5de*'
         }
         Mock Invoke-RestMethod { Open-SampleFile 'buildDefHierarchyQuery.json' } -ParameterFilter {
            $Body -like '*010d06f0-00d5-472a-bb47-58947c230876/1432*'
         }
      }

      It 'should return true buildDef' {
         ## Act
         $actual = Get-VSTeamPermissionInheritance -projectName Project -Name dynamTest-Docker-CI -resourceType BuildDefinition

         ## Assert
         $actual | Should -Be $true
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Post' -and
            $Body -like '*010d06f0-00d5-472a-bb47-58947c230876/1432*' -and
            $Body -like '*33344d9c-fc72-4d6f-aba5-fa317101a7e9*' -and
            $Uri -like "*https://dev.azure.com/test/_apis/Contribution/HierarchyQuery/Project/010d06f0-00d5-472a-bb47-58947c230876*" -and
            $Uri -like "*api-version=$(_getApiVersion HierarchyQuery)*"
         }
      }

      It 'should return true releaseDef' {
         ## Act
         Get-VSTeamPermissionInheritance -projectName project -Name PTracker-CD -resourceType ReleaseDefinition | Should -Be $true

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Post' -and
            $Body -like '*c788c23e-1b46-4162-8f5e-d7585343b5de*' -and
            $Body -like '*010d06f0-00d5-472a-bb47-58947c230876//2*' -and
            $Uri -like "*https://dev.azure.com/test/_apis/Contribution/HierarchyQuery/project/010d06f0-00d5-472a-bb47-58947c230876*" -and
            $Uri -like "*api-version=$(_getApiVersion HierarchyQuery)*"
         }
      }

      It 'should return true repository' {
         ## Act
         Get-VSTeamPermissionInheritance -projectName project -Name project -resourceType Repository | Should -Be $true

         ## Assert
         Should -Invoke Get-VSTeamAccessControlList -Exactly -Scope It -Times 1
      }
   }
}