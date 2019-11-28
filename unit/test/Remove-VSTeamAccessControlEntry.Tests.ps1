Set-StrictMode -Version Latest

InModuleScope VSTeam {

   # Set the account to use for testing. A normal user would do this
   # using the Set-VSTeamAccount function.
   [VSTeamVersions]::Account = 'https://dev.azure.com/test'

$securityNamespace = 
@"
{
    "DisplayName":  "Git Repositories",
    "SeparatorValue":  "/",
    "ElementLength":  -1,
    "WritePermission":  8192,
    "ReadPermission":  2,
    "DataspaceCategory":  "Git",
    "StructureValue":  "1",
    "ExtensionType":  "Microsoft.TeamFoundation.Git.Server.Plugins.GitSecurityNamespaceExtension",
    "IsRemotable":  true,
    "UseTokenTranslator":  true,
    "SystemBitMask":  0,
    "Actions":  [
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
                        "Bit":  16384
                    },
                    {
                        "DisplayName":  "Bypass policies when completing pull requests",
                        "Name":  "PullRequestBypassPolicy",
                        "Bit":  32768
                    }
                ],
    "ID":  "2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87",
    "ProjectName":  "",
    "DisplayMode":  "------",
    "Name":  "Git Repositories"
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