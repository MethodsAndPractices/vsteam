<#
    Modeling a VSTeam for example:

    Account 
          - Project1
          - Project2
                - Builds
                    - Build1
                    - Build2
                - Releases
                    - Release1
                    - Release2
                - Teams
                    - Team1
                    - Team2



#region Add-TeamAccount 
Add-VSTeamAccount -Account '[accountname]' -PersonalAccessToken '[VSTS Tokenvalue]'
#endregion

#region Create new VSTeam Drive
New-PSDrive -Name VSAccount -PSProvider SHiPS -Root 'VSTeam#VSAccount'
#endregion

#region change directory
Set-Location VSAccount:
#region

#region list Projects
Get-ChildItem
#endregion
#>
using namespace Microsoft.PowerShell.SHiPS

[SHiPSProvider(UseCache = $true)]
class VSAccount : SHiPSDirectory {
    
    # Default constructor
    VSAccount([string]$name) : base($name) {
    }

    [object[]] GetChildItem() {
        $obj = @()

        $Projects = Get-VSTeamProject
        foreach ($Project in $Projects) {                 
            $obj += [Project]::new($Project.name, $Project.id, $Project.description)
        }
        return $obj;
    }
}

[SHiPSProvider(UseCache = $true)]
class Project : SHiPSDirectory {
    
    [string]$ProjectName = $null
    [string]$ProjectId = $null
    [string]$ProjectDescription = $null

    Project ([string]$ProjectName, [string]$ProjectId, [string]$ProjectDescription) : base($ProjectName) {
        $this.ProjectName = $ProjectName
        $this.ProjectId = $ProjectId
        $this.ProjectDescription = $ProjectDescription
    }   
    
    [object[]] GetChildItem() {
        $obj = @()
        $obj += [Builds]::new('Builds', $this.ProjectName);     
        $obj += [Releases]::new('Releases', $this.ProjectName);
        $obj += [Teams]::new('Teams', $this.ProjectName);    
        return $obj;
    }
}

[SHiPSProvider(UseCache = $true)]
class Builds : SHiPSDirectory {

    [string]$ProjectName = $null
    
    # Default constructor
    Builds([string]$name, [string]$ProjectName) : base($name) {
        $this.ProjectName = $ProjectName
    }

    [object[]] GetChildItem() {
        $obj = @()
        $Builds = Get-VSTeamBuild -ProjectName $this.ProjectName -ErrorAction SilentlyContinue
        foreach ($Build in $Builds) {                 
            $obj += [Build]::new($Build.definition.fullname, 
                $Build.buildnumber, 
                $Build.status, 
                $Build.result, 
                $Build.starttime, 
                $Build.requestedByUser,
                $Build.requestedForUser, 
                $Build.projectname,
                $Build.id)
        }
        return $obj;
    }
}

class Build : SHiPSLeaf {
    [string]$BuildDefinition = $null
    [string]$buildNumber = $null
    [string]$status = $null
    [string]$result = $null
    [string]$starttime = $null
    [string]$requestedByUser = $null
    [string]$requestedForUser = $null
    [string]$projectname = $null
    [string]$id = $null

    Build ([string]$BuildDefinition, 
        [string]$buildNumber, 
        [string]$status, 
        [string]$result, 
        [string]$starttime, 
        [string]$requestedByUser,
        [string]$requestedForUser,
        [string]$projectname,
        [int]$id) : base($buildNumber) {
        $this.BuildDefinition = $BuildDefinition
        $this.buildNumber = $buildNumber
        $this.status = $status
        $this.result = $result
        $this.starttime = $starttime
        $this.requestedByUser = $requestedByUser
        $this.requestedForUser = $requestedForUser
        $this.projectname = $projectname
        $this.id = $id
    }
}

[SHiPSProvider(UseCache = $true)]
class Releases : SHiPSDirectory {

    [string]$ProjectName = $null
    
    # Default constructor
    Releases([string]$name, [string]$ProjectName) : base($name) {
        $this.ProjectName = $ProjectName
    }

    [object[]] GetChildItem() {
        $obj = @()
        $Releases = Get-VSTeamRelease -ProjectName $this.ProjectName -Expand environments -ErrorAction SilentlyContinue
        foreach ($Release in $Releases) {
            #$CreatedOn = [DateTime]::ParseExact($Release.createdOn, "yyyy-MM-ddTHH:mm:ss.ffK", $null).ToUniversalTime()  
            #Create array with status info from Environments.
            #$EnvironmentStatus = @($Release.Environments.status.environments.status -join ',')
            <#
            $Environments = @{
                'id'     = $Release.Environments.id
                'name'   = $Release.Environments.name
                'status' = $Release.Environments.status
            } 
            #>    
            $obj += [Release]::new($Release.id, 
                $Release.name, 
                $Release.status, 
                $Release.createdByUser, 
                $Release.createdOn, 
                $Release.environments)
        }
        return $obj;
    }
}

class Release : SHiPSLeaf {
    [string]$ReleaseId = $null
    [string]$ReleaseName = $null
    [string]$ReleaseStatus = $null
    [string]$CreatedByUser = $null
    [string]$CreatedOn = $null
    [object]$Environments = $null

    Release ([string]$ReleaseId, 
        [string]$ReleaseName, 
        [string]$ReleaseStatus, 
        [string]$CreatedByUser, 
        [string]$CreatedOn, 
        [object]$Environments) : base($ReleaseName) {
        $this.ReleaseId = $ReleaseId
        $this.ReleaseName = $ReleaseName
        $this.ReleaseStatus = $ReleaseStatus
        $this.CreatedByUser = $CreatedByUser
        $this.CreatedOn = $CreatedOn
        $this.Environments = $Environments
    }
}

[SHiPSProvider(UseCache = $true)]
class Teams : SHiPSDirectory {

    [string]$ProjectName = $null
    
    # Default constructor
    Teams([string]$name, [string]$ProjectName) : base($name) {
        $this.ProjectName = $ProjectName
    }

    [object[]] GetChildItem() {
        $obj = @()
        $Teams = Get-VSTeam -ProjectName $this.ProjectName -ErrorAction SilentlyContinue
        foreach ($Team in $Teams) {       
            $obj += [Team]::new($Team.id, $Team.name, $Team.ProjectName, $Team.description)
        }
        return $obj;
    }
}


class Team : SHiPSLeaf {
    [string]$TeamId = $null
    [string]$TeamProjectName = $null
    [string]$TeamName = $null    
    [string]$TeamDescription = $null

    Team ([string]$TeamId, [string]$TeamName, [string]$TeamProjectName, [string]$TeamDescription) : base($TeamName) {
        $this.TeamId = $TeamId
        $this.TeamName = $TeamName
        $this.TeamProjectName = $TeamProjectName
        $this.TeamDescription = $TeamDescription
    }
}