Set-StrictMode -Version Latest

InModuleScope VSTeam {

   # Set the account to use for testing. A normal user would do this
   # using the Set-VSTeamAccount function.
   [VSTeamVersions]::Account = 'https://dev.azure.com/test'

$securityNamespace = 
@"
{
    "namespaceId":  "2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87",
    "name":  "Git Repositories",
    "displayName":  "Git Repositories",
    "separatorValue":  "/",
    "elementLength":  -1,
    "writePermission":  8192,
    "readPermission":  2,
    "dataspaceCategory":  "Git",
    "actions":  "               ",
    "structureValue":  1,
    "extensionType":  "Microsoft.TeamFoundation.Git.Server.Plugins.GitSecurityNamespaceExtension",
    "isRemotable":  true,
    "useTokenTranslator":  true,
    "systemBitMask":  0
}
"@ | ConvertFrom-Json
  
   Describe 'AccessControlEntry VSTS' {
      # You have to set the version or the api-version will not be Removed when
      # [VSTeamVersions]::Core = ''
      [VSTeamVersions]::Core = '5.1'

      Context 'Remove-VSTeamAccessControlEntry by SecurityNamespaceId' {
         Mock Invoke-RestMethod { return $true }

         Remove-VSTeamAccessControlEntry -SecurityNamespaceId 2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87 -Descriptor "vssgp.Uy0xLTktMTU1MTM3NDI0NS0xODc2Mzk2MjA0LTIwNjc1NTI1ODctMzA2NDY5MTU3My0yNjkxODIxNjgzLTEtMjM0NjY4Mzk3Mi0yNDI0MDE0NjYzLTI5MzAxOTk4OTktMTU1MjUwNTM3MQ" -Token xyz

         It 'Should have a properly constructed URL' {
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
               $Uri -like "*Microsoft.TeamFoundation.Identity;S-1*" -and
               $Uri -like "*?token=xyz*" -and
               $Uri -like "*&descriptors=abc*" -and
               $ContentType -eq "application/json" -and
               $Method -eq "Delete"
            }
         }
      }

      Context 'Remove-VSTeamAccessControlEntry by SecurityNamespace' {
         Mock Get-VSTeamSecurityNamespace { return $securityNamespace }
         Mock Invoke-RestMethod { return $true }

         $securityNamespace = Get-VSTeamSecurityNamespace -Id "2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87"
         Remove-VSTeamAccessControlEntry -SecurityNamespace $securityNamespace -Descriptor "vssgp.Uy0xLTktMTU1MTM3NDI0NS0xODc2Mzk2MjA0LTIwNjc1NTI1ODctMzA2NDY5MTU3My0yNjkxODIxNjgzLTEtMjM0NjY4Mzk3Mi0yNDI0MDE0NjYzLTI5MzAxOTk4OTktMTU1MjUwNTM3MQ" -Token xyz 

         It 'Should have a properly constructed URL' {
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
                $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87*" -and
                $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
                $Uri -like "*Microsoft.TeamFoundation.Identity;S-1*" -and
                $Uri -like "*?token=xyz*" -and
                $Uri -like "*&descriptors=abc*" -and
                $ContentType -eq "application/json" -and
                $Method -eq "Delete"
            }
         }
      }

      Context 'Remove-VSTeamAccessControlEntry by SecurityNamespace (pipeline)' {
         Mock Get-VSTeamSecurityNamespace { return $securityNamespace }
         Mock Invoke-RestMethod { return $true }

         Get-VSTeamSecurityNamespace -Id "2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87" | `
            Remove-VSTeamAccessControlEntry -Descriptor "vssgp.Uy0xLTktMTU1MTM3NDI0NS0xODc2Mzk2MjA0LTIwNjc1NTI1ODctMzA2NDY5MTU3My0yNjkxODIxNjgzLTEtMjM0NjY4Mzk3Mi0yNDI0MDE0NjYzLTI5MzAxOTk4OTktMTU1MjUwNTM3MQ" -Token xyz 

         It 'Should have a properly constructed URL' {
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
                $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87*" -and
                $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
                $Uri -like "*Microsoft.TeamFoundation.Identity;S-1*" -and
                $Uri -like "*?token=xyz*" -and
                $Uri -like "*&descriptors=abc*" -and
                $ContentType -eq "application/json" -and
                $Method -eq "Delete"
            }
         }
      }
   }
}