Set-StrictMode -Version Latest

Describe 'VSTeamGitRepositoryPermission' {
   BeforeAll {
      Import-Module SHiPS

      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamLeaf.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamDirectory.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamRepositories.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamTask.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamAttempt.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamEnvironment.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamUserEntitlement.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamRelease.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamReleases.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamTeams.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamReleaseDefinitions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamQueues.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamBuild.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamBuilds.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamBuildDefinitions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProject.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamGroup.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamUser.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamSecurityNamespace.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamAccessControlEntry.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamGitRepositoryPermissions.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/Add-VSTeamAccessControlEntry.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"
   }

   Context 'Add-VSTeamGitRepositoryPermission' {
      ## Arrange
      BeforeAll {
         $userSingleResult = Get-Content "$PSScriptRoot\sampleFiles\users.single.json" -Raw | ConvertFrom-Json
         $userSingleResultObject = [VSTeamUser]::new($userSingleResult)

         $groupSingleResult = Get-Content "$PSScriptRoot\sampleFiles\groupsSingle.json" -Raw | ConvertFrom-Json
         $groupSingleResultObject = [VSTeamGroup]::new($groupSingleResult)

         $projectResult = Get-Content "$PSScriptRoot\sampleFiles\projectResult.json" -Raw | ConvertFrom-Json
         $projectResultObject = [VSTeamProject]::new($projectResult)

         $accessControlEntryResult = Get-Content "$PSScriptRoot\sampleFiles\accessControlEntryResult.json" -Raw | ConvertFrom-Json

         # Set the account to use for testing. A normal user would do this
         # using the Set-VSTeamAccount function.
         Mock _getInstance { return 'https://dev.azure.com/test' }

         # You have to set the version or the api-version will not be added when versions = ''
         Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Core' }

         Mock Invoke-RestMethod {
            # If this test fails uncomment the line below to see how the mock was called.
            # Write-Host $args

            return $accessControlEntryResult
         } -Verifiable
      }

      It 'by ProjectUser should return ACEs' {
         ## Act
         Add-VSTeamGitRepositoryPermission -Project $projectResultObject -User $userSingleResultObject -Allow ([VSTeamGitRepositoryPermissions]'CreateRepository,RenameRepository,PullRequestBypassPolicy') -Deny ([VSTeamGitRepositoryPermissions]'EditPolicies,ForcePush')

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"repoV2/010d06f0-00d5-472a-bb47-58947c230876`",*" -and
            $Body -like "*`"descriptor`": `"Microsoft.IdentityModel.Claims.ClaimsIdentity;788df857-dcd8-444d-885e-bff359bc1982\\test@testuser.com`",*" -and
            $Body -like "*`"allow`": 34048,*" -and
            $Body -like "*`"deny`": 2056,*" -and
            $ContentType -eq "application/json" -and
            $Method -eq "Post"
         }
      }

      It 'by ProjectGroup should return ACEs' {
         ## Act
         Add-VSTeamGitRepositoryPermission -Project $projectResultObject -Group $groupSingleResultObject -Allow ([VSTeamGitRepositoryPermissions]'CreateRepository,RenameRepository,PullRequestBypassPolicy') -Deny ([VSTeamGitRepositoryPermissions]'EditPolicies,ForcePush')

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"repoV2/010d06f0-00d5-472a-bb47-58947c230876`",*" -and
            $Body -like "*`"descriptor`": `"Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1`",*" -and
            $Body -like "*`"allow`": 34048,*" -and
            $Body -like "*`"deny`": 2056,*" -and
            $ContentType -eq "application/json" -and
            $Method -eq "Post"
         }
      }

      It 'by ProjectDescriptor should return ACEs' {
         ## Act
         # The S-1-9 number is on digit off from the calls above so the same mock can be used
         # as above with the exactly 1 parameter. If you don't use different S-1-9 the count
         # of calls will be off.
         Add-VSTeamGitRepositoryPermission -Project $projectResultObject -Descriptor "Microsoft.TeamFoundation.Identity;S-1-9-2551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1" -Allow ([VSTeamGitRepositoryPermissions]'CreateRepository,RenameRepository,PullRequestBypassPolicy') -Deny ([VSTeamGitRepositoryPermissions]'EditPolicies,ForcePush')

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"repoV2/010d06f0-00d5-472a-bb47-58947c230876`",*" -and
            $Body -like "*`"descriptor`": `"Microsoft.TeamFoundation.Identity;S-1-9-2551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1`",*" -and
            $Body -like "*`"allow`": 34048,*" -and
            $Body -like "*`"deny`": 2056,*" -and
            $ContentType -eq "application/json" -and
            $Method -eq "Post"
         }
      }

      It 'by RepositoryUser should return ACEs' {
         ## Act
         Add-VSTeamGitRepositoryPermission -Project $projectResultObject -RepositoryId "12345678-1234-1234-1234-123456789012" -User $userSingleResultObject -Allow ([VSTeamGitRepositoryPermissions]'CreateRepository,RenameRepository,PullRequestBypassPolicy') -Deny ([VSTeamGitRepositoryPermissions]'EditPolicies,ForcePush')

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"repoV2/010d06f0-00d5-472a-bb47-58947c230876/12345678-1234-1234-1234-123456789012`",*" -and
            $Body -like "*`"descriptor`": `"Microsoft.IdentityModel.Claims.ClaimsIdentity;788df857-dcd8-444d-885e-bff359bc1982\\test@testuser.com`",*" -and
            $Body -like "*`"allow`": 34048,*" -and
            $Body -like "*`"deny`": 2056,*" -and
            $ContentType -eq "application/json" -and
            $Method -eq "Post"
         }
      }

      It 'by RepositoryGroup should return ACEs' {
         ## Act
         Add-VSTeamGitRepositoryPermission -Project $projectResultObject -RepositoryId "12345678-1234-1234-1234-123456789012" -Group $groupSingleResultObject -Allow ([VSTeamGitRepositoryPermissions]'CreateRepository,RenameRepository,PullRequestBypassPolicy') -Deny ([VSTeamGitRepositoryPermissions]'EditPolicies,ForcePush')

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"repoV2/010d06f0-00d5-472a-bb47-58947c230876/12345678-1234-1234-1234-123456789012`",*" -and
            $Body -like "*`"descriptor`": `"Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1`",*" -and
            $Body -like "*`"allow`": 34048,*" -and
            $Body -like "*`"deny`": 2056,*" -and
            $ContentType -eq "application/json" -and
            $Method -eq "Post"
         }
      }

      It 'by RepositoryDescriptor should return ACEs' {
         ## Act
         Add-VSTeamGitRepositoryPermission -Project $projectResultObject -RepositoryId "12345678-1234-1234-1234-123456789013" -Descriptor "Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1" -Allow ([VSTeamGitRepositoryPermissions]'CreateRepository,RenameRepository,PullRequestBypassPolicy') -Deny ([VSTeamGitRepositoryPermissions]'EditPolicies,ForcePush')

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"repoV2/010d06f0-00d5-472a-bb47-58947c230876/12345678-1234-1234-1234-123456789013`",*" -and
            $Body -like "*`"descriptor`": `"Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1`",*" -and
            $Body -like "*`"allow`": 34048,*" -and
            $Body -like "*`"deny`": 2056,*" -and
            $ContentType -eq "application/json" -and
            $Method -eq "Post"
         }
      }

      It 'by RepositoryBranchUser should return ACEs' {
         ## Act
         Add-VSTeamGitRepositoryPermission -Project $projectResultObject -RepositoryId "12345678-1234-1234-1234-123456789012" -BranchName "master" -User $userSingleResultObject -Allow ([VSTeamGitRepositoryPermissions]'CreateRepository,RenameRepository,PullRequestBypassPolicy') -Deny ([VSTeamGitRepositoryPermissions]'EditPolicies,ForcePush')

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"repoV2/010d06f0-00d5-472a-bb47-58947c230876/12345678-1234-1234-1234-123456789012/refs/heads/6d0061007300740065007200`",*" -and
            $Body -like "*`"descriptor`": `"Microsoft.IdentityModel.Claims.ClaimsIdentity;788df857-dcd8-444d-885e-bff359bc1982\\test@testuser.com`",*" -and
            $Body -like "*`"allow`": 34048,*" -and
            $Body -like "*`"deny`": 2056,*" -and
            $ContentType -eq "application/json" -and
            $Method -eq "Post"
         }
      }

      It 'by RepositoryBranchGroup should return ACEs' {
         ## Act
         Add-VSTeamGitRepositoryPermission -Project $projectResultObject -RepositoryId "12345678-1234-1234-1234-123456789012" -BranchName "master" -Group $groupSingleResultObject -Allow ([VSTeamGitRepositoryPermissions]'CreateRepository,RenameRepository,PullRequestBypassPolicy') -Deny ([VSTeamGitRepositoryPermissions]'EditPolicies,ForcePush')

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"repoV2/010d06f0-00d5-472a-bb47-58947c230876/12345678-1234-1234-1234-123456789012/refs/heads/6d0061007300740065007200`",*" -and
            $Body -like "*`"descriptor`": `"Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1`",*" -and
            $Body -like "*`"allow`": 34048,*" -and
            $Body -like "*`"deny`": 2056,*" -and
            $ContentType -eq "application/json" -and
            $Method -eq "Post"
         }
      }

      It 'by RepositoryBranchDescriptor should return ACEs' {
         ## Act
         Add-VSTeamGitRepositoryPermission -Project $projectResultObject -RepositoryId "12345678-1234-1234-1234-123456789015" -BranchName "master" -Descriptor "Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1" -Allow ([VSTeamGitRepositoryPermissions]'CreateRepository,RenameRepository,PullRequestBypassPolicy') -Deny ([VSTeamGitRepositoryPermissions]'EditPolicies,ForcePush')

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"repoV2/010d06f0-00d5-472a-bb47-58947c230876/12345678-1234-1234-1234-123456789015/refs/heads/6d0061007300740065007200`",*" -and
            $Body -like "*`"descriptor`": `"Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1`",*" -and
            $Body -like "*`"allow`": 34048,*" -and
            $Body -like "*`"deny`": 2056,*" -and
            $ContentType -eq "application/json" -and
            $Method -eq "Post"
         }
      }
   }
}