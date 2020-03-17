Set-StrictMode -Version Latest

$env:Testing=$true
InModuleScope VSTeam {
   $userSingleResult = Get-Content "$PSScriptRoot\sampleFiles\users.single.json" -Raw | ConvertFrom-Json
   $userSingleResultObject = [VSTeamUser]::new($userSingleResult)

   $groupSingleResult = Get-Content "$PSScriptRoot\sampleFiles\groupsSingle.json" -Raw | ConvertFrom-Json
   $groupSingleResultObject = [VSTeamGroup]::new($groupSingleResult)

   $projectResult = [PSCustomObject]@{
      name        = 'Test Project Public'
      description = ''
      url         = ''
      id          = '010d06f0-00d5-472a-bb47-58947c230876'
      state       = ''
      visibility  = ''
      revision    = 0
      defaultTeam = [PSCustomObject]@{}
      _links      = [PSCustomObject]@{}
   }

   $projectResultObject = [VSTeamProject]::new($projectResult)

   $accessControlEntryResult =
   @"
{
   "count": 1,
   "value": [
     {
       "descriptor": "Microsoft.TeamFoundation.Identity;S-1-9-1551374245-1204400969-2402986413-2179408616-0-0-0-0-1",
       "allow": 8,
       "deny": 0,
       "extendedInfo": {}
     }
   ]
}
"@ | ConvertFrom-Json

   Describe 'GitRepositoryPermissions VSTS' {
      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable
   
      # You have to set the version or the api-version will not be added when
      # [VSTeamVersions]::Core = ''
      [VSTeamVersions]::Core = '5.0'

      Context 'Add-VSTeamGitRepositoryPermission by ProjectUser' {
         Mock Invoke-RestMethod {
            # If this test fails uncomment the line below to see how the mock was called.
            # Write-Host $args

            return $accessControlEntryResult
         } -Verifiable

         Add-VSTeamGitRepositoryPermission -Project $projectResultObject -User $userSingleResultObject -Allow ([VSTeamGitRepositoryPermissions]'CreateRepository,RenameRepository,PullRequestBypassPolicy') -Deny ([VSTeamGitRepositoryPermissions]'EditPolicies,ForcePush')

         It 'Should return ACEs' {
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
               $Body -like "*`"token`": `"repoV2/010d06f0-00d5-472a-bb47-58947c230876`",*" -and
               $Body -like "*`"descriptor`": `"Microsoft.IdentityModel.Claims.ClaimsIdentity;788df857-dcd8-444d-885e-bff359bc1982\\test@testuser.com`",*" -and
               $Body -like "*`"allow`": 34048,*" -and
               $Body -like "*`"deny`": 2056,*" -and
               $ContentType -eq "application/json" -and
               $Method -eq "Post"
            }
         }
      }

      Context 'Add-VSTeamGitRepositoryPermission by ProjectGroup' {
         Mock Invoke-RestMethod { return $accessControlEntryResult } -Verifiable

         Add-VSTeamGitRepositoryPermission -Project $projectResultObject -Group $groupSingleResultObject -Allow ([VSTeamGitRepositoryPermissions]'CreateRepository,RenameRepository,PullRequestBypassPolicy') -Deny ([VSTeamGitRepositoryPermissions]'EditPolicies,ForcePush')

         It 'Should return ACEs' {
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
               $Body -like "*`"token`": `"repoV2/010d06f0-00d5-472a-bb47-58947c230876`",*" -and
               $Body -like "*`"descriptor`": `"Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1`",*" -and
               $Body -like "*`"allow`": 34048,*" -and
               $Body -like "*`"deny`": 2056,*" -and
               $ContentType -eq "application/json" -and
               $Method -eq "Post"
            }
         }
      }

      Context 'Add-VSTeamGitRepositoryPermission by ProjectDescriptor' {
         Mock Invoke-RestMethod { return $accessControlEntryResult } -Verifiable

         Add-VSTeamGitRepositoryPermission -Project $projectResultObject -Descriptor "Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1" -Allow ([VSTeamGitRepositoryPermissions]'CreateRepository,RenameRepository,PullRequestBypassPolicy') -Deny ([VSTeamGitRepositoryPermissions]'EditPolicies,ForcePush')

         It 'Should return ACEs' {
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
               $Body -like "*`"token`": `"repoV2/010d06f0-00d5-472a-bb47-58947c230876`",*" -and
               $Body -like "*`"descriptor`": `"Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1`",*" -and
               $Body -like "*`"allow`": 34048,*" -and
               $Body -like "*`"deny`": 2056,*" -and
               $ContentType -eq "application/json" -and
               $Method -eq "Post"
            }
         }
      }

      Context 'Add-VSTeamGitRepositoryPermission by RepositoryUser' {
         Mock Invoke-RestMethod { return $accessControlEntryResult } -Verifiable

         Add-VSTeamGitRepositoryPermission -Project $projectResultObject -RepositoryId "12345678-1234-1234-1234-123456789012" -User $userSingleResultObject -Allow ([VSTeamGitRepositoryPermissions]'CreateRepository,RenameRepository,PullRequestBypassPolicy') -Deny ([VSTeamGitRepositoryPermissions]'EditPolicies,ForcePush')

         It 'Should return ACEs' {
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
               $Body -like "*`"token`": `"repoV2/010d06f0-00d5-472a-bb47-58947c230876/12345678-1234-1234-1234-123456789012`",*" -and
               $Body -like "*`"descriptor`": `"Microsoft.IdentityModel.Claims.ClaimsIdentity;788df857-dcd8-444d-885e-bff359bc1982\\test@testuser.com`",*" -and
               $Body -like "*`"allow`": 34048,*" -and
               $Body -like "*`"deny`": 2056,*" -and
               $ContentType -eq "application/json" -and
               $Method -eq "Post"
            }
         }
      }

      Context 'Add-VSTeamGitRepositoryPermission by RepositoryGroup' {
         Mock Invoke-RestMethod { return $accessControlEntryResult } -Verifiable

         Add-VSTeamGitRepositoryPermission -Project $projectResultObject -RepositoryId "12345678-1234-1234-1234-123456789012" -Group $groupSingleResultObject -Allow ([VSTeamGitRepositoryPermissions]'CreateRepository,RenameRepository,PullRequestBypassPolicy') -Deny ([VSTeamGitRepositoryPermissions]'EditPolicies,ForcePush')

         It 'Should return ACEs' {
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
               $Body -like "*`"token`": `"repoV2/010d06f0-00d5-472a-bb47-58947c230876/12345678-1234-1234-1234-123456789012`",*" -and
               $Body -like "*`"descriptor`": `"Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1`",*" -and
               $Body -like "*`"allow`": 34048,*" -and
               $Body -like "*`"deny`": 2056,*" -and
               $ContentType -eq "application/json" -and
               $Method -eq "Post"
            }
         }
      }

      Context 'Add-VSTeamGitRepositoryPermission by RepositoryDescriptor' {
         Mock Invoke-RestMethod { return $accessControlEntryResult } -Verifiable

         Add-VSTeamGitRepositoryPermission -Project $projectResultObject -RepositoryId "12345678-1234-1234-1234-123456789012" -Descriptor "Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1" -Allow ([VSTeamGitRepositoryPermissions]'CreateRepository,RenameRepository,PullRequestBypassPolicy') -Deny ([VSTeamGitRepositoryPermissions]'EditPolicies,ForcePush')

         It 'Should return ACEs' {
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
               $Body -like "*`"token`": `"repoV2/010d06f0-00d5-472a-bb47-58947c230876/12345678-1234-1234-1234-123456789012`",*" -and
               $Body -like "*`"descriptor`": `"Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1`",*" -and
               $Body -like "*`"allow`": 34048,*" -and
               $Body -like "*`"deny`": 2056,*" -and
               $ContentType -eq "application/json" -and
               $Method -eq "Post"
            }
         }
      }

      Context 'Add-VSTeamGitRepositoryPermission by RepositoryBranchUser' {
         Mock Invoke-RestMethod { return $accessControlEntryResult } -Verifiable

         Add-VSTeamGitRepositoryPermission -Project $projectResultObject -RepositoryId "12345678-1234-1234-1234-123456789012" -BranchName "master" -User $userSingleResultObject -Allow ([VSTeamGitRepositoryPermissions]'CreateRepository,RenameRepository,PullRequestBypassPolicy') -Deny ([VSTeamGitRepositoryPermissions]'EditPolicies,ForcePush')

         It 'Should return ACEs' {
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
               $Body -like "*`"token`": `"repoV2/010d06f0-00d5-472a-bb47-58947c230876/12345678-1234-1234-1234-123456789012/refs/heads/6d0061007300740065007200`",*" -and
               $Body -like "*`"descriptor`": `"Microsoft.IdentityModel.Claims.ClaimsIdentity;788df857-dcd8-444d-885e-bff359bc1982\\test@testuser.com`",*" -and
               $Body -like "*`"allow`": 34048,*" -and
               $Body -like "*`"deny`": 2056,*" -and
               $ContentType -eq "application/json" -and
               $Method -eq "Post"
            }
         }
      }

      Context 'Add-VSTeamGitRepositoryPermission by RepositoryBranchGroup' {
         Mock Invoke-RestMethod { return $accessControlEntryResult } -Verifiable

         Add-VSTeamGitRepositoryPermission -Project $projectResultObject -RepositoryId "12345678-1234-1234-1234-123456789012" -BranchName "master" -Group $groupSingleResultObject -Allow ([VSTeamGitRepositoryPermissions]'CreateRepository,RenameRepository,PullRequestBypassPolicy') -Deny ([VSTeamGitRepositoryPermissions]'EditPolicies,ForcePush')

         It 'Should return ACEs' {
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
               $Body -like "*`"token`": `"repoV2/010d06f0-00d5-472a-bb47-58947c230876/12345678-1234-1234-1234-123456789012/refs/heads/6d0061007300740065007200`",*" -and
               $Body -like "*`"descriptor`": `"Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1`",*" -and
               $Body -like "*`"allow`": 34048,*" -and
               $Body -like "*`"deny`": 2056,*" -and
               $ContentType -eq "application/json" -and
               $Method -eq "Post"
            }
         }
      }

      Context 'Add-VSTeamGitRepositoryPermission by RepositoryBranchDescriptor' {
         Mock Invoke-RestMethod { return $accessControlEntryResult } -Verifiable

         Add-VSTeamGitRepositoryPermission -Project $projectResultObject -RepositoryId "12345678-1234-1234-1234-123456789012" -BranchName "master" -Descriptor "Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1" -Allow ([VSTeamGitRepositoryPermissions]'CreateRepository,RenameRepository,PullRequestBypassPolicy') -Deny ([VSTeamGitRepositoryPermissions]'EditPolicies,ForcePush')

         It 'Should return ACEs' {
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
               $Body -like "*`"token`": `"repoV2/010d06f0-00d5-472a-bb47-58947c230876/12345678-1234-1234-1234-123456789012/refs/heads/6d0061007300740065007200`",*" -and
               $Body -like "*`"descriptor`": `"Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1`",*" -and
               $Body -like "*`"allow`": 34048,*" -and
               $Body -like "*`"deny`": 2056,*" -and
               $ContentType -eq "application/json" -and
               $Method -eq "Post"
            }
         }
      }

      Context 'Add-VSTeamGitRepositoryPermission by Project throws' {
         Mock Invoke-RestMethod { throw 'Error' }

         It 'Should throw' {
            { Add-VSTeamGitRepositoryPermission -Project $projectResultObject -RepositoryId "12345678-1234-1234-1234-123456789012" -User $userSingleResultObject -Allow ([VSTeamGitRepositoryPermissions]'CreateRepository,RenameRepository,PullRequestBypassPolicy') -Deny ([VSTeamGitRepositoryPermissions]'EditPolicies,ForcePush')  } | Should Throw
         }
      }
   }
}