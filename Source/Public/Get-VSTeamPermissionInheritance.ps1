function Get-VSTeamPermissionInheritance {
    [OutputType([System.String])]
    [CmdletBinding()]
    param(
       [Parameter(Mandatory)]
       [string] $resourceName,
       [Parameter(Mandatory)]  
       [ValidateSet('Repository','BuildDefinition','ReleaseDefinition')]
       [string] $resourceType
    )
 
    process 
    {
        if($env:TEAM_PROJECT)
        {
            $projectID = (Get-VSTeamProject -Name $env:TEAM_PROJECT -ErrorAction SilentlyContinue | Select-Object -ExpandProperty id -ErrorAction SilentlyContinue)
        }
        else
        {
            Write-Error "Unable to retrieve project information. Ensure that Set-VSTeamDefaultProject has been run prior to execution."
            Return
        }

        Switch($resourceType)
        {
            "Repository"
            {
                $securityNamespaceID = "2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87"

                $repositoryID = (Get-VSTeamGitRepository -Name "$resourceName" -ProjectName "$env:TEAM_PROJECT" -WarningAction SilentlyContinue -ErrorAction SilentlyContinue | Select-Object -ExpandProperty id -ErrorAction SilentlyContinue)

                If($null -eq $repositoryID)
                {
                    Write-Error "Unable to retrieve repository information. Ensure that the resourceName provided matches a repository name exactly."
                    Return
                }

                $token = "repoV2/$projectID/$repositoryID"

                $Version = "$([VSTeamVersions]::Git)"

            }
            "BuildDefinition"
            {
                $securityNamespaceID = "33344d9c-fc72-4d6f-aba5-fa317101a7e9"

                $buildDefinitionID = (Get-VSTeamBuildDefinition -ProjectName $env:team_project -ErrorAction SilentlyContinue | Where-Object name -eq "$resourceName" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty id -ErrorAction SilentlyContinue)

                If($null -eq $buildDefinitionID)
                {
                    Write-Error "Unable to retrieve build definition information. Ensure that the resourceName provided matches a build definition name exactly."
                    Return
                }

                $token = "$projectID/$buildDefinitionID"

                $Version = "$([VSTeamVersions]::Build)"
            }

            "ReleaseDefinition"
            {
                $securityNamespaceID = "c788c23e-1b46-4162-8f5e-d7585343b5de"

                $releaseDefinition = (Get-VSTeamReleaseDefinition -ProjectName $env:team_project -ErrorAction SilentlyContinue | Where-Object -Property name -eq "$resourceName" -ErrorAction SilentlyContinue)

                If($null -eq $releaseDefinition)
                {
                    Write-Error "Unable to retrieve release definition information. Ensure that the resourceName provided matches a release definition name exactly."
                    Return
                }

                if(($releaseDefinition).path -eq "/")
                {
                    $token = "$projectID/$($releaseDefinition.id)"
                }
                else
                {
                    $token = "$projectID"+"$($releaseDefinition.path -replace "\\","/")"+"/$($releaseDefinition.id)"
                }

                $Version = "$([VSTeamVersions]::Release)"
            }
        }
        
        Switch($resourceType)
        {
            "Repository"
            {
                $resp = (Get-VSTeamAccessControlList -SecurityNamespaceId $securityNamespaceID -token $token -ErrorAction SilentlyContinue | Select-Object -ExpandProperty InheritPermissions -ErrorAction SilentlyContinue )
            }

            {($resourceType -eq "BuildDefinition") -or ($resourceType -eq "ReleaseDefinition")}
            {
                $body = @"
{
    "contributionIds":["ms.vss-admin-web.security-view-data-provider"],
    "dataProviderContext":
    {
        "properties":
        {
            "permissionSetId":"$securityNamespaceID",
            "permissionSetToken":"$token",
        }
    }
}
"@
                $resp = (_callAPI -method POST -area "Contribution" -resource "HierarchyQuery/project" -id $projectID -Version "$Version" -ContentType "application/json" -Body $body -ErrorAction SilentlyContinue | Select-Object -ExpandProperty dataProviders -ErrorAction SilentlyContinue | Select-Object -ExpandProperty 'ms.vss-admin-web.security-view-data-provider' -ErrorAction SilentlyContinue | Select-Object -ExpandProperty permissionsContextJson -ErrorAction SilentlyContinue | ConvertFrom-Json | Select-Object -ExpandProperty inheritPermissions -ErrorAction SilentlyContinue)
            } 
        }

        Switch($resp)
        {
            {($resp -eq $true) -or ($resp -eq $false)}
            {
                return $resp
            }

            {($resp -ne $true) -and ($resp -ne $false)}
            {
                Write-Error "Unable to retrieve permission inheritance state."
                return
            }
        }
    }
}
