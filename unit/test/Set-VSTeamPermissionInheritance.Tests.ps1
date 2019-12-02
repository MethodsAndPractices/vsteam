Set-StrictMode -Version Latest

InModuleScope VSTeam {

    # Set the account and API versions to use for testing. A normal user would do this
    # using the Set-VSTeamAccount function.
    [VSTeamVersions]::Account = 'https://dev.azure.com/test'
    [VSTeamVersions]::Git = '5.1-preview'
    [VSTeamVersions]::Release = '5.1-preview'
    [VSTeamVersions]::Build = '5.0-preview'

    # Set the project to use for testing. A normal user would do this
    # using the Set-VSTeamDefaultProject function
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
    "ProjectName":  "ProjectName",
    "Name":  "ProjectName"
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
    "ProjectName":  "$env:TEAM_PROJECT",
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
    "ProjectName":  "$env:TEAM_PROJECT",
    "DisplayMode":  "------",
    "Name":  "Release-Name"
}
"@ | ConvertFrom-Json

        $callAPIReturn = @"
{
    "dataProviderSharedData":{},
    "dataProviders":
    {
        "ms.vss-web.component-data":{},
        "ms.vss-web.shared-data": null,
        "ms.vss-admin-web.security-view-update-data-provider": 
        {
            "statusCode": 204,
            "statusDescription": null
        }
    }
}
"@ | ConvertFrom-Json 
        $inheritenceCheckReturn = $false

        Mock Get-VSTeamProject { return $projectIDReturn } -Verifiable
        Mock Get-VSTeamGitRepository { return $repositoryIDReturn } -Verifiable
        Mock Get-VSTeamBuildDefinition { return $buildDefinitionIDReturn } -Verifiable
        Mock Get-VSTeamReleaseDefinition { return $releaseDefinitionIDReturn } -Verifiable
        Mock Get-VSTeamPermissionInheritance { return $inheritenceCheckReturn } -Verifiable
        Mock _callAPI { return $callAPIReturn } -Verifiable

        Context 'Set-VSTeamPermissionInheritance by Repository name'{
            It 'Should succeed enabling permission inheritance with a properly named repository'{
            Set-VSTeamPermissionInheritance -resourceName "RepositoryName" -resourceType "Repository" -newState $true -confirm:$false | Should be "Inheritance successfully changed for Repository RepositoryName."
            }
            It 'Should succeed disabling permission inheritance with a properly named repository'{
            $inheritenceCheckReturn = $true
            Set-VSTeamPermissionInheritance -resourceName "RepositoryName" -resourceType "Repository" -newState $false -confirm:$false | Should be "Inheritance successfully changed for Repository RepositoryName."
            }
            It 'Should not set the state to true when the state is already true'{
            Mock Get-VSTeamPermissionInheritance { return $true } -Verifiable
            Set-VSTeamPermissionInheritance -resourceName "RepositoryName" -resourceType "Repository" -newState $true -confirm:$false | Should be "Inheritance already set to true. Not executing"
            }
            It 'Should not set the state to false when the state is already false'{
            Mock Get-VSTeamPermissionInheritance { return $false } -Verifiable
            Set-VSTeamPermissionInheritance -resourceName "RepositoryName" -resourceType "Repository" -newState $false -confirm:$false | Should be "Inheritance already set to false. Not executing"
            }
            It 'Should fail when $env:TEAM_PROJECT is not set'{
            Remove-Item Env:\TEAM_PROJECT
            Set-VSTeamPermissionInheritance -resourceName "RepositoryName" -resourceType "Repository" -newState $true -ErrorVariable err -ErrorAction SilentlyContinue -confirm:$false 
            $err.count | should be 1
            $err[0].Exception.Message | Should Be "Unable to retrieve project information. Ensure that Set-VSTeamDefaultProject has been run prior to execution."
            }
            It 'Should fail when the REST API does not return Status Code 204 for a valid repository'{
            new-item env:\TEAM_PROJECT -Value "ProjectName"
            Mock _callAPI { return } -Verifiable
            Set-VSTeamPermissionInheritance -resourceName "RepositoryName" -resourceType "Repository" -newState $true -ErrorVariable err -ErrorAction SilentlyContinue -confirm:$false 
            $err.count | should be 1
            $err[0].Exception.Message | Should Be "Inheritance change failed for Repository RepositoryName."
            }
            It 'Should fail with an improperly named repository'{
            Mock Get-VSTeamGitRepository { return } -Verifiable
            Set-VSTeamPermissionInheritance -resourceName "Not-RepositoryName" -resourceType "Repository" -newState $true -ErrorVariable err -ErrorAction SilentlyContinue -confirm:$false 
            $err.count | should be 1
            $err[0].Exception.Message | Should Be "Unable to retrieve repository information. Ensure that the resourceName provided matches a repository name exactly."
            }
        }
        Context 'Set-VSTeamPermissionInheritance by Build Definition name'{
            It 'Should succeed enabling permission inheritance with a properly named Build Definition'{
            Set-VSTeamPermissionInheritance -resourceName "Build-Name" -resourceType "BuildDefinition" -newState $true -confirm:$false | Should be "Inheritance successfully changed for BuildDefinition Build-Name."
            }
            It 'Should succeed disabling permission inheritance with a properly named Build Definition'{
            $inheritenceCheckReturn = $true
            Set-VSTeamPermissionInheritance -resourceName "Build-Name" -resourceType "BuildDefinition" -newState $false -confirm:$false | Should be "Inheritance successfully changed for BuildDefinition Build-Name."
            }
            It 'Should not set the state to true when the state is already true'{
            $inheritenceCheckReturn = $true 
            Set-VSTeamPermissionInheritance -resourceName "Build-Name" -resourceType "BuildDefinition" -newState $true -confirm:$false | Should be "Inheritance already set to true. Not executing"
            }
            It 'Should not set the state to false when the state is already false'{
            Set-VSTeamPermissionInheritance -resourceName "Build-Name" -resourceType "BuildDefinition" -newState $false -confirm:$false | Should be "Inheritance already set to false. Not executing"
            }
            It 'Should fail when $env:TEAM_PROJECT is not set'{
            Remove-Item Env:\TEAM_PROJECT
            Set-VSTeamPermissionInheritance -resourceName "Build-Name" -resourceType "BuildDefinition" -newState $true -ErrorVariable err -ErrorAction SilentlyContinue -confirm:$false 
            $err.count | should be 1
            $err[0].Exception.Message | Should Be "Unable to retrieve project information. Ensure that Set-VSTeamDefaultProject has been run prior to execution."
            }
            It 'Should fail when the REST API does not return Status Code 204 for a valid build definition'{
            new-item env:\TEAM_PROJECT -Value "ProjectName"
            Mock _callAPI { return } -Verifiable
            Set-VSTeamPermissionInheritance -resourceName "Build-Name" -resourceType "BuildDefinition" -newState $true -ErrorVariable err -ErrorAction SilentlyContinue -confirm:$false 
            $err.count | should be 1
            $err[0].Exception.Message | Should Be "Inheritance change failed for BuildDefinition Build-Name."
            }
            It 'Should fail with an improperly named Build Definition'{
            Mock Get-VSTeamBuildDefinition { return } -Verifiable
            Set-VSTeamPermissionInheritance -resourceName "NotBuild-Name" -resourceType "BuildDefinition" -newState $true -ErrorVariable err -ErrorAction SilentlyContinue -confirm:$false 
            $err.count | should be 1
            $err[0].Exception.Message | Should Be "Unable to retrieve build definition information. Ensure that the resourceName provided matches a build definition name exactly."
            }
        }
        Context 'Set-VSTeamPermissionInheritance by Release Definition name'{
            It 'Should succeed enabling permission inheritance with a properly named Release Definition'{
            Mock Get-VSTeamReleaseDefinition { return $releaseDefinitionIDReturn } -Verifiable
            Set-VSTeamPermissionInheritance -resourceName "Release-Name" -resourceType "ReleaseDefinition" -newState $true -confirm:$false | Should be "Inheritance successfully changed for ReleaseDefinition Release-Name."
            }
            It 'Should succeed disabling permission inheritance with a properly named Release Definition'{
            $inheritenceCheckReturn = $true
            Set-VSTeamPermissionInheritance -resourceName "Release-Name" -resourceType "ReleaseDefinition" -newState $false -confirm:$false | Should be "Inheritance successfully changed for ReleaseDefinition Release-Name."
            }
            It 'Should not set the state to true when the state is already true'{
            $inheritenceCheckReturn = $true 
            Set-VSTeamPermissionInheritance -resourceName "Release-Name" -resourceType "ReleaseDefinition" -newState $true -confirm:$false | Should be "Inheritance already set to true. Not executing"
            }
            It 'Should not set the state to false when the state is already false'{
            Set-VSTeamPermissionInheritance -resourceName "Release-Name" -resourceType "ReleaseDefinition" -newState $false -confirm:$false | Should be "Inheritance already set to false. Not executing"
            }
            It 'Should fail when $env:TEAM_PROJECT is not set'{
            Remove-Item Env:\TEAM_PROJECT
            Set-VSTeamPermissionInheritance -resourceName "Release-Name" -resourceType "ReleaseDefinition" -newState $true -ErrorVariable err -ErrorAction SilentlyContinue -confirm:$false 
            $err.count | should be 1
            $err[0].Exception.Message | Should Be "Unable to retrieve project information. Ensure that Set-VSTeamDefaultProject has been run prior to execution."
            }
            It 'Should fail when the REST API does not return Status Code 204 for a valid release definition'{
            new-item env:\TEAM_PROJECT -Value "ProjectName"
            Mock _callAPI { return } -Verifiable
            Set-VSTeamPermissionInheritance -resourceName "Release-Name" -resourceType "ReleaseDefinition" -newState $true -ErrorVariable err -ErrorAction SilentlyContinue -confirm:$false 
            $err.count | should be 1
            $err[0].Exception.Message | Should Be "Inheritance change failed for ReleaseDefinition Release-Name."
            }
            It 'Should fail with an improperly named Release Definition'{
            Mock Get-VSTeamReleaseDefinition { return } -Verifiable
            Set-VSTeamPermissionInheritance -resourceName "Not-Release-Name" -resourceType "ReleaseDefinition" -newState $true -ErrorVariable err -ErrorAction SilentlyContinue -confirm:$false 
            $err.count | should be 1
            $err[0].Exception.Message | Should Be "Unable to retrieve release definition information. Ensure that the resourceName provided matches a release definition name exactly."
            }
        }
    }
}
