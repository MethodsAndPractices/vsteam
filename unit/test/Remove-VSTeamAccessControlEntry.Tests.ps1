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
    "actions":  [
        {
            "DisplayName":  "Administer",
            "Name":  "Administer",
            "Bit":  1
        },
        {
            "DisplayName":  "Read",
            "Name":  "GenericRead",
            "Bit":  2
        },
        {
            "DisplayName":  "Contribute",
            "Name":  "GenericContribute",
            "Bit":  4
        },
        {
            "DisplayName":  "Force push (rewrite history, delete branches and tags)",
            "Name":  "ForcePush",
            "Bit":  8
        },
        {
            "DisplayName":  "Create branch",
            "Name":  "CreateBranch",
            "Bit":  16
        },
        {
            "DisplayName":  "Create tag",
            "Name":  "CreateTag",
            "Bit":  32
        },
        {
            "DisplayName":  "Manage notes",
            "Name":  "ManageNote",
            "Bit":  64
        },
        {
            "DisplayName":  "Bypass policies when pushing",
            "Name":  "PolicyExempt",
            "Bit":  128
        },
        {
            "DisplayName":  "Create repository",
            "Name":  "CreateRepository",
            "Bit":  256
        },
        {
            "DisplayName":  "Delete repository",
            "Name":  "DeleteRepository",
            "Bit":  512
        },
        {
            "DisplayName":  "Rename repository",
            "Name":  "RenameRepository",
            "Bit":  1024
        },
        {
            "DisplayName":  "Edit policies",
            "Name":  "EditPolicies",
            "Bit":  2048
        },
        {
            "DisplayName":  "Remove others\u0027 locks",
            "Name":  "RemoveOthersLocks",
            "Bit":  4096
        },
        {
            "DisplayName":  "Manage permissions",
            "Name":  "ManagePermissions",
            "Bit":  8192
        },
        {
            "DisplayName":  "Contribute to pull requests",
            "Name":  "PullRequestContribute",
            "Bit":"16384"
        },
        {
            "DisplayName":  "Bypass policies when completing pull requests",
            "Name":  "PullRequestBypassPolicy",
            "Bit":  32768
        }
    ],
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
         It 'Should have a properly constructed URL' {
            Mock _callAPI { return $true } -Verifiable

            Remove-VSTeamAccessControlEntry -SecurityNamespaceId 2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87 -Descriptor "vssgp.Uy0xLTktMTU1MTM3NDI0NS0yMTkxNDc4NTk1LTU1MDM1MzIxOC0yNDM3MjM2NDgzLTQyMjkyNzUyNDktMC0wLTAtOC04" -Token xyz
   
            Assert-MockCalled _callAPI -Exactly -Scope It -Times 1 -ParameterFilter {
               $Url -like "https://dev.azure.com/test/_apis/accesscontrolentries/2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87*" -and
               $Url -like "*api-version=$([VSTeamVersions]::Core)*" -and
               $Url -like "*?token=xyz*" -and
               $Url -like "*&descriptors=Microsoft.TeamFoundation.Identity;S-1*" -and
               $ContentType -eq "application/json" -and
               $Method -eq "Delete"
            }
         }
      }

      Context 'Remove-VSTeamAccessControlEntry by SecurityNamespace' {
         It 'Should have a properly constructed URL' {
            Mock Get-VSTeamSecurityNamespace { return $securityNamespace }
            Mock _callAPI { return $true } -Verifiable
   
            $securityNamespace = Get-VSTeamSecurityNamespace -Id "2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87"
            Remove-VSTeamAccessControlEntry -SecurityNamespace $securityNamespace -Descriptor "vssgp.Uy0xLTktMTU1MTM3NDI0NS0yMTkxNDc4NTk1LTU1MDM1MzIxOC0yNDM3MjM2NDgzLTQyMjkyNzUyNDktMC0wLTAtOC04" -Token xyz 

            Assert-MockCalled _callAPI -Exactly -Scope It -Times 1 -ParameterFilter {
               $Url -like "https://dev.azure.com/test/_apis/accesscontrolentries/2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87*" -and
               $Url -like "*api-version=$([VSTeamVersions]::Core)*" -and
               $Url -like "*?token=xyz*" -and
               $Url -like "*&descriptors=Microsoft.TeamFoundation.Identity;S-1*" -and
               $ContentType -eq "application/json" -and
               $Method -eq "Delete"
            }
         }
      }
   }
}