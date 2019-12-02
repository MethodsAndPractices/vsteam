Set-StrictMode -Version Latest

InModuleScope VSTeam {

    # Set the account and API versions to use for testing. A normal user would do this
    # using the Get-VSTeamAccount function.
    [VSTeamVersions]::Account = 'https://dev.azure.com/test'
    [VSTeamVersions]::Git = '5.1-preview'
    [VSTeamVersions]::Release = '5.1-preview'
    [VSTeamVersions]::Build = '5.0-preview'

    # Set the project to use for testing. A normal user would do this
    # using the Get-VSTeamDefaultProject function
    $env:TEAM_PROJECT = "ProjectName"

  
    Describe 'Toggling permission inheritance'{
        
        $projectIDReturn = @"
{
    "Revision":  133,
    "ID":  "a6296153-733c-4dbf-ae34-d5e756f25591",
    "URL":  "https://dev.azure.com/test/_apis/projects/a6296153-733c-4dbf-ae34-d5e756f25591",
    "State":  "wellFormed",
    "Visibility":  "private",
    "Description":  null,
    "_internalObj":  null,
    "DisplayMode":  "d-----",
    "ProjectName":  "$env:TEAM_PROJECT",
    "Name":  "$env:TEAM_PROJECT"
}
"@ | ConvertFrom-Json

        $repositoryIDReturn = @"
{
    "Size":  8968,
    "ID":  "9213446d-b91f-4460-a005-0aebe2ecad5b",
    "URL":  "https://dev.azure.com/OrganizationName/a6296153-733c-4dbf-ae34-d5e756f25591/_apis/git/repositories/9213446d-b91f-4460-a005-0aebe2ecad5b",
    "sshURL":  "git@ssh.dev.azure.com:v3/OrganizationName/ProjectName/RepositoryName",
    "RemoteURL":  "https://OrganizationName@dev.azure.com/OrganizationName/TeamName/_git/RepositoryName",
    "DefaultBranch":  "refs/heads/master",
    "DisplayMode":  "d-----",
    "OrganizationName":  "OrganizationName",
    "Name":  "RepositoryName"
}
"@ | ConvertFrom-Json

        $buildDefinitionIDReturn = @"
{
    "id":  36,
    "Revision":  1,
    "Path":  "\\",
    "Tags":  null,
    "Options":  null,
    "Triggers":  null,
    "Variables":  null,
    "Repository":  null,
    "Queue":  null,
    "RetentionRules":  null,
    "AuthoredBy":  null,
    "BuildNumberFormat":  "",
    "JobCancelTimeoutInMinutes":  5,
    "JobAuthorizationScope":  "projectCollection",
    "GitRepository":  null,
    "CreatedOn":  "\/Date(1574829999220)\/",
    "Process":  null,
    "Steps":  null,
    "Demands":  null,
    "DisplayMode":  "d-----",
    "ProjectName":  "ProjectName",
    "Name":  "Build-Name"
}
"@ | ConvertFrom-Json

        $releaseDefinitionIDReturn = @"
{
    "Url":  "https://vsrm.dev.azure.com/OrganizationName/a6296153-733c-4dbf-ae34-d5e756f25591/_apis/Release/definitions/4",
    "Path":  "\\PathName",
    "Revision":  1,
    "Tags":  null,
    "Description":  "",
    "isDeleted":  false,
    "Triggers":  null,
    "Artifacts":  null,
    "Variables":  null,
    "Properties":  null,
    "Environments":  null,
    "VariableGroups":  null,
    "ReleaseNameFormat":  null,
    "CreatedBy":  null,
    "ModifiedBy":  null,
    "CreatedOn":  "\/Date(1574831824817)\/",
    "ModifiedOn":  "\/Date(1574831824817)\/",
    "createdByUser":  null,
    "_internalObj":  null,
    "ID":  "4",
    "ProjectName":  "ProjectName",
    "DisplayMode":  "------",
    "Name":  "Release-Name"
}
"@ | ConvertFrom-Json

        $accessControlListReturn = New-Object -TypeName PSObject -Property @{InheritPermissions = "$true"}
        
        $callAPIReturn = @"
{
    "dataProviders":
    {
        "ms.vss-admin-web.security-view-data-provider":
        {
            "permissionsContextJson":
            "{
                \"inheritPermissions\":true
            }"
            
        }
    }
}
"@ | ConvertFrom-Json

        Mock Get-VSTeamProject { return $projectIDReturn } -Verifiable
        Mock Get-VSTeamGitRepository { return $repositoryIDReturn } -Verifiable
        Mock Get-VSTeamBuildDefinition { return $buildDefinitionIDReturn } -Verifiable
        Mock Get-VSTeamReleaseDefinition { return $releaseDefinitionIDReturn } -Verifiable
        Mock Get-VSTeamAccessControlList{ return $accessControlListReturn } -Verifiable
        Mock _callAPI { return $callAPIReturn } -Verifiable

        Context 'Get-VSTeamPermissionInheritance by Repository name'{
            It 'Should succeed retrieving permission inheritance state with a properly named repository'{
            Get-VSTeamPermissionInheritance -resourceName "RepositoryName" -resourceType "Repository" | Should be "$true"
            }
            It 'Should fail when $env:TEAM_PROJECT is not set'{
            Remove-Item Env:\TEAM_PROJECT
            Get-VSTeamPermissionInheritance -resourceName "RepositoryName" -resourceType "Repository" -ErrorVariable err -ErrorAction SilentlyContinue
            $err.count | should be 1
            $err[0].Exception.Message | Should Be "Unable to retrieve project information. Ensure that Set-VSTeamDefaultProject has been run prior to execution."
            }
            It 'Should fail with an improperly named repository'{
            new-item env:\TEAM_PROJECT -Value "ProjectName"
            Mock Get-VSTeamGitRepository { return } -Verifiable
            Get-VSTeamPermissionInheritance -resourceName "Not-RepositoryName" -resourceType "Repository" -ErrorVariable err -ErrorAction SilentlyContinue
            $err.count | should be 1
            $err[0].Exception.Message | Should Be "Unable to retrieve repository information. Ensure that the resourceName provided matches a repository name exactly."
            }
        }
        Context 'Get-VSTeamPermissionInheritance by Build Definition name'{
            It 'Should succeed enabling permission inheritance with a properly named Build Definition'{
            Get-VSTeamPermissionInheritance -resourceName "Build-Name" -resourceType "BuildDefinition" | Should be "$true"
            }
            It 'Should fail when $env:TEAM_PROJECT is not set'{
            Remove-Item Env:\TEAM_PROJECT
            Get-VSTeamPermissionInheritance -resourceName "Build-Name" -resourceType "BuildDefinition" -ErrorVariable err -ErrorAction SilentlyContinue
            $err.count | should be 1
            $err[0].Exception.Message | Should Be "Unable to retrieve project information. Ensure that Set-VSTeamDefaultProject has been run prior to execution."
            }
            It 'Should fail with an improperly named repository'{
            new-item env:\TEAM_PROJECT -Value "ProjectName"
            Mock Get-VSTeamBuildDefinition { return } -Verifiable
            Get-VSTeamPermissionInheritance -resourceName "Build-Name" -resourceType "BuildDefinition" -ErrorVariable err -ErrorAction SilentlyContinue
            $err.count | should be 1
            $err[0].Exception.Message | Should Be "Unable to retrieve build definition information. Ensure that the resourceName provided matches a build definition name exactly."
            }
        }
        Context 'Get-VSTeamPermissionInheritance by Release Definition name'{
            It 'Should succeed enabling permission inheritance with a properly named Release Definition'{
            Get-VSTeamPermissionInheritance -resourceName "Release-Name" -resourceType "ReleaseDefinition" | Should be "$true"
            }
            It 'Should fail when $env:TEAM_PROJECT is not set'{
            Remove-Item Env:\TEAM_PROJECT
            Get-VSTeamPermissionInheritance -resourceName "Release-Name" -resourceType "ReleaseDefinition" -ErrorVariable err -ErrorAction SilentlyContinue
            $err.count | should be 1
            $err[0].Exception.Message | Should Be "Unable to retrieve project information. Ensure that Set-VSTeamDefaultProject has been run prior to execution."
            }
            It 'Should fail with an improperly named release definition'{
            new-item env:\TEAM_PROJECT -Value "ProjectName"
            Mock Get-VSTeamReleaseDefinition { return } -Verifiable
            Get-VSTeamPermissionInheritance -resourceName "Release-Name" -resourceType "ReleaseDefinition" -ErrorVariable err -ErrorAction SilentlyContinue
            $err.count | should be 1
            $err[0].Exception.Message | Should Be "Unable to retrieve release definition information. Ensure that the resourceName provided matches a release definition name exactly."
            }
        }
    }
}
