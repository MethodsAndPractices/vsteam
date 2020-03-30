class VSTeamPermissionInheritance {
   [string]$Token = $null
   [string]$Version = $null
   [string]$ProjectID = $null
   [string]$SecurityNamespaceID = $null

   VSTeamPermissionInheritance(
      [string]$projectName,
      [string]$resourceName,
      [string]$resourceType
   ) {
      $this.ProjectID = (Get-VSTeamProject -Name $projectName | Select-Object -ExpandProperty id)
      
      Switch ($resourceType) {
         "Repository" {
            $this.SecurityNamespaceID = "2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87"

            $repositoryID = (Get-VSTeamGitRepository -Name "$resourceName" -projectName $projectName | Select-Object -ExpandProperty id )

            if ($null -eq $repositoryID) {
               Write-Error "Unable to retrieve repository information. Ensure that the resourceName provided matches a repository name exactly."
               Return
            }

            $this.Token = "repoV2/$($this.ProjectID)/$repositoryID"

            $this.Version = "$(_getApiVersion Git)"
         }

         "BuildDefinition" {
            $this.SecurityNamespaceID = "33344d9c-fc72-4d6f-aba5-fa317101a7e9"

            $buildDefinitionID = (Get-VSTeamBuildDefinition -projectName $projectName | Where-Object name -eq "$resourceName" | Select-Object -ExpandProperty id )

            if ($null -eq $buildDefinitionID) {
               Write-Error "Unable to retrieve build definition information. Ensure that the resourceName provided matches a build definition name exactly."
               Return
            }

            $this.Token = "$($this.ProjectID)/$buildDefinitionID"

            $this.Version = "$(_getApiVersion Build)"
         }

         "ReleaseDefinition" {
            $this.SecurityNamespaceID = "c788c23e-1b46-4162-8f5e-d7585343b5de"

            $releaseDefinition = (Get-VSTeamReleaseDefinition -projectName $projectName | Where-Object -Property name -eq "$resourceName" )

            if ($null -eq $releaseDefinition) {
               Write-Error "Unable to retrieve release definition information. Ensure that the resourceName provided matches a release definition name exactly."
               Return
            }

            if (($releaseDefinition).path -eq "/") {
               $this.Token = "$($this.ProjectID)/$($releaseDefinition.id)"
            }
            else {
               $this.Token = "$($this.ProjectID)" + "$($releaseDefinition.path -replace "\\","/")" + "/$($releaseDefinition.id)"
            }

            $this.Version = "$(_getApiVersion Release)"
         }
      }
   }
}