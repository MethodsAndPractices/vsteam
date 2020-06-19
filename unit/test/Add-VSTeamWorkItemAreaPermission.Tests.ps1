Set-StrictMode -Version Latest

Describe 'VSTeamWorkItemAreaPermission' {
   BeforeAll {
      Import-Module SHiPS

      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamLeaf.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamDirectory.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamUserEntitlement.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamTeams.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamRepositories.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamReleaseDefinitions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamTask.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamAttempt.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamEnvironment.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamRelease.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamReleases.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamBuild.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamBuilds.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamQueues.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamBuildDefinitions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProject.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamWorkItemAreaPermissions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamClassificationNode.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamGroup.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamUser.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamAccessControlEntry.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamSecurityNamespace.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamProject.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamClassificationNode.ps1"
      . "$PSScriptRoot/../../Source/Public/Add-VSTeamAccessControlEntry.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"

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
         defaultTeam = [PSCustomObject]@{ }
         _links      = [PSCustomObject]@{ }
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

      $classificationNodeById =
      @"
{
   "count": 1,
   "value": [
     {
       "id": 44,
       "identifier": "90aa2c42-de51-450a-bfb6-6e264e364d9a",
       "name": "Child 1 Level 2",
       "structureType": "area",
       "hasChildren": false,
       "path": "\\Demo Public\\Area\\Child 1 Level 1\\Child 1 Level 2",
       "_links": {
         "self": {
           "href": "https://dev.azure.com/vsteampsmoduletest/53e2997d-3723-4c1c-aa62-a0194cb65a29/_apis/wit/classificationNodes/Areas/Child%201%20Level%201/Child%201%20Level%202"
         },
         "parent": {
           "href": "https://dev.azure.com/vsteampsmoduletest/53e2997d-3723-4c1c-aa62-a0194cb65a29/_apis/wit/classificationNodes/Areas/Child%201%20Level%201"
         }
       },
       "url": "https://dev.azure.com/vsteampsmoduletest/53e2997d-3723-4c1c-aa62-a0194cb65a29/_apis/wit/classificationNodes/Areas/Child%201%20Level%201/Child%201%20Level%202"
     }
   ]
 }
"@ | ConvertFrom-Json | Select-Object -ExpandProperty value

      $classificationNodeByIdObject = [VSTeamClassificationNode]::new($classificationNodeById, "test")

      $parentClassificationNode =
      @"
{
   "count": 1,
   "value": [
      {
         "id": 43,
         "identifier": "38de1ce0-0b1b-45f2-b4f9-f32e3a72b78b",
         "name": "Child 1 Level 1",
         "structureType": "area",
         "hasChildren": true,
         "path": "\\Demo Public\\Area\\Child 1 Level 1",
         "_links": {
           "self": {
             "href": "https://dev.azure.com/vsteampsmoduletest/53e2997d-3723-4c1c-aa62-a0194cb65a29/_apis/wit/classificationNodes/Areas/Child%201%20Level%201"
           },
           "parent": {
             "href": "https://dev.azure.com/vsteampsmoduletest/53e2997d-3723-4c1c-aa62-a0194cb65a29/_apis/wit/classificationNodes/Areas"
           }
         },
         "url": "https://dev.azure.com/vsteampsmoduletest/53e2997d-3723-4c1c-aa62-a0194cb65a29/_apis/wit/classificationNodes/Areas/Child%201%20Level%201"
       }
   ]
 }
"@ | ConvertFrom-Json | Select-Object -ExpandProperty value

      $parentClassificationNodeObject = [VSTeamClassificationNode]::new($parentClassificationNode, "test")

      $areaRootNode =
      @"
{
   "id": 24,
   "identifier": "b33b12d7-6abb-4b7a-b9d6-2092d0933c99",
   "name": "Demo Public",
   "structureType": "area",
   "hasChildren": true,
   "path": "\\Demo Public\\Area",
   "_links": {
     "self": {
       "href": "https://dev.azure.com/vsteampsmoduletest/53e2997d-3723-4c1c-aa62-a0194cb65a29/_apis/wit/classificationNodes/Areas"
     }
   },
   "url": "https://dev.azure.com/vsteampsmoduletest/53e2997d-3723-4c1c-aa62-a0194cb65a29/_apis/wit/classificationNodes/Areas"
 }
"@ | ConvertFrom-Json

      $areaRootNodeObject = [VSTeamClassificationNode]::new($areaRootNode, "test")

      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' }

      # You have to set the version or the api-version will not be added when versions = ''
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Core' }
   }

   Context 'Add-VSTeamWorkItemAreaPermission' {
      BeforeAll {
         # Mock _getProjects { return "Test Project Public" }
         Mock _hasProjectCacheExpired { return $false }
         Mock Get-VSTeamClassificationNode { return $areaRootNodeObject }
         Mock Get-VSTeamClassificationNode { return $parentClassificationNodeObject } -ParameterFilter { $Path -eq "Child%201%20Level%201" }
         Mock Get-VSTeamClassificationNode { return $classificationNodeByIdObject } -ParameterFilter { $Ids -eq 44 -or $Path -eq "Child 1 Level 1/Child 1 Level 2" }

         Mock Invoke-RestMethod {
            # If this test fails uncomment the line below to see how the mock was called.
            # Write-Host $args
            return $accessControlEntryResult
         }
      }

      It 'by AreaID and User should return ACEs' {
         Add-VSTeamWorkItemAreaPermission -Project $projectResultObject -AreaID 44 -User $userSingleResultObject -Allow ([VSTeamWorkItemAreaPermissions]'GENERIC_READ,MANAGE_TEST_PLANS') -Deny ([VSTeamWorkItemAreaPermissions]'GENERIC_WRITE,DELETE')

         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/83e28ad4-2d72-4ceb-97b0-c7726d5502c3*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"vstfs:///Classification/Node/b33b12d7-6abb-4b7a-b9d6-2092d0933c99:vstfs:///Classification/Node/38de1ce0-0b1b-45f2-b4f9-f32e3a72b78b:vstfs:///Classification/Node/90aa2c42-de51-450a-bfb6-6e264e364d9a`",*" -and
            $Body -like "*`"descriptor`": `"Microsoft.IdentityModel.Claims.ClaimsIdentity;788df857-dcd8-444d-885e-bff359bc1982\\test@testuser.com`",*" -and
            $Body -like "*`"allow`": 65,*" -and
            $Body -like "*`"deny`": 10,*" -and
            $ContentType -eq "application/json" -and
            $Method -eq "Post"
         }
      }

      It 'by AreaID and Group should return ACEs' {
         Add-VSTeamWorkItemAreaPermission -Project $projectResultObject -AreaID 44 -Group $groupSingleResultObject -Allow ([VSTeamWorkItemAreaPermissions]'GENERIC_READ,MANAGE_TEST_PLANS') -Deny ([VSTeamWorkItemAreaPermissions]'GENERIC_WRITE,DELETE')
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/83e28ad4-2d72-4ceb-97b0-c7726d5502c3*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"vstfs:///Classification/Node/b33b12d7-6abb-4b7a-b9d6-2092d0933c99:vstfs:///Classification/Node/38de1ce0-0b1b-45f2-b4f9-f32e3a72b78b:vstfs:///Classification/Node/90aa2c42-de51-450a-bfb6-6e264e364d9a`",*" -and
            $Body -like "*`"descriptor`": `"Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1`",*" -and
            $Body -like "*`"allow`": 65,*" -and
            $Body -like "*`"deny`": 10,*" -and
            $ContentType -eq "application/json" -and
            $Method -eq "Post"
         }
      }

      It 'by AreaID and Descriptor should return ACEs' {
         Add-VSTeamWorkItemAreaPermission -Project $projectResultObject -AreaID 44 -Descriptor "Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1" -Allow ([VSTeamWorkItemAreaPermissions]'GENERIC_READ,MANAGE_TEST_PLANS') -Deny ([VSTeamWorkItemAreaPermissions]'GENERIC_WRITE,DELETE')
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/83e28ad4-2d72-4ceb-97b0-c7726d5502c3*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"vstfs:///Classification/Node/b33b12d7-6abb-4b7a-b9d6-2092d0933c99:vstfs:///Classification/Node/38de1ce0-0b1b-45f2-b4f9-f32e3a72b78b:vstfs:///Classification/Node/90aa2c42-de51-450a-bfb6-6e264e364d9a`",*" -and
            $Body -like "*`"descriptor`": `"Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1`",*" -and
            $Body -like "*`"allow`": 65,*" -and
            $Body -like "*`"deny`": 10,*" -and
            $ContentType -eq "application/json" -and
            $Method -eq "Post"
         }
      }

      It 'by AreaPath and User should return ACEs' {
         Add-VSTeamWorkItemAreaPermission -Project $projectResultObject -AreaPath "Child 1 Level 1/Child 1 Level 2" -User $userSingleResultObject -Allow ([VSTeamWorkItemAreaPermissions]'GENERIC_READ,MANAGE_TEST_PLANS') -Deny ([VSTeamWorkItemAreaPermissions]'GENERIC_WRITE,DELETE')
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/83e28ad4-2d72-4ceb-97b0-c7726d5502c3*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"vstfs:///Classification/Node/b33b12d7-6abb-4b7a-b9d6-2092d0933c99:vstfs:///Classification/Node/38de1ce0-0b1b-45f2-b4f9-f32e3a72b78b:vstfs:///Classification/Node/90aa2c42-de51-450a-bfb6-6e264e364d9a`",*" -and
            $Body -like "*`"descriptor`": `"Microsoft.IdentityModel.Claims.ClaimsIdentity;788df857-dcd8-444d-885e-bff359bc1982\\test@testuser.com`",*" -and
            $Body -like "*`"allow`": 65,*" -and
            $Body -like "*`"deny`": 10,*" -and
            $ContentType -eq "application/json" -and
            $Method -eq "Post"
         }
      }

      It 'by AreaPath and Group should return ACEs' {
         Add-VSTeamWorkItemAreaPermission -Project $projectResultObject -AreaPath "Child 1 Level 1/Child 1 Level 2" -Group $groupSingleResultObject -Allow ([VSTeamWorkItemAreaPermissions]'GENERIC_READ,MANAGE_TEST_PLANS') -Deny ([VSTeamWorkItemAreaPermissions]'GENERIC_WRITE,DELETE')
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/83e28ad4-2d72-4ceb-97b0-c7726d5502c3*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"vstfs:///Classification/Node/b33b12d7-6abb-4b7a-b9d6-2092d0933c99:vstfs:///Classification/Node/38de1ce0-0b1b-45f2-b4f9-f32e3a72b78b:vstfs:///Classification/Node/90aa2c42-de51-450a-bfb6-6e264e364d9a`",*" -and
            $Body -like "*`"descriptor`": `"Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1`",*" -and
            $Body -like "*`"allow`": 65,*" -and
            $Body -like "*`"deny`": 10,*" -and
            $ContentType -eq "application/json" -and
            $Method -eq "Post"
         }
      }

      It 'by AreaPath and Descriptor should return ACEs' {
         Add-VSTeamWorkItemAreaPermission -Project $projectResultObject -AreaPath "Child 1 Level 1/Child 1 Level 2" -Descriptor "Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1" -Allow ([VSTeamWorkItemAreaPermissions]'GENERIC_READ,MANAGE_TEST_PLANS') -Deny ([VSTeamWorkItemAreaPermissions]'GENERIC_WRITE,DELETE')

         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/83e28ad4-2d72-4ceb-97b0-c7726d5502c3*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"vstfs:///Classification/Node/b33b12d7-6abb-4b7a-b9d6-2092d0933c99:vstfs:///Classification/Node/38de1ce0-0b1b-45f2-b4f9-f32e3a72b78b:vstfs:///Classification/Node/90aa2c42-de51-450a-bfb6-6e264e364d9a`",*" -and
            $Body -like "*`"descriptor`": `"Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1`",*" -and
            $Body -like "*`"allow`": 65,*" -and
            $Body -like "*`"deny`": 10,*" -and
            $ContentType -eq "application/json" -and
            $Method -eq "Post"
         }
      }
   }
}