Set-StrictMode -Version Latest

Describe 'VSTeamGitRepositoryPermission' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$baseFolder/Source/Public/Add-VSTeamAccessControlEntry.ps1"
   }

   Context 'Add-VSTeamGitRepositoryPermission' {
      ## Arrange
      BeforeAll {
         $projectResultObject = [vsteam_lib.Project]::new($(Open-SampleFile 'projectResult.json'))
         $userSingleResultObject = [vsteam_lib.User]::new($(Open-SampleFile 'users.single.json'))
         $groupSingleResultObject = [vsteam_lib.Group]::new($(Open-SampleFile 'groupsSingle.json'))

         # Set the account to use for testing. A normal user would do this
         # using the Set-VSTeamAccount function.
         Mock _getInstance { return 'https://dev.azure.com/test' }

         Mock Invoke-RestMethod { Open-SampleFile 'accessControlEntryResult.json' }

         # You have to set the version or the api-version will not be added when versions = ''
         Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Core' }
      }

      It 'by ProjectUser should return ACEs' {
         ## Act
         Add-VSTeamGitRepositoryPermission -Project $projectResultObject `
            -User $userSingleResultObject `
            -Allow ([vsteam_lib.GitRepositoryPermissions]'CreateRepository,RenameRepository,PullRequestBypassPolicy') `
            -Deny ([vsteam_lib.GitRepositoryPermissions]'EditPolicies,ForcePush')

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"repoV2/010d06f0-00d5-472a-bb47-58947c230876`",*" -and
            $Body -like "*`"descriptor`": `"Microsoft.IdentityModel.Claims.ClaimsIdentity;788df857-dcd8-444d-885e-bff359bc1982\\test@testuser.com`",*" -and
            $Body -like "*`"allow`": 34048,*" -and
            $Body -like "*`"deny`": 2056,*" -and
            $Method -eq "Post"
         }
      }

      It 'by ProjectGroup should return ACEs' {
         ## Act
         Add-VSTeamGitRepositoryPermission -Project $projectResultObject `
            -Group $groupSingleResultObject `
            -Allow ([vsteam_lib.GitRepositoryPermissions]'CreateRepository,RenameRepository,PullRequestBypassPolicy') `
            -Deny ([vsteam_lib.GitRepositoryPermissions]'EditPolicies,ForcePush')

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"repoV2/010d06f0-00d5-472a-bb47-58947c230876`",*" -and
            $Body -like "*`"descriptor`": `"Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1`",*" -and
            $Body -like "*`"allow`": 34048,*" -and
            $Body -like "*`"deny`": 2056,*" -and
            $Method -eq "Post"
         }
      }

      It 'by ProjectDescriptor should return ACEs' {
         ## Act
         # The S-1-9 number is on digit off from the calls above so the same mock can be used
         # as above with the exactly 1 parameter. If you don't use different S-1-9 the count
         # of calls will be off.
         Add-VSTeamGitRepositoryPermission -Project $projectResultObject `
            -Descriptor "Microsoft.TeamFoundation.Identity;S-1-9-2551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1" `
            -Allow ([vsteam_lib.GitRepositoryPermissions]'CreateRepository,RenameRepository,PullRequestBypassPolicy') `
            -Deny ([vsteam_lib.GitRepositoryPermissions]'EditPolicies,ForcePush')

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"repoV2/010d06f0-00d5-472a-bb47-58947c230876`",*" -and
            $Body -like "*`"descriptor`": `"Microsoft.TeamFoundation.Identity;S-1-9-2551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1`",*" -and
            $Body -like "*`"allow`": 34048,*" -and
            $Body -like "*`"deny`": 2056,*" -and
            $Method -eq "Post"
         }
      }

      It 'by RepositoryUser should return ACEs' {
         ## Act
         Add-VSTeamGitRepositoryPermission -Project $projectResultObject `
            -RepositoryId "12345678-1234-1234-1234-123456789012" `
            -User $userSingleResultObject `
            -Allow ([vsteam_lib.GitRepositoryPermissions]'CreateRepository,RenameRepository,PullRequestBypassPolicy') `
            -Deny ([vsteam_lib.GitRepositoryPermissions]'EditPolicies,ForcePush')

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"repoV2/010d06f0-00d5-472a-bb47-58947c230876/12345678-1234-1234-1234-123456789012`",*" -and
            $Body -like "*`"descriptor`": `"Microsoft.IdentityModel.Claims.ClaimsIdentity;788df857-dcd8-444d-885e-bff359bc1982\\test@testuser.com`",*" -and
            $Body -like "*`"allow`": 34048,*" -and
            $Body -like "*`"deny`": 2056,*" -and
            $Method -eq "Post"
         }
      }

      It 'by RepositoryGroup should return ACEs' {
         ## Act
         Add-VSTeamGitRepositoryPermission -Project $projectResultObject `
            -RepositoryId "12345678-1234-1234-1234-123456789012" `
            -Group $groupSingleResultObject `
            -Allow ([vsteam_lib.GitRepositoryPermissions]'CreateRepository,RenameRepository,PullRequestBypassPolicy') `
            -Deny ([vsteam_lib.GitRepositoryPermissions]'EditPolicies,ForcePush')

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"repoV2/010d06f0-00d5-472a-bb47-58947c230876/12345678-1234-1234-1234-123456789012`",*" -and
            $Body -like "*`"descriptor`": `"Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1`",*" -and
            $Body -like "*`"allow`": 34048,*" -and
            $Body -like "*`"deny`": 2056,*" -and
            $Method -eq "Post"
         }
      }

      It 'by RepositoryDescriptor should return ACEs' {
         ## Act
         Add-VSTeamGitRepositoryPermission -Project $projectResultObject `
            -RepositoryId "12345678-1234-1234-1234-123456789013" `
            -Descriptor "Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1" `
            -Allow ([vsteam_lib.GitRepositoryPermissions]'CreateRepository,RenameRepository,PullRequestBypassPolicy') `
            -Deny ([vsteam_lib.GitRepositoryPermissions]'EditPolicies,ForcePush')

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"repoV2/010d06f0-00d5-472a-bb47-58947c230876/12345678-1234-1234-1234-123456789013`",*" -and
            $Body -like "*`"descriptor`": `"Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1`",*" -and
            $Body -like "*`"allow`": 34048,*" -and
            $Body -like "*`"deny`": 2056,*" -and
            $Method -eq "Post"
         }
      }

      It 'by RepositoryBranchUser should return ACEs' {
         ## Act
         Add-VSTeamGitRepositoryPermission -Project $projectResultObject `
            -RepositoryId "12345678-1234-1234-1234-123456789012" `
            -BranchName "trunk" `
            -User $userSingleResultObject `
            -Allow ([vsteam_lib.GitRepositoryPermissions]'CreateRepository,RenameRepository,PullRequestBypassPolicy') `
            -Deny ([vsteam_lib.GitRepositoryPermissions]'EditPolicies,ForcePush')

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"repoV2/010d06f0-00d5-472a-bb47-58947c230876/12345678-1234-1234-1234-123456789012/refs/heads/7400720075006e006b00`",*" -and
            $Body -like "*`"descriptor`": `"Microsoft.IdentityModel.Claims.ClaimsIdentity;788df857-dcd8-444d-885e-bff359bc1982\\test@testuser.com`",*" -and
            $Body -like "*`"allow`": 34048,*" -and
            $Body -like "*`"deny`": 2056,*" -and
            $Method -eq "Post"
         }
      }

      It 'by RepositoryBranchGroup should return ACEs' {
         ## Act
         Add-VSTeamGitRepositoryPermission -Project $projectResultObject `
            -RepositoryId "12345678-1234-1234-1234-123456789012" `
            -BranchName "trunk" `
            -Group $groupSingleResultObject `
            -Allow ([vsteam_lib.GitRepositoryPermissions]'CreateRepository,RenameRepository,PullRequestBypassPolicy') `
            -Deny ([vsteam_lib.GitRepositoryPermissions]'EditPolicies,ForcePush')

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"repoV2/010d06f0-00d5-472a-bb47-58947c230876/12345678-1234-1234-1234-123456789012/refs/heads/7400720075006e006b00`",*" -and
            $Body -like "*`"descriptor`": `"Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1`",*" -and
            $Body -like "*`"allow`": 34048,*" -and
            $Body -like "*`"deny`": 2056,*" -and
            $Method -eq "Post"
         }
      }

      It 'by RepositoryBranchDescriptor should return ACEs' {
         ## Act
         Add-VSTeamGitRepositoryPermission -Project $projectResultObject `
            -RepositoryId "12345678-1234-1234-1234-123456789015" `
            -BranchName "trunk" `
            -Descriptor "Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1" `
            -Allow ([vsteam_lib.GitRepositoryPermissions]'CreateRepository,RenameRepository,PullRequestBypassPolicy') `
            -Deny ([vsteam_lib.GitRepositoryPermissions]'EditPolicies,ForcePush')

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"repoV2/010d06f0-00d5-472a-bb47-58947c230876/12345678-1234-1234-1234-123456789015/refs/heads/7400720075006e006b00`",*" -and
            $Body -like "*`"descriptor`": `"Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1`",*" -and
            $Body -like "*`"allow`": 34048,*" -and
            $Body -like "*`"deny`": 2056,*" -and
            $Method -eq "Post"
         }
      }
   }
}