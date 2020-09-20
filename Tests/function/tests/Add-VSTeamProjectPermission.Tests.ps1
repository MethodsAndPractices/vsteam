Set-StrictMode -Version Latest

Describe 'VSTeamProjectPermission' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$baseFolder/Source/Public/Add-VSTeamAccessControlEntry.ps1"

      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable

      $userSingleResult = Open-SampleFile 'users.single.json'
      $userSingleResultObject = [vsteam_lib.User]::new($userSingleResult)

      $groupSingleResult = Open-SampleFile 'groupsSingle.json'
      $groupSingleResultObject = [vsteam_lib.Group]::new($groupSingleResult)

      $projectResult = [PSCustomObject]@{
         name        = 'Test Project Public'
         description = ''
         url         = ''
         id          = '010d06f0-00d5-472a-bb47-58947c230876'
         state       = ''
         visibility  = ''
         revision    = [long]0
         defaultTeam = [PSCustomObject]@{ }
         _links      = [PSCustomObject]@{ }
      }

      $projectResultObject = [vsteam_lib.Project]::new($projectResult)

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

      # You have to set the version or the api-version will not be added when versions = ''
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Core' }
   }

   Context 'Add-VSTeamProjectPermission by ProjectUser' {
      BeforeAll {
         Mock Invoke-RestMethod {
            # If this test fails uncomment the line below to see how the mock was called.
            # Write-Host $args

            return $accessControlEntryResult
         } -Verifiable
      }

      It 'by ProjectUser should return ACEs' {
         Add-VSTeamProjectPermission -Project $projectResultObject -User $userSingleResultObject -Allow ([vsteam_lib.ProjectPermissions]'GENERIC_READ,GENERIC_WRITE,WORK_ITEM_DELETE,RENAME') -Deny ([vsteam_lib.ProjectPermissions]'CHANGE_PROCESS,VIEW_TEST_RESULTS')

         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/52d39943-cb85-4d7f-8fa8-c6baac873819*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"`$PROJECT:vstfs:///Classification/TeamProject/010d06f0-00d5-472a-bb47-58947c230876`",*" -and
            $Body -like "*`"descriptor`": `"Microsoft.IdentityModel.Claims.ClaimsIdentity;788df857-dcd8-444d-885e-bff359bc1982\\test@testuser.com`",*" -and
            $Body -like "*`"allow`": 73731,*" -and
            $Body -like "*`"deny`": 8389120,*" -and
            $Method -eq "Post"
         }
      }

      It 'by ProjectGroup should return ACEs' {
         Add-VSTeamProjectPermission -Project $projectResultObject -Group $groupSingleResultObject -Allow ([vsteam_lib.ProjectPermissions]'GENERIC_READ,GENERIC_WRITE,WORK_ITEM_DELETE,RENAME') -Deny ([vsteam_lib.ProjectPermissions]'CHANGE_PROCESS,VIEW_TEST_RESULTS')

         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/52d39943-cb85-4d7f-8fa8-c6baac873819*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"`$PROJECT:vstfs:///Classification/TeamProject/010d06f0-00d5-472a-bb47-58947c230876`",*" -and
            $Body -like "*`"descriptor`": `"Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1`",*" -and
            $Body -like "*`"allow`": 73731,*" -and
            $Body -like "*`"deny`": 8389120,*" -and
            $Method -eq "Post"
         }
      }

      It 'by ProjectDescriptor should return ACEs' {
         Add-VSTeamProjectPermission -Project $projectResultObject -Descriptor "Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1" -Allow ([vsteam_lib.ProjectPermissions]'GENERIC_READ,GENERIC_WRITE,WORK_ITEM_DELETE,RENAME') -Deny ([vsteam_lib.ProjectPermissions]'CHANGE_PROCESS,VIEW_TEST_RESULTS')
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/52d39943-cb85-4d7f-8fa8-c6baac873819*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"`$PROJECT:vstfs:///Classification/TeamProject/010d06f0-00d5-472a-bb47-58947c230876`",*" -and
            $Body -like "*`"descriptor`": `"Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1`",*" -and
            $Body -like "*`"allow`": 73731,*" -and
            $Body -like "*`"deny`": 8389120,*" -and
            $Method -eq "Post"
         }
      }
   }
}