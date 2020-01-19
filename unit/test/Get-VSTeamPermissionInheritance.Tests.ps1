Set-StrictMode -Version Latest

Import-Module SHiPS

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Classes/VSTeamLeaf.ps1"
. "$here/../../Source/Classes/VSTeamSecurityNamespace.ps1"
. "$here/../../Source/Classes/VSTeamPermissionInheritance.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/Get-VSTeamProject.ps1"
. "$here/../../Source/Public/Get-VSTeamBuildDefinition.ps1"
. "$here/../../Source/Public/Get-VSTeamGitRepository.ps1"
. "$here/../../Source/Public/Get-VSTeamAccessControlList.ps1"
. "$here/../../Source/Public/$sut"

# Loading System.Web avoids issues finding System.Web.HttpUtility
Add-Type -AssemblyName 'System.Web'

[VSTeamVersions]::Account = 'https://dev.azure.com/test'

$buildDefHierarchyResults = Get-Content "$PSScriptRoot\sampleFiles\buildDefHierarchyQuery.json" -Raw | ConvertFrom-Json
$buildDefresults = Get-Content "$PSScriptRoot\sampleFiles\buildDefAzD.json" -Raw | ConvertFrom-Json
$gitRepoResult = Get-Content "$PSScriptRoot\sampleFiles\singleGitRepo.json" -Raw | ConvertFrom-Json
$accesscontrollistsResult = Get-Content "$PSScriptRoot\sampleFiles\repoAccesscontrollists.json" -Raw | ConvertFrom-Json

$singleResult = [PSCustomObject]@{
   name        = 'Project'
   description = ''
   url         = ''
   id          = '123-5464-dee43'
   state       = ''
   visibility  = ''
   revision    = 0
   defaultTeam = [PSCustomObject]@{}
   _links      = [PSCustomObject]@{}
}

Describe 'Get-VSTeamPermissionInheritance' {
   # Mock the call to Get-Projects by the dynamic parameter for ProjectName
   Mock Invoke-RestMethod { return @() } -ParameterFilter {
      $Uri -like "*_apis/projects*"
   }

   Context 'Get-VSTeamPermissionInheritance builddef' {
      Mock _useWindowsAuthenticationOnPremise { return $true }
      Mock Get-VSTeamProject { return $singleResult }
      Mock Get-VSTeamBuildDefinition { return $buildDefresults.value }
      Mock Invoke-RestMethod {
         # If this test fails uncomment the line below to see how the mock was called.
         # Write-Host $args
         # Write-Host $([VSTeamVersions]::Build)

         return $buildDefHierarchyResults
      }

      It 'should return build definitions' {
         Get-VSTeamPermissionInheritance -projectName project -Name dynamTest-Docker-CI -resourceType BuildDefinition

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Post' -and
            $Body -like '*123-5464-dee43/1432*' -and
            $Body -like '*33344d9c-fc72-4d6f-aba5-fa317101a7e9*' -and
            $Uri -like "*https://dev.azure.com/test/_apis/Contribution/HierarchyQuery/project/123-5464-dee43*" -and
            $Uri -like "*api-version=$([VSTeamVersions]::Build)*"
         }
      }
   }

   Context 'Get-VSTeamPermissionInheritance repository' {
      Mock _useWindowsAuthenticationOnPremise { return $true }
      Mock Get-VSTeamProject { return $singleResult }
      Mock Get-VSTeamGitRepository { return $gitRepoResult }
      Mock Get-VSTeamAccessControlList { return $accesscontrollistsResult.value } -Verifiable

      It 'should return build definitions' {
         Get-VSTeamPermissionInheritance -projectName project -Name project -resourceType Repository | Should be $true

         Assert-MockCalled Get-VSTeamAccessControlList -Exactly -Scope It -Times 1
      }
   }
}