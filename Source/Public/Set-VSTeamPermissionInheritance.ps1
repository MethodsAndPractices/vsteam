function Set-VSTeamPermissionInheritance {
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact = 'High')]
    [OutputType([System.String])]
    param(
       [Parameter(Mandatory)]
       [string] $resourceName,
       [Parameter(Mandatory)]  
       [ValidateSet('Repository','BuildDefinition','ReleaseDefinition')]
       [string] $resourceType,
       [Parameter(Mandatory)]  
       [ValidateSet('true', 'false')]
       [string] $newState
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
        
        #Get current inheritance state for resource to see if resource is already in desired state
        $inheritanceCheck = (Get-VSTeamPermissionInheritance -resourceName "$resourceName" -resourceType "$resourceType")
        
        if((($newState -eq "$true") -and ($inheritanceCheck -eq $true)) -or (($newState -eq "$false") -and ($inheritanceCheck -eq $false)))
        {
            Return "Inheritance already set to $newState. Not executing"
        }

        if($PSCmdlet.ShouldProcess("$resourceName")) {
            $body = @"
{
    "contributionIds":["ms.vss-admin-web.security-view-update-data-provider"],
    "dataProviderContext":
    {
        "properties":
        {
            "changeInheritance":true,
            "permissionSetId":"$securityNamespaceID",
            "permissionSetToken":"$token",
            "inheritPermissions":$newState
        }
    }
}
"@
            # Call the REST API to change the inheritance state
            $resp = _callAPI -method POST -area "Contribution" -resource "HierarchyQuery" -id $projectID -Version "$Version" -ContentType "application/json" -Body $body -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
        }
          
        if(($resp | Select-Object -ExpandProperty dataProviders -ErrorAction SilentlyContinue | Select-Object -ExpandProperty 'ms.vss-admin-web.security-view-update-data-provider' -ErrorAction SilentlyContinue | Select-Object -ExpandProperty statusCode -ErrorAction SilentlyContinue) -eq "204")
        {   
            Return "Inheritance successfully changed for $resourceType $resourceName."
        }
        else
        {           
            Write-Error "Inheritance change failed for $resourceType $resourceName."
            Return
        }
    }
}
