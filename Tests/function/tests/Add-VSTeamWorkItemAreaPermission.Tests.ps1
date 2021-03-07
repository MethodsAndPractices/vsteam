Set-StrictMode -Version Latest

Describe 'VSTeamWorkItemAreaPermission' {
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

   Context 'Add-VSTeamWorkItemAreaPermission' {
      BeforeAll {
         ## Arrange
         $areaRootNode = Open-SampleFile 'Get-VSTeamClassificationNode-Depth0-Ids24.json' -Index 0
         $classificationNodeById = Open-SampleFile 'Get-VSTeamClassificationNode-Depth0-Ids85.json' -ReturnValue
         $parentClassificationNode = Open-SampleFile 'Get-VSTeamClassificationNode-Depth0-Ids43.json' -ReturnValue

         Mock Get-VSTeamClassificationNode { return [vsteam_lib.ClassificationNode]::new($areaRootNode, "test") }
         Mock Get-VSTeamClassificationNode { return [vsteam_lib.ClassificationNode]::new($parentClassificationNode, "test") } -ParameterFilter { $Path -eq "Child%201%20Level%201" }
         Mock Get-VSTeamClassificationNode { return [vsteam_lib.ClassificationNode]::new($classificationNodeById, "test") } -ParameterFilter { $Id -eq 85 -or $Path -eq "Child 1 Level 1/Child 1 Level 2" }

         Mock Invoke-RestMethod { Open-SampleFile 'accessControlEntryResult.json' }
      }

      It 'by AreaID and User should return ACEs' {
         ## Act
         Add-VSTeamWorkItemAreaPermission -Project $projectResultObject `
            -AreaID 85 `
            -User $userSingleResultObject `
            -Allow ([vsteam_lib.WorkItemAreaPermissions]'GENERIC_READ,MANAGE_TEST_PLANS') `
            -Deny ([vsteam_lib.WorkItemAreaPermissions]'GENERIC_WRITE,DELETE')

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/83e28ad4-2d72-4ceb-97b0-c7726d5502c3*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"vstfs:///Classification/Node/b33b12d7-6abb-4b7a-b9d6-2092d0933c99:vstfs:///Classification/Node/38de1ce0-0b1b-45f2-b4f9-f32e3a72b78b:vstfs:///Classification/Node/90aa2c42-de51-450a-bfb6-6e264e364d9a`",*" -and
            $Body -like "*`"descriptor`": `"Microsoft.IdentityModel.Claims.ClaimsIdentity;788df857-dcd8-444d-885e-bff359bc1982\\test@testuser.com`",*" -and
            $Body -like "*`"allow`": 65,*" -and
            $Body -like "*`"deny`": 10,*" -and
            $Method -eq "Post"
         }
      }

      It 'by AreaID and Group should return ACEs' {
         ## Act
         Add-VSTeamWorkItemAreaPermission -Project $projectResultObject `
            -AreaID 85 `
            -Group $groupSingleResultObject `
            -Allow ([vsteam_lib.WorkItemAreaPermissions]'GENERIC_READ,MANAGE_TEST_PLANS') `
            -Deny ([vsteam_lib.WorkItemAreaPermissions]'GENERIC_WRITE,DELETE')

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/83e28ad4-2d72-4ceb-97b0-c7726d5502c3*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"vstfs:///Classification/Node/b33b12d7-6abb-4b7a-b9d6-2092d0933c99:vstfs:///Classification/Node/38de1ce0-0b1b-45f2-b4f9-f32e3a72b78b:vstfs:///Classification/Node/90aa2c42-de51-450a-bfb6-6e264e364d9a`",*" -and
            $Body -like "*`"descriptor`": `"Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1`",*" -and
            $Body -like "*`"allow`": 65,*" -and
            $Body -like "*`"deny`": 10,*" -and
            $Method -eq "Post"
         }
      }

      It 'by AreaID and Descriptor should return ACEs' {
         ## Act
         Add-VSTeamWorkItemAreaPermission -Project $projectResultObject `
            -AreaID 85 `
            -Descriptor "Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1" `
            -Allow ([vsteam_lib.WorkItemAreaPermissions]'GENERIC_READ,MANAGE_TEST_PLANS') `
            -Deny ([vsteam_lib.WorkItemAreaPermissions]'GENERIC_WRITE,DELETE')

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/83e28ad4-2d72-4ceb-97b0-c7726d5502c3*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"vstfs:///Classification/Node/b33b12d7-6abb-4b7a-b9d6-2092d0933c99:vstfs:///Classification/Node/38de1ce0-0b1b-45f2-b4f9-f32e3a72b78b:vstfs:///Classification/Node/90aa2c42-de51-450a-bfb6-6e264e364d9a`",*" -and
            $Body -like "*`"descriptor`": `"Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1`",*" -and
            $Body -like "*`"allow`": 65,*" -and
            $Body -like "*`"deny`": 10,*" -and
            $Method -eq "Post"
         }
      }

      It 'by AreaPath and User should return ACEs' {
         ## Act
         Add-VSTeamWorkItemAreaPermission -Project $projectResultObject `
            -AreaPath "Child 1 Level 1/Child 1 Level 2" `
            -User $userSingleResultObject `
            -Allow ([vsteam_lib.WorkItemAreaPermissions]'GENERIC_READ,MANAGE_TEST_PLANS') `
            -Deny ([vsteam_lib.WorkItemAreaPermissions]'GENERIC_WRITE,DELETE')

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/83e28ad4-2d72-4ceb-97b0-c7726d5502c3*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"vstfs:///Classification/Node/b33b12d7-6abb-4b7a-b9d6-2092d0933c99:vstfs:///Classification/Node/38de1ce0-0b1b-45f2-b4f9-f32e3a72b78b:vstfs:///Classification/Node/90aa2c42-de51-450a-bfb6-6e264e364d9a`",*" -and
            $Body -like "*`"descriptor`": `"Microsoft.IdentityModel.Claims.ClaimsIdentity;788df857-dcd8-444d-885e-bff359bc1982\\test@testuser.com`",*" -and
            $Body -like "*`"allow`": 65,*" -and
            $Body -like "*`"deny`": 10,*" -and
            $Method -eq "Post"
         }
      }

      It 'by AreaPath and Group should return ACEs' {
         ## Act
         Add-VSTeamWorkItemAreaPermission -Project $projectResultObject `
            -AreaPath "Child 1 Level 1/Child 1 Level 2" `
            -Group $groupSingleResultObject `
            -Allow ([vsteam_lib.WorkItemAreaPermissions]'GENERIC_READ,MANAGE_TEST_PLANS') `
            -Deny ([vsteam_lib.WorkItemAreaPermissions]'GENERIC_WRITE,DELETE')

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/83e28ad4-2d72-4ceb-97b0-c7726d5502c3*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"vstfs:///Classification/Node/b33b12d7-6abb-4b7a-b9d6-2092d0933c99:vstfs:///Classification/Node/38de1ce0-0b1b-45f2-b4f9-f32e3a72b78b:vstfs:///Classification/Node/90aa2c42-de51-450a-bfb6-6e264e364d9a`",*" -and
            $Body -like "*`"descriptor`": `"Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1`",*" -and
            $Body -like "*`"allow`": 65,*" -and
            $Body -like "*`"deny`": 10,*" -and
            $Method -eq "Post"
         }
      }

      It 'by AreaPath and Descriptor should return ACEs' {
         ## Act
         Add-VSTeamWorkItemAreaPermission -Project $projectResultObject `
            -AreaPath "Child 1 Level 1/Child 1 Level 2" `
            -Descriptor "Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1" `
            -Allow ([vsteam_lib.WorkItemAreaPermissions]'GENERIC_READ,MANAGE_TEST_PLANS') `
            -Deny ([vsteam_lib.WorkItemAreaPermissions]'GENERIC_WRITE,DELETE')

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/83e28ad4-2d72-4ceb-97b0-c7726d5502c3*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"vstfs:///Classification/Node/b33b12d7-6abb-4b7a-b9d6-2092d0933c99:vstfs:///Classification/Node/38de1ce0-0b1b-45f2-b4f9-f32e3a72b78b:vstfs:///Classification/Node/90aa2c42-de51-450a-bfb6-6e264e364d9a`",*" -and
            $Body -like "*`"descriptor`": `"Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1`",*" -and
            $Body -like "*`"allow`": 65,*" -and
            $Body -like "*`"deny`": 10,*" -and
            $Method -eq "Post"
         }
      }
   }
}