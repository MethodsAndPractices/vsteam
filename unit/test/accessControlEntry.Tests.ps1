Set-StrictMode -Version Latest

InModuleScope VSTeam {

   # Set the account to use for testing. A normal user would do this
   # using the Set-VSTeamAccount function.
   [VSTeamVersions]::Account = 'https://dev.azure.com/test'

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
  
   Describe 'AccessControlEntry VSTS' {
      # You have to set the version or the api-version will not be added when
      # [VSTeamVersions]::Core = ''
      [VSTeamVersions]::Core = '5.0'

      Context 'Add-VSTeamAccessControlEntry by SecurityNamespaceId' {
         Mock Invoke-RestMethod {
            # If this test fails uncomment the line below to see how the mock was called.
            # Write-Host $args

            return $accessControlEntryResult
         } -Verifiable

         Add-VSTeamAccessControlEntry -SecurityNamespaceId 5a27515b-ccd7-42c9-84f1-54c998f03866 -Descriptor abc -Token xyz -AllowMask 12 -DenyMask 15

         It 'Should return ACEs' {
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/5a27515b-ccd7-42c9-84f1-54c998f03866*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
               $Body -like "*`"token`": `"xyz`",*" -and
               $Body -like "*`"descriptor`": `"abc`",*" -and
               $Body -like "*`"allow`": 12,*" -and
               $Body -like "*`"deny`": 15,*" -and
               $ContentType -eq "application/json" -and
               $Method -eq "Post"
            }
         }
      }

      Context 'Add-VSTeamAccessControlEntry by SecurityNamespace' {
         Mock Get-VSTeamSecurityNamespace { return $securityNamespaceObject }
         Mock Invoke-RestMethod { return $accessControlEntryResult } -Verifiable

         $securityNamespace = Get-VSTeamSecurityNamespace -Id "58450c49-b02d-465a-ab12-59ae512d6531"
         Add-VSTeamAccessControlEntry -SecurityNamespace $securityNamespace -Descriptor abc -Token xyz -AllowMask 12 -DenyMask 15

         It 'Should return ACEs' {
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/58450c49-b02d-465a-ab12-59ae512d6531*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
               $Body -like "*`"token`": `"xyz`",*" -and
               $Body -like "*`"descriptor`": `"abc`",*" -and
               $Body -like "*`"allow`": 12,*" -and
               $Body -like "*`"deny`": 15,*" -and
               $ContentType -eq "application/json" -and
               $Method -eq "Post"
            }
         }
      }

      Context 'Add-VSTeamAccessControlEntry by SecurityNamespace (pipeline)' {
         Mock Get-VSTeamSecurityNamespace { return $securityNamespaceObject }
         Mock Invoke-RestMethod { return $accessControlEntryResult } -Verifiable

         Get-VSTeamSecurityNamespace -Id "58450c49-b02d-465a-ab12-59ae512d6531" | `
            Add-VSTeamAccessControlEntry -Descriptor abc -Token xyz -AllowMask 12 -DenyMask 15

         It 'Should return ACEs' {
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/58450c49-b02d-465a-ab12-59ae512d6531*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
               $Body -like "*`"token`": `"xyz`",*" -and
               $Body -like "*`"descriptor`": `"abc`",*" -and
               $Body -like "*`"allow`": 12,*" -and
               $Body -like "*`"deny`": 15,*" -and
               $ContentType -eq "application/json" -and
               $Method -eq "Post"
            }
         }
      }

      Context 'Add-VSTeamAccessControlEntry by securityNamespaceId throws' {
         Mock Invoke-RestMethod { throw 'Error' }

         It 'Should throw' {
            { Add-VSTeamAccessControlEntry -SecurityNamespaceId 5a27515b-ccd7-42c9-84f1-54c998f03866 -Descriptor abc -Token xyz -AllowMask 12 -DenyMask 15 } | Should Throw
         }
      }

      Context 'Add-VSTeamAccessControlEntry by SecurityNamespace throws' {
         Mock Get-VSTeamSecurityNamespace { return $securityNamespaceObject }
         Mock Invoke-RestMethod { throw 'Error' }

         $securityNamespace = Get-VSTeamSecurityNamespace -Id "5a27515b-ccd7-42c9-84f1-54c998f03866"

         It 'Should throw' {
            { Add-VSTeamAccessControlEntry -SecurityNamespace $securityNamespace -Descriptor abc -Token xyz -AllowMask 12 -DenyMask 15  } | Should Throw
         }
      }
   }
}