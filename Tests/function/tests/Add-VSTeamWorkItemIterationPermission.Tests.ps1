Set-StrictMode -Version Latest

Describe 'VSTeamWorkItemIterationPermission' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$baseFolder/Source/Public/Get-VSTeamClassificationNode.ps1"
      . "$baseFolder/Source/Public/Add-VSTeamAccessControlEntry.ps1"

      ## Arrange
      $userSingleResultObject = [vsteam_lib.User]::new($(Open-SampleFile 'users.single.json'))
      $groupSingleResultObject = [vsteam_lib.Group]::new($(Open-SampleFile 'groupsSingle.json'))
      $projectResultObject = [vsteam_lib.Project]::new($(Open-SampleFile 'Get-VSTeamProject-NamePeopleTracker.json'))

      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' }

      # You have to set the version or the api-version will not be added when versions = ''
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Core' }
   }

   Context 'Add-VSTeamWorkItemIterationPermission' {
      BeforeAll {
         ## Arrange
         $classificationNodeIterationId = Open-SampleFile 'Get-VSTeamClassificationNode-Depth0-Ids20.json' -ReturnValue
         $iterationRootNode = Open-SampleFile 'Get-VSTeamClassificationNode-depth3-ids16.json'

         Mock Get-VSTeamClassificationNode { return [vsteam_lib.ClassificationNode]::new($iterationRootNode, "test") }
         Mock Get-VSTeamClassificationNode { return [vsteam_lib.ClassificationNode]::new($classificationNodeIterationId, "test") } -ParameterFilter { $Id -eq 44 -or $Path -eq "Sprint 1" }

         Mock Invoke-RestMethod { Open-SampleFile 'accessControlEntryResult.json' }
      }

      It 'by IterationID and User should return ACEs' {
         ## Act
         Add-VSTeamWorkItemIterationPermission -Project $projectResultObject `
            -IterationID 44 `
            -User $userSingleResultObject `
            -Allow ([vsteam_lib.WorkItemIterationPermissions]'GENERIC_READ,CREATE_CHILDREN') `
            -Deny ([vsteam_lib.WorkItemIterationPermissions]'DELETE')

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/bf7bfa03-b2b7-47db-8113-fa2e002cc5b1*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"vstfs:///Classification/Node/dfa90792-403a-4119-a52b-bd142c08291b:vstfs:///Classification/Node/18e7998d-d0c5-4c01-b547-d7d4eb4c97c5`",*" -and
            $Body -like "*`"descriptor`": `"Microsoft.IdentityModel.Claims.ClaimsIdentity;788df857-dcd8-444d-885e-bff359bc1982\\test@testuser.com`",*" -and
            $Body -like "*`"allow`": 5,*" -and
            $Body -like "*`"deny`": 8,*" -and
            $Method -eq "Post"
         }
      }

      It 'by IterationID and Group should return ACEs' {
         ## Act
         Add-VSTeamWorkItemIterationPermission -Project $projectResultObject `
            -IterationID 44 `
            -Group $groupSingleResultObject `
            -Allow ([vsteam_lib.WorkItemIterationPermissions]'GENERIC_READ,CREATE_CHILDREN') `
            -Deny ([vsteam_lib.WorkItemIterationPermissions]'DELETE')

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/bf7bfa03-b2b7-47db-8113-fa2e002cc5b1*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"vstfs:///Classification/Node/dfa90792-403a-4119-a52b-bd142c08291b:vstfs:///Classification/Node/18e7998d-d0c5-4c01-b547-d7d4eb4c97c5`",*" -and
            $Body -like "*`"descriptor`": `"Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1`",*" -and
            $Body -like "*`"allow`": 5,*" -and
            $Body -like "*`"deny`": 8,*" -and
            $Method -eq "Post"
         }
      }

      It 'by IterationID and Descriptor should return ACEs' {
         ## Act
         Add-VSTeamWorkItemIterationPermission -Project $projectResultObject `
            -IterationID 44 `
            -Descriptor "Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1" `
            -Allow ([vsteam_lib.WorkItemIterationPermissions]'GENERIC_READ,CREATE_CHILDREN') `
            -Deny ([vsteam_lib.WorkItemIterationPermissions]'DELETE')

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/bf7bfa03-b2b7-47db-8113-fa2e002cc5b1*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"vstfs:///Classification/Node/dfa90792-403a-4119-a52b-bd142c08291b:vstfs:///Classification/Node/18e7998d-d0c5-4c01-b547-d7d4eb4c97c5`",*" -and
            $Body -like "*`"descriptor`": `"Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1`",*" -and
            $Body -like "*`"allow`": 5,*" -and
            $Body -like "*`"deny`": 8,*" -and
            $Method -eq "Post"
         }
      }

      It 'by IterationPath and User should return ACEs' {
         ## Act
         Add-VSTeamWorkItemIterationPermission -Project $projectResultObject `
            -IterationPath "Sprint 1" `
            -User $userSingleResultObject `
            -Allow ([vsteam_lib.WorkItemIterationPermissions]'GENERIC_READ,CREATE_CHILDREN') `
            -Deny ([vsteam_lib.WorkItemIterationPermissions]'DELETE')

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/bf7bfa03-b2b7-47db-8113-fa2e002cc5b1*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"vstfs:///Classification/Node/dfa90792-403a-4119-a52b-bd142c08291b:vstfs:///Classification/Node/18e7998d-d0c5-4c01-b547-d7d4eb4c97c5`",*" -and
            $Body -like "*`"descriptor`": `"Microsoft.IdentityModel.Claims.ClaimsIdentity;788df857-dcd8-444d-885e-bff359bc1982\\test@testuser.com`",*" -and
            $Body -like "*`"allow`": 5,*" -and
            $Body -like "*`"deny`": 8,*" -and
            $Method -eq "Post"
         }
      }

      It 'by IterationPath and Group should return ACEs' {
         ## Act
         Add-VSTeamWorkItemIterationPermission -Project $projectResultObject `
            -IterationPath "Sprint 1" `
            -Group $groupSingleResultObject `
            -Allow ([vsteam_lib.WorkItemIterationPermissions]'GENERIC_READ,CREATE_CHILDREN') `
            -Deny ([vsteam_lib.WorkItemIterationPermissions]'DELETE')

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/bf7bfa03-b2b7-47db-8113-fa2e002cc5b1*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"vstfs:///Classification/Node/dfa90792-403a-4119-a52b-bd142c08291b:vstfs:///Classification/Node/18e7998d-d0c5-4c01-b547-d7d4eb4c97c5`",*" -and
            $Body -like "*`"descriptor`": `"Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1`",*" -and
            $Body -like "*`"allow`": 5,*" -and
            $Body -like "*`"deny`": 8,*" -and
            $Method -eq "Post"
         }
      }

      It 'by IterationPath and Descriptor should return ACEs' {
         ## Act
         Add-VSTeamWorkItemIterationPermission -Project $projectResultObject `
            -IterationPath "Sprint 1" `
            -Descriptor "Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1" `
            -Allow ([vsteam_lib.WorkItemIterationPermissions]'GENERIC_READ,CREATE_CHILDREN') `
            -Deny ([vsteam_lib.WorkItemIterationPermissions]'DELETE')

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/bf7bfa03-b2b7-47db-8113-fa2e002cc5b1*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"vstfs:///Classification/Node/dfa90792-403a-4119-a52b-bd142c08291b:vstfs:///Classification/Node/18e7998d-d0c5-4c01-b547-d7d4eb4c97c5`",*" -and
            $Body -like "*`"descriptor`": `"Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1`",*" -and
            $Body -like "*`"allow`": 5,*" -and
            $Body -like "*`"deny`": 8,*" -and
            $Method -eq "Post"
         }
      }
   }
}