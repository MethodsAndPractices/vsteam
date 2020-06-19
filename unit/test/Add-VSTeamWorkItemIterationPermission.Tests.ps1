Set-StrictMode -Version Latest

Describe 'VSTeamWorkItemIterationPermission' {
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
      . "$PSScriptRoot/../../Source/Classes/VSTeamWorkItemIterationPermissions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamClassificationNode.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamGroup.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamUser.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
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

      $classificationNodeIterationId =
      @"
{
   "count": 1,
   "value": [
     {
       "id": 20,
       "identifier": "18e7998d-d0c5-4c01-b547-d7d4eb4c97c5",
       "name": "Sprint 3",
       "structureType": "iteration",
       "hasChildren": false,
       "path": "\\Demo Public\\Iteration\\Sprint 3",
       "_links": {
         "self": {
           "href": "https://dev.azure.com/vsteampsmoduletest/53e2997d-3723-4c1c-aa62-a0194cb65a29/_apis/wit/classificationNodes/Iterations/Sprint%203"
         },
         "parent": {
           "href": "https://dev.azure.com/vsteampsmoduletest/53e2997d-3723-4c1c-aa62-a0194cb65a29/_apis/wit/classificationNodes/Iterations"
         }
       },
       "url": "https://dev.azure.com/vsteampsmoduletest/53e2997d-3723-4c1c-aa62-a0194cb65a29/_apis/wit/classificationNodes/Iterations/Sprint%203"
     }
   ]
 }
"@ | ConvertFrom-Json | Select-Object -ExpandProperty value

      $classificationNodeIterationIdObject = [VSTeamClassificationNode]::new($classificationNodeIterationId, "test")

      $iterationRootNode =
      @"
{
   "id": 16,
   "identifier": "dfa90792-403a-4119-a52b-bd142c08291b",
   "name": "Demo Public",
   "structureType": "iteration",
   "hasChildren": true,
   "path": "\\Demo Public\\Iteration",
   "_links": {
     "self": {
       "href": "https://dev.azure.com/vsteampsmoduletest/53e2997d-3723-4c1c-aa62-a0194cb65a29/_apis/wit/classificationNodes/Iterations"
     }
   },
   "url": "https://dev.azure.com/vsteampsmoduletest/53e2997d-3723-4c1c-aa62-a0194cb65a29/_apis/wit/classificationNodes/Iterations"
 }
"@ | ConvertFrom-Json

      $iterationRootNodeObject = [VSTeamClassificationNode]::new($iterationRootNode, "test")

      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' }

      # You have to set the version or the api-version will not be added when versions = ''
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Core' }

      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock _hasProjectCacheExpired { return $true }
      Mock Invoke-RestMethod { return @() } -ParameterFilter { $Uri -like "*_apis/projects*" }
   }

   Context 'Add-VSTeamWorkItemIterationPermission' {
      BeforeAll {
         # Mock _getProjects { return "Test Project Public" }
         Mock Get-VSTeamClassificationNode { return $iterationRootNodeObject }
         Mock Get-VSTeamClassificationNode { return $classificationNodeIterationIdObject } -ParameterFilter { $Ids -eq 44 -or $Path -eq "Sprint 1" }

         Mock Invoke-RestMethod {
            # If this test fails uncomment the line below to see how the mock was called.
            # Write-Host $args
            return $accessControlEntryResult
         }
      }

      It 'by IterationID and User should return ACEs' {
         Add-VSTeamWorkItemIterationPermission -Project $projectResultObject -IterationID 44 -User $userSingleResultObject -Allow ([VSTeamWorkItemIterationPermissions]'GENERIC_READ,CREATE_CHILDREN') -Deny ([VSTeamWorkItemIterationPermissions]'DELETE')
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/bf7bfa03-b2b7-47db-8113-fa2e002cc5b1*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"vstfs:///Classification/Node/dfa90792-403a-4119-a52b-bd142c08291b:vstfs:///Classification/Node/18e7998d-d0c5-4c01-b547-d7d4eb4c97c5`",*" -and
            $Body -like "*`"descriptor`": `"Microsoft.IdentityModel.Claims.ClaimsIdentity;788df857-dcd8-444d-885e-bff359bc1982\\test@testuser.com`",*" -and
            $Body -like "*`"allow`": 5,*" -and
            $Body -like "*`"deny`": 8,*" -and
            $ContentType -eq "application/json" -and
            $Method -eq "Post"
         }
      }

      It 'by IterationID and Group should return ACEs' {
         Add-VSTeamWorkItemIterationPermission -Project $projectResultObject -IterationID 44 -Group $groupSingleResultObject -Allow ([VSTeamWorkItemIterationPermissions]'GENERIC_READ,CREATE_CHILDREN') -Deny ([VSTeamWorkItemIterationPermissions]'DELETE')
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/bf7bfa03-b2b7-47db-8113-fa2e002cc5b1*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"vstfs:///Classification/Node/dfa90792-403a-4119-a52b-bd142c08291b:vstfs:///Classification/Node/18e7998d-d0c5-4c01-b547-d7d4eb4c97c5`",*" -and
            $Body -like "*`"descriptor`": `"Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1`",*" -and
            $Body -like "*`"allow`": 5,*" -and
            $Body -like "*`"deny`": 8,*" -and
            $ContentType -eq "application/json" -and
            $Method -eq "Post"
         }
      }

      It 'by IterationID and Descriptor should return ACEs' {
         Add-VSTeamWorkItemIterationPermission -Project $projectResultObject -IterationID 44 -Descriptor "Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1" -Allow ([VSTeamWorkItemIterationPermissions]'GENERIC_READ,CREATE_CHILDREN') -Deny ([VSTeamWorkItemIterationPermissions]'DELETE')
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/bf7bfa03-b2b7-47db-8113-fa2e002cc5b1*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"vstfs:///Classification/Node/dfa90792-403a-4119-a52b-bd142c08291b:vstfs:///Classification/Node/18e7998d-d0c5-4c01-b547-d7d4eb4c97c5`",*" -and
            $Body -like "*`"descriptor`": `"Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1`",*" -and
            $Body -like "*`"allow`": 5,*" -and
            $Body -like "*`"deny`": 8,*" -and
            $ContentType -eq "application/json" -and
            $Method -eq "Post"
         }
      }

      It 'by IterationPath and User should return ACEs' {
         Add-VSTeamWorkItemIterationPermission -Project $projectResultObject -IterationPath "Sprint 1" -User $userSingleResultObject -Allow ([VSTeamWorkItemIterationPermissions]'GENERIC_READ,CREATE_CHILDREN') -Deny ([VSTeamWorkItemIterationPermissions]'DELETE')
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/bf7bfa03-b2b7-47db-8113-fa2e002cc5b1*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"vstfs:///Classification/Node/dfa90792-403a-4119-a52b-bd142c08291b:vstfs:///Classification/Node/18e7998d-d0c5-4c01-b547-d7d4eb4c97c5`",*" -and
            $Body -like "*`"descriptor`": `"Microsoft.IdentityModel.Claims.ClaimsIdentity;788df857-dcd8-444d-885e-bff359bc1982\\test@testuser.com`",*" -and
            $Body -like "*`"allow`": 5,*" -and
            $Body -like "*`"deny`": 8,*" -and
            $ContentType -eq "application/json" -and
            $Method -eq "Post"
         }
      }

      It 'by IterationPath and Group should return ACEs' {
         Add-VSTeamWorkItemIterationPermission -Project $projectResultObject -IterationPath "Sprint 1" -Group $groupSingleResultObject -Allow ([VSTeamWorkItemIterationPermissions]'GENERIC_READ,CREATE_CHILDREN') -Deny ([VSTeamWorkItemIterationPermissions]'DELETE')
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/bf7bfa03-b2b7-47db-8113-fa2e002cc5b1*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"vstfs:///Classification/Node/dfa90792-403a-4119-a52b-bd142c08291b:vstfs:///Classification/Node/18e7998d-d0c5-4c01-b547-d7d4eb4c97c5`",*" -and
            $Body -like "*`"descriptor`": `"Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1`",*" -and
            $Body -like "*`"allow`": 5,*" -and
            $Body -like "*`"deny`": 8,*" -and
            $ContentType -eq "application/json" -and
            $Method -eq "Post"
         }
      }

      It 'by IterationPath and Descriptor should return ACEs' {
         Add-VSTeamWorkItemIterationPermission -Project $projectResultObject -IterationPath "Sprint 1" -Descriptor "Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1" -Allow ([VSTeamWorkItemIterationPermissions]'GENERIC_READ,CREATE_CHILDREN') -Deny ([VSTeamWorkItemIterationPermissions]'DELETE')
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/bf7bfa03-b2b7-47db-8113-fa2e002cc5b1*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"vstfs:///Classification/Node/dfa90792-403a-4119-a52b-bd142c08291b:vstfs:///Classification/Node/18e7998d-d0c5-4c01-b547-d7d4eb4c97c5`",*" -and
            $Body -like "*`"descriptor`": `"Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1`",*" -and
            $Body -like "*`"allow`": 5,*" -and
            $Body -like "*`"deny`": 8,*" -and
            $ContentType -eq "application/json" -and
            $Method -eq "Post"
         }
      }
   }
}
