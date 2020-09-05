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
   
      ## Arrange
      $gitRepoResult = Open-SampleFile singleGitRepo.json
      $releaseDefresults = Open-SampleFile releaseDefAzD.json
      $buildDefHierarchyResults = Open-SampleFile buildDefHierarchyQuery.json
      $accesscontrollistsResult = Open-SampleFile repoAccesscontrollists.json
      $releaseDefHierarchyResults = Open-SampleFile releaseDefHierarchyQuery.json
   }

   Context 'Get-VSTeamPermissionInheritance' {
      BeforeAll {
         ## Arrange
         Mock _getInstance { return 'https://dev.azure.com/test' }
         Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter {
            $Service -eq 'Build' -or
            $Service -eq 'Release' -or
            $Service -eq 'Git'
         }
         
         Mock Invoke-RestMethod { return @() } -ParameterFilter {
            $Uri -like "*`$top=100*" -and
            $Uri -like "*stateFilter=WellFormed*"
         }

         Mock Get-VSTeamProject { Open-SampleFile projectResult.json } -ParameterFilter {
            $Name -like 'project'
         }
         Mock Get-VSTeamGitRepository { return $gitRepoResult }
         Mock Get-VSTeamBuildDefinition { Open-SampleFile buildDefAzD.json -ReturnValue }
         Mock Get-VSTeamReleaseDefinition { return $releaseDefresults.value }
         Mock Get-VSTeamAccessControlList { return $accesscontrollistsResult.value }
         Mock Invoke-RestMethod { return $releaseDefHierarchyResults } -ParameterFilter {
            $Body -like '*c788c23e-1b46-4162-8f5e-d7585343b5de*'
         }
         Mock Invoke-RestMethod { return $buildDefHierarchyResults } -ParameterFilter {
            $Body -like '*010d06f0-00d5-472a-bb47-58947c230876/1432*'
         }
      }

      It 'buildDef should return true' {
         ## Act
         $actual = Get-VSTeamPermissionInheritance -projectName Project -Name dynamTest-Docker-CI -resourceType BuildDefinition

         ## Assert
         $actual | Should -Be $true
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Post' -and
            $Body -like '*010d06f0-00d5-472a-bb47-58947c230876/1432*' -and
            $Body -like '*33344d9c-fc72-4d6f-aba5-fa317101a7e9*' -and
            $Uri -like "*https://dev.azure.com/test/_apis/Contribution/HierarchyQuery/Project/010d06f0-00d5-472a-bb47-58947c230876*" -and
            $Uri -like "*api-version=$(_getApiVersion Build)*"
         }
      }

      It 'releaseDef should return true' {
         ## Act
         Get-VSTeamPermissionInheritance -projectName project -Name PTracker-CD -resourceType ReleaseDefinition | Should -Be $true

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Post' -and
            $Body -like '*c788c23e-1b46-4162-8f5e-d7585343b5de*' -and
            $Body -like '*010d06f0-00d5-472a-bb47-58947c230876//2*' -and
            $Uri -like "*https://dev.azure.com/test/_apis/Contribution/HierarchyQuery/project/010d06f0-00d5-472a-bb47-58947c230876*" -and
            $Uri -like "*api-version=$(_getApiVersion Release)*"
         }
      }

      It 'repository should return true' {
         ## Act
         Get-VSTeamPermissionInheritance -projectName project -Name project -resourceType Repository | Should -Be $true

         ## Assert
         Should -Invoke Get-VSTeamAccessControlList -Exactly -Scope It -Times 1
      }
   }
}