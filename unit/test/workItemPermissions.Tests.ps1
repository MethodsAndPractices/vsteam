Set-StrictMode -Version Latest

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

   Describe 'WorkItem Area/Iteration Permissions VSTS' {
      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable
   
      # You have to set the version or the api-version will not be added when
      # [VSTeamVersions]::Core = ''
      [VSTeamVersions]::Core = '5.0'

      Context 'Add-VSTeamWorkItemAreaPermission by AreaID and User' {
         Mock _getProjects { return "Test Project Public" } -Verifiable
         Mock Get-VSTeamClassificationNode { return $parentClassificationNodeObject } -ParameterFilter { $Path -eq "Child%201%20Level%201"} -Verifiable
         Mock Get-VSTeamClassificationNode { return $classificationNodeByIdObject } -ParameterFilter { $Ids -eq 44 } -Verifiable
         Mock Get-VSTeamClassificationNode { return $areaRootNodeObject }

         Mock Invoke-RestMethod {
            # If this test fails uncomment the line below to see how the mock was called.
            # Write-Host $args

            return $accessControlEntryResult
         } -Verifiable

         Add-VSTeamWorkItemAreaPermission -Project $projectResultObject -AreaID 44 -User $userSingleResultObject -Allow ([VSTeamWorkItemAreaPermissions]'GENERIC_READ,MANAGE_TEST_PLANS') -Deny ([VSTeamWorkItemAreaPermissions]'GENERIC_WRITE,DELETE')

         It 'Should return ACEs' {
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/83e28ad4-2d72-4ceb-97b0-c7726d5502c3*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
               $Body -like "*`"token`": `"vstfs:///Classification/Node/b33b12d7-6abb-4b7a-b9d6-2092d0933c99:vstfs:///Classification/Node/38de1ce0-0b1b-45f2-b4f9-f32e3a72b78b:vstfs:///Classification/Node/90aa2c42-de51-450a-bfb6-6e264e364d9a`",*" -and
               $Body -like "*`"descriptor`": `"Microsoft.IdentityModel.Claims.ClaimsIdentity;788df857-dcd8-444d-885e-bff359bc1982\\test@testuser.com`",*" -and
               $Body -like "*`"allow`": 65,*" -and
               $Body -like "*`"deny`": 10,*" -and
               $ContentType -eq "application/json" -and
               $Method -eq "Post"
            }
         }
      }

      Context 'Add-VSTeamWorkItemAreaPermission by AreaID and Group' {
         Mock _getProjects { return "Test Project Public" } -Verifiable
         Mock Get-VSTeamClassificationNode { return $parentClassificationNodeObject } -ParameterFilter { $Path -eq "Child%201%20Level%201"} -Verifiable
         Mock Get-VSTeamClassificationNode { return $classificationNodeByIdObject } -ParameterFilter { $Ids -eq 44 } -Verifiable
         Mock Get-VSTeamClassificationNode { return $areaRootNodeObject }
         Mock Invoke-RestMethod { return $accessControlEntryResult } -Verifiable

         Add-VSTeamWorkItemAreaPermission -Project $projectResultObject -AreaID 44 -Group $groupSingleResultObject -Allow ([VSTeamWorkItemAreaPermissions]'GENERIC_READ,MANAGE_TEST_PLANS') -Deny ([VSTeamWorkItemAreaPermissions]'GENERIC_WRITE,DELETE')

         It 'Should return ACEs' {
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/83e28ad4-2d72-4ceb-97b0-c7726d5502c3*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
               $Body -like "*`"token`": `"vstfs:///Classification/Node/b33b12d7-6abb-4b7a-b9d6-2092d0933c99:vstfs:///Classification/Node/38de1ce0-0b1b-45f2-b4f9-f32e3a72b78b:vstfs:///Classification/Node/90aa2c42-de51-450a-bfb6-6e264e364d9a`",*" -and
               $Body -like "*`"descriptor`": `"Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1`",*" -and
               $Body -like "*`"allow`": 65,*" -and
               $Body -like "*`"deny`": 10,*" -and
               $ContentType -eq "application/json" -and
               $Method -eq "Post"
            }
         }
      }

      Context 'Add-VSTeamWorkItemAreaPermission by AreaID and Descriptor' {
         Mock _getProjects { return "Test Project Public" } -Verifiable
         Mock Get-VSTeamClassificationNode { return $parentClassificationNodeObject } -ParameterFilter { $Path -eq "Child%201%20Level%201"} -Verifiable
         Mock Get-VSTeamClassificationNode { return $classificationNodeByIdObject } -ParameterFilter { $Ids -eq 44 } -Verifiable
         Mock Get-VSTeamClassificationNode { return $areaRootNodeObject }
         Mock Invoke-RestMethod { return $accessControlEntryResult } -Verifiable

         Add-VSTeamWorkItemAreaPermission -Project $projectResultObject -AreaID 44 -Descriptor "Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1" -Allow ([VSTeamWorkItemAreaPermissions]'GENERIC_READ,MANAGE_TEST_PLANS') -Deny ([VSTeamWorkItemAreaPermissions]'GENERIC_WRITE,DELETE')

         It 'Should return ACEs' {
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/83e28ad4-2d72-4ceb-97b0-c7726d5502c3*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
               $Body -like "*`"token`": `"vstfs:///Classification/Node/b33b12d7-6abb-4b7a-b9d6-2092d0933c99:vstfs:///Classification/Node/38de1ce0-0b1b-45f2-b4f9-f32e3a72b78b:vstfs:///Classification/Node/90aa2c42-de51-450a-bfb6-6e264e364d9a`",*" -and
               $Body -like "*`"descriptor`": `"Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1`",*" -and
               $Body -like "*`"allow`": 65,*" -and
               $Body -like "*`"deny`": 10,*" -and
               $ContentType -eq "application/json" -and
               $Method -eq "Post"
            }
         }
      }

      Context 'Add-VSTeamWorkItemAreaPermission by AreaPath and User' {
         Mock _getProjects { return "Test Project Public" } -Verifiable
         Mock Get-VSTeamClassificationNode { return $parentClassificationNodeObject } -ParameterFilter { $Path -eq "Child%201%20Level%201"} -Verifiable
         Mock Get-VSTeamClassificationNode { return $classificationNodeByIdObject } -ParameterFilter { $Path -eq "Child 1 Level 1/Child 1 Level 2" } -Verifiable
         Mock Get-VSTeamClassificationNode { return $areaRootNodeObject }
         Mock Invoke-RestMethod {
            # If this test fails uncomment the line below to see how the mock was called.
            # Write-Host $args

            return $accessControlEntryResult
         } -Verifiable

         Add-VSTeamWorkItemAreaPermission -Project $projectResultObject -AreaPath "Child 1 Level 1/Child 1 Level 2" -User $userSingleResultObject -Allow ([VSTeamWorkItemAreaPermissions]'GENERIC_READ,MANAGE_TEST_PLANS') -Deny ([VSTeamWorkItemAreaPermissions]'GENERIC_WRITE,DELETE')

         It 'Should return ACEs' {
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/83e28ad4-2d72-4ceb-97b0-c7726d5502c3*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
               $Body -like "*`"token`": `"vstfs:///Classification/Node/b33b12d7-6abb-4b7a-b9d6-2092d0933c99:vstfs:///Classification/Node/38de1ce0-0b1b-45f2-b4f9-f32e3a72b78b:vstfs:///Classification/Node/90aa2c42-de51-450a-bfb6-6e264e364d9a`",*" -and
               $Body -like "*`"descriptor`": `"Microsoft.IdentityModel.Claims.ClaimsIdentity;788df857-dcd8-444d-885e-bff359bc1982\\test@testuser.com`",*" -and
               $Body -like "*`"allow`": 65,*" -and
               $Body -like "*`"deny`": 10,*" -and
               $ContentType -eq "application/json" -and
               $Method -eq "Post"
            }
         }
      }

      Context 'Add-VSTeamWorkItemAreaPermission by AreaPath and Group' {
         Mock _getProjects { return "Test Project Public" } -Verifiable
         Mock Get-VSTeamClassificationNode { return $parentClassificationNodeObject } -ParameterFilter { $Path -eq "Child%201%20Level%201"} -Verifiable
         Mock Get-VSTeamClassificationNode { return $classificationNodeByIdObject } -ParameterFilter { $Path -eq "Child 1 Level 1/Child 1 Level 2" } -Verifiable
         Mock Get-VSTeamClassificationNode { return $areaRootNodeObject }
         Mock Invoke-RestMethod { return $accessControlEntryResult } -Verifiable

         Add-VSTeamWorkItemAreaPermission -Project $projectResultObject -AreaPath "Child 1 Level 1/Child 1 Level 2" -Group $groupSingleResultObject -Allow ([VSTeamWorkItemAreaPermissions]'GENERIC_READ,MANAGE_TEST_PLANS') -Deny ([VSTeamWorkItemAreaPermissions]'GENERIC_WRITE,DELETE')

         It 'Should return ACEs' {
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/83e28ad4-2d72-4ceb-97b0-c7726d5502c3*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
               $Body -like "*`"token`": `"vstfs:///Classification/Node/b33b12d7-6abb-4b7a-b9d6-2092d0933c99:vstfs:///Classification/Node/38de1ce0-0b1b-45f2-b4f9-f32e3a72b78b:vstfs:///Classification/Node/90aa2c42-de51-450a-bfb6-6e264e364d9a`",*" -and
               $Body -like "*`"descriptor`": `"Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1`",*" -and
               $Body -like "*`"allow`": 65,*" -and
               $Body -like "*`"deny`": 10,*" -and
               $ContentType -eq "application/json" -and
               $Method -eq "Post"
            }
         }
      }

      Context 'Add-VSTeamWorkItemAreaPermission by AreaPath and Descriptor' {
         Mock _getProjects { return "Test Project Public" } -Verifiable
         Mock Get-VSTeamClassificationNode { return $parentClassificationNodeObject } -ParameterFilter { $Path -eq "Child%201%20Level%201"} -Verifiable
         Mock Get-VSTeamClassificationNode { return $classificationNodeByIdObject } -ParameterFilter { $Path -eq "Child 1 Level 1/Child 1 Level 2" } -Verifiable
         Mock Get-VSTeamClassificationNode { return $areaRootNodeObject }
         Mock Invoke-RestMethod { return $accessControlEntryResult } -Verifiable

         Add-VSTeamWorkItemAreaPermission -Project $projectResultObject -AreaPath "Child 1 Level 1/Child 1 Level 2" -Descriptor "Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1" -Allow ([VSTeamWorkItemAreaPermissions]'GENERIC_READ,MANAGE_TEST_PLANS') -Deny ([VSTeamWorkItemAreaPermissions]'GENERIC_WRITE,DELETE')

         It 'Should return ACEs' {
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/83e28ad4-2d72-4ceb-97b0-c7726d5502c3*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
               $Body -like "*`"token`": `"vstfs:///Classification/Node/b33b12d7-6abb-4b7a-b9d6-2092d0933c99:vstfs:///Classification/Node/38de1ce0-0b1b-45f2-b4f9-f32e3a72b78b:vstfs:///Classification/Node/90aa2c42-de51-450a-bfb6-6e264e364d9a`",*" -and
               $Body -like "*`"descriptor`": `"Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1`",*" -and
               $Body -like "*`"allow`": 65,*" -and
               $Body -like "*`"deny`": 10,*" -and
               $ContentType -eq "application/json" -and
               $Method -eq "Post"
            }
         }
      }

      Context 'Add-VSTeamWorkItemAreaPermission by AreaPath and Descritpor throws' {
         Mock Invoke-RestMethod { throw 'Error' }

         It 'Should throw' {
            { Add-VSTeamWorkItemAreaPermission -Project $projectResultObject -AreaPath "Child 1 Level 1/Child 1 Level 2" -Descriptor "Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1" -Allow ([VSTeamWorkItemAreaPermissions]'GENERIC_READ,MANAGE_TEST_PLANS') -Deny ([VSTeamWorkItemAreaPermissions]'GENERIC_WRITE,DELETE')  } | Should Throw
         }
      }

      Context 'Add-VSTeamWorkItemAreaPermission by AreaID and Descriptor Throws on Iteration ID' {
         Mock _getProjects { return "Test Project Public" } -Verifiable
         Mock Get-VSTeamClassificationNode { return $classificationNodeIterationIdObject } -ParameterFilter { $Ids -eq 20 } -Verifiable

         It 'Should throw' {
            { Add-VSTeamWorkItemAreaPermission -Project $projectResultObject -AreaID 20 -Descriptor "Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1" -Allow ([VSTeamWorkItemAreaPermissions]'GENERIC_READ,MANAGE_TEST_PLANS') -Deny ([VSTeamWorkItemAreaPermissions]'GENERIC_WRITE,DELETE') }
         }
      }

      Context 'Add-VSTeamWorkItemIterationPermission by IterationID and User' {
         Mock _getProjects { return "Test Project Public" } -Verifiable
         Mock Get-VSTeamClassificationNode { return $classificationNodeIterationIdObject } -ParameterFilter { $Ids -eq 44 } -Verifiable
         Mock Get-VSTeamClassificationNode { return $iterationRootNodeObject }

         Mock Invoke-RestMethod {
            # If this test fails uncomment the line below to see how the mock was called.
            # Write-Host $args

            return $accessControlEntryResult
         } -Verifiable

         Add-VSTeamWorkItemIterationPermission -Project $projectResultObject -IterationID 44 -User $userSingleResultObject -Allow ([VSTeamWorkItemIterationPermissions]'GENERIC_READ,CREATE_CHILDREN') -Deny ([VSTeamWorkItemIterationPermissions]'DELETE')

         It 'Should return ACEs' {
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/bf7bfa03-b2b7-47db-8113-fa2e002cc5b1*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
               $Body -like "*`"token`": `"vstfs:///Classification/Node/dfa90792-403a-4119-a52b-bd142c08291b:vstfs:///Classification/Node/18e7998d-d0c5-4c01-b547-d7d4eb4c97c5`",*" -and
               $Body -like "*`"descriptor`": `"Microsoft.IdentityModel.Claims.ClaimsIdentity;788df857-dcd8-444d-885e-bff359bc1982\\test@testuser.com`",*" -and
               $Body -like "*`"allow`": 5,*" -and
               $Body -like "*`"deny`": 8,*" -and
               $ContentType -eq "application/json" -and
               $Method -eq "Post"
            }
         }
      }

      Context 'Add-VSTeamWorkItemIterationPermission by IterationID and Group' {
         Mock _getProjects { return "Test Project Public" } -Verifiable
         Mock Get-VSTeamClassificationNode { return $classificationNodeIterationIdObject } -ParameterFilter { $Ids -eq 44 } -Verifiable
         Mock Get-VSTeamClassificationNode { return $iterationRootNodeObject }
         Mock Invoke-RestMethod { return $accessControlEntryResult } -Verifiable

         Add-VSTeamWorkItemIterationPermission -Project $projectResultObject -IterationID 44 -Group $groupSingleResultObject -Allow ([VSTeamWorkItemIterationPermissions]'GENERIC_READ,CREATE_CHILDREN') -Deny ([VSTeamWorkItemIterationPermissions]'DELETE')

         It 'Should return ACEs' {
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/bf7bfa03-b2b7-47db-8113-fa2e002cc5b1*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
               $Body -like "*`"token`": `"vstfs:///Classification/Node/dfa90792-403a-4119-a52b-bd142c08291b:vstfs:///Classification/Node/18e7998d-d0c5-4c01-b547-d7d4eb4c97c5`",*" -and
               $Body -like "*`"descriptor`": `"Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1`",*" -and
               $Body -like "*`"allow`": 5,*" -and
               $Body -like "*`"deny`": 8,*" -and
               $ContentType -eq "application/json" -and
               $Method -eq "Post"
            }
         }
      }

      Context 'Add-VSTeamWorkItemIterationPermission by IterationID and Descriptor' {
         Mock _getProjects { return "Test Project Public" } -Verifiable
         Mock Get-VSTeamClassificationNode { return $classificationNodeIterationIdObject } -ParameterFilter { $Ids -eq 44 } -Verifiable
         Mock Get-VSTeamClassificationNode { return $iterationRootNodeObject }
         Mock Invoke-RestMethod { return $accessControlEntryResult } -Verifiable

         Add-VSTeamWorkItemIterationPermission -Project $projectResultObject -IterationID 44 -Descriptor "Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1" -Allow ([VSTeamWorkItemIterationPermissions]'GENERIC_READ,CREATE_CHILDREN') -Deny ([VSTeamWorkItemIterationPermissions]'DELETE')

         It 'Should return ACEs' {
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/bf7bfa03-b2b7-47db-8113-fa2e002cc5b1*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
               $Body -like "*`"token`": `"vstfs:///Classification/Node/dfa90792-403a-4119-a52b-bd142c08291b:vstfs:///Classification/Node/18e7998d-d0c5-4c01-b547-d7d4eb4c97c5`",*" -and
               $Body -like "*`"descriptor`": `"Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1`",*" -and
               $Body -like "*`"allow`": 5,*" -and
               $Body -like "*`"deny`": 8,*" -and
               $ContentType -eq "application/json" -and
               $Method -eq "Post"
            }
         }
      }

      Context 'Add-VSTeamWorkItemIterationPermission by IterationPath and User' {
         Mock _getProjects { return "Test Project Public" } -Verifiable
         Mock Get-VSTeamClassificationNode { return $classificationNodeIterationIdObject } -ParameterFilter { $Path -eq "Sprint 1" } -Verifiable
         Mock Get-VSTeamClassificationNode { return $iterationRootNodeObject }

         Mock Invoke-RestMethod {
            # If this test fails uncomment the line below to see how the mock was called.
            # Write-Host $args

            return $accessControlEntryResult
         } -Verifiable

         Add-VSTeamWorkItemIterationPermission -Project $projectResultObject -IterationPath "Sprint 1" -User $userSingleResultObject -Allow ([VSTeamWorkItemIterationPermissions]'GENERIC_READ,CREATE_CHILDREN') -Deny ([VSTeamWorkItemIterationPermissions]'DELETE')

         It 'Should return ACEs' {
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/bf7bfa03-b2b7-47db-8113-fa2e002cc5b1*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
               $Body -like "*`"token`": `"vstfs:///Classification/Node/dfa90792-403a-4119-a52b-bd142c08291b:vstfs:///Classification/Node/18e7998d-d0c5-4c01-b547-d7d4eb4c97c5`",*" -and
               $Body -like "*`"descriptor`": `"Microsoft.IdentityModel.Claims.ClaimsIdentity;788df857-dcd8-444d-885e-bff359bc1982\\test@testuser.com`",*" -and
               $Body -like "*`"allow`": 5,*" -and
               $Body -like "*`"deny`": 8,*" -and
               $ContentType -eq "application/json" -and
               $Method -eq "Post"
            }
         }
      }

      Context 'Add-VSTeamWorkItemIterationPermission by IterationPath and Group' {
         Mock _getProjects { return "Test Project Public" } -Verifiable
         Mock Get-VSTeamClassificationNode { return $classificationNodeIterationIdObject } -ParameterFilter { $Path -eq "Sprint 1" } -Verifiable
         Mock Get-VSTeamClassificationNode { return $iterationRootNodeObject }
         Mock Invoke-RestMethod { return $accessControlEntryResult } -Verifiable

         Add-VSTeamWorkItemIterationPermission -Project $projectResultObject -IterationPath "Sprint 1" -Group $groupSingleResultObject -Allow ([VSTeamWorkItemIterationPermissions]'GENERIC_READ,CREATE_CHILDREN') -Deny ([VSTeamWorkItemIterationPermissions]'DELETE')

         It 'Should return ACEs' {
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/bf7bfa03-b2b7-47db-8113-fa2e002cc5b1*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
               $Body -like "*`"token`": `"vstfs:///Classification/Node/dfa90792-403a-4119-a52b-bd142c08291b:vstfs:///Classification/Node/18e7998d-d0c5-4c01-b547-d7d4eb4c97c5`",*" -and
               $Body -like "*`"descriptor`": `"Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1`",*" -and
               $Body -like "*`"allow`": 5,*" -and
               $Body -like "*`"deny`": 8,*" -and
               $ContentType -eq "application/json" -and
               $Method -eq "Post"
            }
         }
      }

      Context 'Add-VSTeamWorkItemIterationPermission by IterationPath and Descriptor' {
         Mock _getProjects { return "Test Project Public" } -Verifiable
         Mock Get-VSTeamClassificationNode { return $classificationNodeIterationIdObject } -ParameterFilter { $Path -eq "Sprint 1" } -Verifiable
         Mock Get-VSTeamClassificationNode { return $iterationRootNodeObject }
         Mock Invoke-RestMethod { return $accessControlEntryResult } -Verifiable

         Add-VSTeamWorkItemIterationPermission -Project $projectResultObject -IterationPath "Sprint 1" -Descriptor "Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1" -Allow ([VSTeamWorkItemIterationPermissions]'GENERIC_READ,CREATE_CHILDREN') -Deny ([VSTeamWorkItemIterationPermissions]'DELETE')

         It 'Should return ACEs' {
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/bf7bfa03-b2b7-47db-8113-fa2e002cc5b1*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
               $Body -like "*`"token`": `"vstfs:///Classification/Node/dfa90792-403a-4119-a52b-bd142c08291b:vstfs:///Classification/Node/18e7998d-d0c5-4c01-b547-d7d4eb4c97c5`",*" -and
               $Body -like "*`"descriptor`": `"Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1`",*" -and
               $Body -like "*`"allow`": 5,*" -and
               $Body -like "*`"deny`": 8,*" -and
               $ContentType -eq "application/json" -and
               $Method -eq "Post"
            }
         }
      }

      Context 'Add-VSTeamWorkItemIterationPermission by IterationPath and Descritpor throws' {
         Mock Invoke-RestMethod { throw 'Error' }

         It 'Should throw' {
            { Add-VSTeamWorkItemIterationPermission -Project $projectResultObject -IterationPath "Child 1 Level 1/Child 1 Level 2" -Descriptor "Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1" -Allow ([VSTeamWorkItemIterationPermissions]'GENERIC_READ,CREATE_CHILDREN') -Deny ([VSTeamWorkItemIterationPermissions]'DELETE')  } | Should Throw
         }
      }
   }
}