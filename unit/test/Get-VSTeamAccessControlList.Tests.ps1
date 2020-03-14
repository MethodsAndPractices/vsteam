Set-StrictMode -Version Latest

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamLeaf.ps1"
. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Classes/VSTeamSecurityNamespace.ps1"
. "$here/../../Source/Classes/VSTeamAccessControlEntry.ps1"
. "$here/../../Source/Classes/VSTeamAccessControlList.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/$sut"

$accessControlListResult =
@"
{
   "count": 5,
   "value": [
     {
       "inheritPermissions": true,
       "token": "1ba198c0-7a12-46ed-a96b-f4e77554c6d4",
       "acesDictionary": {
         "Microsoft.TeamFoundation.Identity;S-1-9-1551374245-1204400969-2402986413-2179408616-0-0-0-0-1": {
           "descriptor": "Microsoft.TeamFoundation.Identity;S-1-9-1551374245-1204400969-2402986413-2179408616-0-0-0-0-1",
           "allow": 31,
           "deny": 0
         },
         "Microsoft.TeamFoundation.Identity;S-1-9-1551374245-1204400969-2402986413-2179408616-0-0-0-0-2": {
           "descriptor": "Microsoft.TeamFoundation.Identity;S-1-9-1551374245-1204400969-2402986413-2179408616-0-0-0-0-2",
           "allow": 31,
           "deny": 0
         },
         "Microsoft.TeamFoundation.Identity;S-1-9-1551374245-1204400969-2402986413-2179408616-0-0-0-0-3": {
           "descriptor": "Microsoft.TeamFoundation.Identity;S-1-9-1551374245-1204400969-2402986413-2179408616-0-0-0-0-3",
           "allow": 1,
           "deny": 0
         }
       }
     },
     {
       "inheritPermissions": true,
       "token": "1ba198c0-7a12-46ed-a96b-f4e77554c6d4\\846cd9c3-56ba-4158-b6d2-23a3a73244e5",
       "acesDictionary": {
         "Microsoft.TeamFoundation.Identity;S-1-9-1551374245-1204400969-2402986413-2179408616-0-0-0-1-2": {
           "descriptor": "Microsoft.TeamFoundation.Identity;S-1-9-1551374245-1204400969-2402986413-2179408616-0-0-0-1-2",
           "allow": 8,
           "deny": 0
         }
       }
     },
     {
       "inheritPermissions": true,
       "token": "28b9bb88-a513-4115-9b5c-8be39ce1f1ba",
       "acesDictionary": {
         "Microsoft.TeamFoundation.Identity;S-1-9-1551374245-2294004008-329585985-2606533603-2632053178-0-0-0-0-1": {
           "descriptor": "Microsoft.TeamFoundation.Identity;S-1-9-1551374245-2294004008-329585985-2606533603-2632053178-0-0-0-0-1",
           "allow": 31,
           "deny": 0
         },
         "Microsoft.TeamFoundation.Identity;S-1-9-1551374245-2294004008-329585985-2606533603-2632053178-0-0-0-0-2": {
           "descriptor": "Microsoft.TeamFoundation.Identity;S-1-9-1551374245-2294004008-329585985-2606533603-2632053178-0-0-0-0-2",
           "allow": 31,
           "deny": 0
         },
         "Microsoft.TeamFoundation.Identity;S-1-9-1551374245-2294004008-329585985-2606533603-2632053178-0-0-0-0-3": {
           "descriptor": "Microsoft.TeamFoundation.Identity;S-1-9-1551374245-2294004008-329585985-2606533603-2632053178-0-0-0-0-3",
           "allow": 1,
           "deny": 0
         }
       }
     },
     {
       "inheritPermissions": false,
       "token": "token1",
       "acesDictionary": {
         "Microsoft.TeamFoundation.Identity;S-1-9-1551374245-1204400969-2402986413-2179408616-0-0-0-0-1": {
           "descriptor": "Microsoft.TeamFoundation.Identity;S-1-9-1551374245-1204400969-2402986413-2179408616-0-0-0-0-1",
           "allow": 31,
           "deny": 0
         }
       }
     },
     {
       "inheritPermissions": false,
       "token": "token2",
       "acesDictionary": {
         "Microsoft.TeamFoundation.Identity;S-1-9-1551374245-1204400969-2402986413-2179408616-0-0-0-0-1": {
           "descriptor": "Microsoft.TeamFoundation.Identity;S-1-9-1551374245-1204400969-2402986413-2179408616-0-0-0-0-1",
           "allow": 1,
           "deny": 0
         },
         "Microsoft.TeamFoundation.Identity;S-1-9-1551374245-1204400969-2402986413-2179408616-0-0-0-0-2": {
           "descriptor": "Microsoft.TeamFoundation.Identity;S-1-9-1551374245-1204400969-2402986413-2179408616-0-0-0-0-2",
           "allow": 8,
           "deny": 0
         }
       }
     }
   ]
 }
"@ | ConvertFrom-Json

