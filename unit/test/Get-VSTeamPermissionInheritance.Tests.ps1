Set-StrictMode -Version Latest

#region include
Import-Module SHiPS

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Classes/ProjectCompleter.ps1"
. "$here/../../Source/Classes/ProjectValidateAttribute.ps1"
. "$here/../../Source/Classes/UncachedProjectCompleter.ps1"
. "$here/../../Source/Classes/UncachedProjectValidateAttribute.ps1"
. "$here/../../Source/Classes/VSTeamLeaf.ps1"
. "$here/../../Source/Classes/VSTeamSecurityNamespace.ps1"
. "$here/../../Source/Classes/VSTeamPermissionInheritance.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/Get-VSTeamProject.ps1"
. "$here/../../Source/Public/Get-VSTeamBuildDefinition.ps1"
. "$here/../../Source/Public/Get-VSTeamReleaseDefinition.ps1"
. "$here/../../Source/Public/Get-VSTeamGitRepository.ps1"
. "$here/../../Source/Public/Get-VSTeamAccessControlList.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe 'VSTeamPermissionInheritance' {
   ## Arrange
   $singleResult = Get-Content "$PSScriptRoot\sampleFiles\projectResult.json" -Raw | ConvertFrom-Json
   $buildDefresults = Get-Content "$PSScriptRoot\sampleFiles\buildDefAzD.json" -Raw | ConvertFrom-Json
   $gitRepoResult = Get-Content "$PSScriptRoot\sampleFiles\singleGitRepo.json" -Raw | ConvertFrom-Json
   $releaseDefresults = Get-Content "$PSScriptRoot\sampleFiles\releaseDefAzD.json" -Raw | ConvertFrom-Json
   $buildDefHierarchyResults = Get-Content "$PSScriptRoot\sampleFiles\buildDefHierarchyQuery.json" -Raw | ConvertFrom-Json
   $accesscontrollistsResult = Get-Content "$PSScriptRoot\sampleFiles\repoAccesscontrollists.json" -Raw | ConvertFrom-Json
   $releaseDefHierarchyResults = Get-Content "$PSScriptRoot\sampleFiles\releaseDefHierarchyQuery.json" -Raw | ConvertFrom-Json

   Context 'Get-VSTeamPermissionInheritance' {
      ## Arrange
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter {
         $Service -eq 'Build' -or
         $Service -eq 'Release' -or
         $Service -eq 'Git'
      }
      Mock _hasProjectCacheExpired { return $false }

      Mock Get-VSTeamProject { return $singleResult }
      Mock Get-VSTeamGitRepository { return $gitRepoResult }
      Mock Get-VSTeamBuildDefinition { return $buildDefresults.value }
      Mock Get-VSTeamReleaseDefinition { return $releaseDefresults.value }
      Mock Get-VSTeamAccessControlList { return $accesscontrollistsResult.value }
      Mock Invoke-RestMethod { return $releaseDefHierarchyResults } -ParameterFilter {
         $Body -like '*c788c23e-1b46-4162-8f5e-d7585343b5de*'
      }
      Mock Invoke-RestMethod { return $buildDefHierarchyResults } -ParameterFilter {
         $Body -like '*010d06f0-00d5-472a-bb47-58947c230876/1432*'
      }

      It 'buildDef should return true' {
         ## Act
         $actual = Get-VSTeamPermissionInheritance -projectName Project -Name dynamTest-Docker-CI -resourceType BuildDefinition

         ## Assert
         $actual | Should be $true
         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Post' -and
            $Body -like '*010d06f0-00d5-472a-bb47-58947c230876/1432*' -and
            $Body -like '*33344d9c-fc72-4d6f-aba5-fa317101a7e9*' -and
            $Uri -like "*https://dev.azure.com/test/_apis/Contribution/HierarchyQuery/Project/010d06f0-00d5-472a-bb47-58947c230876*" -and
            $Uri -like "*api-version=$(_getApiVersion Build)*"
         }
      }

      It 'releaseDef should return true' {
         ## Act
         Get-VSTeamPermissionInheritance -projectName project -Name PTracker-CD -resourceType ReleaseDefinition | Should be $true

         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Post' -and
            $Body -like '*c788c23e-1b46-4162-8f5e-d7585343b5de*' -and
            $Body -like '*010d06f0-00d5-472a-bb47-58947c230876//2*' -and
            $Uri -like "*https://dev.azure.com/test/_apis/Contribution/HierarchyQuery/project/010d06f0-00d5-472a-bb47-58947c230876*" -and
            $Uri -like "*api-version=$(_getApiVersion Release)*"
         }
      }
      
      It 'repository should return true' {
         ## Act
         Get-VSTeamPermissionInheritance -projectName project -Name project -resourceType Repository | Should be $true

         ## Assert
         Assert-MockCalled Get-VSTeamAccessControlList -Exactly -Scope It -Times 1
      }
   }
}