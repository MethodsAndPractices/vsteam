Set-StrictMode -Version Latest

Describe 'VSTeamBuildPermission' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$baseFolder/Source/Public/Add-VSTeamAccessControlEntry.ps1"

      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable

      $userSingleResult = Open-SampleFile 'users.single.json'
      $userSingleResultObject = [vsteam_lib.User]::new($userSingleResult)

      $srvUserSingleResult = Open-SampleFile 'serviceUsers.single.json'
      $srvUserSingleResultObject = [vsteam_lib.User]::new($srvUserSingleResult)

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

   Context 'Add-VSTeamBuildPermission by ProjectUser' {
      BeforeAll {
         Mock Invoke-RestMethod {
            # If this test fails uncomment the line below to see how the mock was called.
            # Write-Host $args

            return $accessControlEntryResult
         } -Verifiable
      }

      It 'by ProjectUser should return ACEs' {
         Add-VSTeamBuildPermission -Project $projectResultObject -User $userSingleResultObject -Allow DestroyBuilds, DeleteBuildDefinition, AdministerBuildPermissions -Deny StopBuilds, QueueBuilds, EditBuildDefinition

         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/33344d9c-fc72-4d6f-aba5-fa317101a7e9*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"$($projectResultObject.Name)`",*" -and
            $Body -like "*`"descriptor`": `"Microsoft.IdentityModel.Claims.ClaimsIdentity;788df857-dcd8-444d-885e-bff359bc1982\\test@testuser.com`",*" -and
            $Body -like "*`"allow`": 20512,*" -and
            $Body -like "*`"deny`": 2688,*" -and
            $Method -eq "Post"
         }
      }

      It 'by ProjectUser on specific build Id should return ACEs' {
         Add-VSTeamBuildPermission -Project $projectResultObject -BuildID 5 -User $userSingleResultObject -Allow DestroyBuilds -Deny StopBuilds

         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/33344d9c-fc72-4d6f-aba5-fa317101a7e9*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"$($projectResultObject.Name)/5`",*" -and
            $Body -like "*`"descriptor`": `"Microsoft.IdentityModel.Claims.ClaimsIdentity;788df857-dcd8-444d-885e-bff359bc1982\\test@testuser.com`",*" -and
            $Body -like "*`"allow`": 32,*" -and
            $Body -like "*`"deny`": 512,*" -and
            $Method -eq "Post"
         }
      }

      It 'by ProjectUser only with Allow should return ACEs' {
         Add-VSTeamBuildPermission -Project $projectResultObject -User $userSingleResultObject -Allow DestroyBuilds, DeleteBuildDefinition, AdministerBuildPermissions

         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/33344d9c-fc72-4d6f-aba5-fa317101a7e9*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"$($projectResultObject.Name)`",*" -and
            $Body -like "*`"descriptor`": `"Microsoft.IdentityModel.Claims.ClaimsIdentity;788df857-dcd8-444d-885e-bff359bc1982\\test@testuser.com`",*" -and
            $Body -like "*`"allow`": 20512,*" -and
            $Body -like "*`"deny`": 0,*" -and
            $Method -eq "Post"
         }
      }

      It 'by ProjectUser only with Deny should return ACEs' {

         Add-VSTeamBuildPermission -Project $projectResultObject -User $userSingleResultObject -Deny StopBuilds, QueueBuilds, EditBuildDefinition

         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/33344d9c-fc72-4d6f-aba5-fa317101a7e9*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"$($projectResultObject.Name)`",*" -and
            $Body -like "*`"descriptor`": `"Microsoft.IdentityModel.Claims.ClaimsIdentity;788df857-dcd8-444d-885e-bff359bc1982\\test@testuser.com`",*" -and
            $Body -like "*`"allow`": 0,*" -and
            $Body -like "*`"deny`": 2688,*" -and
            $Method -eq "Post"
         }
      }

      It 'by ProjectUser without Deny and Allow should return ACEs with a warning' {

         $warnings = $null
         Add-VSTeamBuildPermission -Project $projectResultObject -User $userSingleResultObject `
         -WarningVariable warnings 3> $null

         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/33344d9c-fc72-4d6f-aba5-fa317101a7e9*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"$($projectResultObject.Name)`",*" -and
            $Body -like "*`"descriptor`": `"Microsoft.IdentityModel.Claims.ClaimsIdentity;788df857-dcd8-444d-885e-bff359bc1982\\test@testuser.com`",*" -and
            $Body -like "*`"allow`": 0,*" -and
            $Body -like "*`"deny`": 0,*" -and
            $Method -eq "Post"
         }

         $warnings | Should -HaveCount 1
         $warnings[0].Message | Should -Be "Permission masks for Allow and Deny do not inlude any permission. No Permission will change!" -Because "Test should throw warning for missing deny or allow permissions"
      }

      It 'by ProjectGroup should return ACEs' {
         Add-VSTeamBuildPermission -Project $projectResultObject -Group $groupSingleResultObject -Allow DestroyBuilds, DeleteBuildDefinition, AdministerBuildPermissions -Deny StopBuilds, QueueBuilds, EditBuildDefinition

         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/33344d9c-fc72-4d6f-aba5-fa317101a7e9*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"$($projectResultObject.Name)`",*" -and
            $Body -like "*`"descriptor`": `"Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1`",*" -and
            $Body -like "*`"allow`": 20512,*" -and
            $Body -like "*`"deny`": 2688,*" -and
            $Method -eq "Post"
         }
      }

      It 'by ProjectUser which is a service user should return ACEs' {
         Add-VSTeamBuildPermission -Project $projectResultObject -User $srvUserSingleResultObject -Allow DestroyBuilds, DeleteBuildDefinition, AdministerBuildPermissions -Deny StopBuilds, QueueBuilds, EditBuildDefinition

         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/33344d9c-fc72-4d6f-aba5-fa317101a7e9*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"$($projectResultObject.Name)`",*" -and
            $Body -like "*`"descriptor`": `"Microsoft.TeamFoundation.ServiceIdentity;53c67424-6037-4f44-83bd-90b9dfc7d35d:Build:fb855a12-eacc-4ace-9247-6fa867d60629`",*" -and
            $Body -like "*`"allow`": 20512,*" -and
            $Body -like "*`"deny`": 2688,*" -and
            $Method -eq "Post"
         }
      }

      It 'by ProjectDescriptor should return ACEs' {
         Add-VSTeamBuildPermission -Project $projectResultObject -Descriptor "Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1" -Allow DestroyBuilds, DeleteBuildDefinition, AdministerBuildPermissions -Deny StopBuilds, QueueBuilds, EditBuildDefinition

         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/33344d9c-fc72-4d6f-aba5-fa317101a7e9*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"$($projectResultObject.Name)`",*" -and
            $Body -like "*`"descriptor`": `"Microsoft.TeamFoundation.Identity;S-1-9-1551374245-856009726-4193442117-2390756110-2740161821-0-0-0-0-1`",*" -and
            $Body -like "*`"allow`": 20512,*" -and
            $Body -like "*`"deny`": 2688,*" -and
            $Method -eq "Post"
         }
      }
   }
   
}