$securityNamespace = 
@"
{
   "count": 1,
   "value": [
     {
       "namespaceId": "58450c49-b02d-465a-ab12-59ae512d6531",
       "name": "Analytics",
       "displayName": "Analytics",
       "separatorValue": "/",
       "elementLength": -1,
       "writePermission": 2,
       "readPermission": 1,
       "dataspaceCategory": "Default",
       "actions": [
         {
           "bit": 1,
           "name": "Read",
           "displayName": "View analytics",
           "namespaceId": "58450c49-b02d-465a-ab12-59ae512d6531"
         },
         {
           "bit": 2,
           "name": "Administer",
           "displayName": "Manage analytics permissions",
           "namespaceId": "58450c49-b02d-465a-ab12-59ae512d6531"
         },
         {
           "bit": 4,
           "name": "Stage",
           "displayName": "Push the data to staging area",
           "namespaceId": "58450c49-b02d-465a-ab12-59ae512d6531"
         },
         {
           "bit": 8,
           "name": "ExecuteUnrestrictedQuery",
           "displayName": "Execute query without any restrictions on the query form",
           "namespaceId": "58450c49-b02d-465a-ab12-59ae512d6531"
         },
         {
           "bit": 16,
           "name": "ReadEuii",
           "displayName": "Read EUII data",
           "namespaceId": "58450c49-b02d-465a-ab12-59ae512d6531"
         }
       ],
       "structureValue": 1,
       "extensionType": null,
       "isRemotable": false,
       "useTokenTranslator": false,
       "systemBitMask": 30
     }
   ]
 }
"@ | ConvertFrom-Json

$securityNamespaceObject = [VSTeamSecurityNamespace]::new($securityNamespace.value)
  
Describe 'Get-VSTeamAccessControlList' {
   # Set the account to use for testing. A normal user would do this
   # using the Set-VSTeamAccount function.
   Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable
   
   # You have to set the version or the api-version will not be added when
   # [VSTeamVersions]::Core = ''
   [VSTeamVersions]::Core = '5.0'

   Context 'Get-VSTeamAccessControlList by SecurityNamespaceId' {
      Mock Invoke-RestMethod {
         # If this test fails uncomment the line below to see how the mock was called.
         # Write-Host $args

         return $accessControlListResult
      } -Verifiable

      Get-VSTeamAccessControlList -SecurityNamespaceId 5a27515b-ccd7-42c9-84f1-54c998f03866 -Token "SomeToken" -Descriptors "SomeDescriptor" -IncludeExtendedInfo -Recurse

      It 'Should return ACLs' {
         Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrollists/5a27515b-ccd7-42c9-84f1-54c998f03866*" -and
            $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
            $Uri -like "*descriptors=SomeDescriptor*" -and
            $Uri -like "*includeExtendedInfo=True*" -and
            $Uri -like "*token=SomeToken*" -and
            $Uri -like "*recurse=True*" -and
            $Method -eq "Get"
         }
      }
   }

   Context 'Get-VSTeamAccessControlList by SecurityNamespace' {
      Mock Get-VSTeamSecurityNamespace { return $securityNamespaceObject }
      Mock Invoke-RestMethod { return $accessControlListResult } -Verifiable

      $securityNamespace = Get-VSTeamSecurityNamespace -Id "58450c49-b02d-465a-ab12-59ae512d6531"
      Get-VSTeamAccessControlList -SecurityNamespace $securityNamespace -Token "SomeToken" -Descriptors "SomeDescriptor" 

      It 'Should return ACLs' {
         Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrollists/58450c49-b02d-465a-ab12-59ae512d6531*" -and
            $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
            $Uri -like "*descriptors=SomeDescriptor*" -and
            $Uri -like "*token=SomeToken*" -and
            $Method -eq "Get"
         }
      }
   }

   Context 'Get-VSTeamAccessControlList by SecurityNamespace (pipeline)' {
      Mock Get-VSTeamSecurityNamespace { return $securityNamespaceObject }
      Mock Invoke-RestMethod { return $accessControlListResult } -Verifiable

      Get-VSTeamSecurityNamespace -Id "58450c49-b02d-465a-ab12-59ae512d6531" | `
         Get-VSTeamAccessControlList -Token "SomeToken" -Descriptors "SomeDescriptor" 

      It 'Should return ACEs' {
         Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrollists/58450c49-b02d-465a-ab12-59ae512d6531*" -and
            $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
            $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
            $Uri -like "*descriptors=SomeDescriptor*" -and
            $Uri -like "*token=SomeToken*" -and
            $Method -eq "Get"
         }
      }
   }

   Context 'Get-VSTeamAccessControlList by securityNamespaceId throws' {
      Mock Invoke-RestMethod { throw 'Error' }

      It 'Should throw' {
         { Get-VSTeamAccessControlList -SecurityNamespaceId 5a27515b-ccd7-42c9-84f1-54c998f03866 -Token "SomeToken" -Descriptors "SomeDescriptor" -IncludeExtendedInfo -Recurse } | Should Throw
      }
   }

   Context 'Get-VSTeamAccessControlList by SecurityNamespace throws' {
      Mock Get-VSTeamSecurityNamespace { return $securityNamespaceObject }
      Mock Invoke-RestMethod { throw 'Error' }

      $securityNamespace = Get-VSTeamSecurityNamespace -Id "5a27515b-ccd7-42c9-84f1-54c998f03866"

      It 'Should throw' {
         { Get-VSTeamAccessControlList  -SecurityNamespace $securityNamespace -Token "SomeToken" -Descriptors "SomeDescriptor" -IncludeExtendedInfo -Recurse } | Should Throw
      }
   }
}