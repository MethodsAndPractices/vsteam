<#
    Modeling a VSTeam for example:

    Project 
          - Project1
          - Project2
                - Build
                    - Build1
                    - Build2
                - Release
                    - Release1
                    - Release2



    Assuming you have done git clone and run build.ps1, cd to your git clone folder and try the following.

    Import-Module  SHiPS                         
    Import-Module  .\VSTeamPSDrive.psm1

    new-psdrive -name VSTeam -psprovider SHiPS -root VSTeamPSDrive#VSTeam
    cd VSTeam:
    dir
#>
using namespace Microsoft.PowerShell.SHiPS

[SHiPSProvider(UseCache = $true)]
class VSAccount : SHiPSDirectory {
    
    # Default constructor
    VSAccount([string]$name):base($name) {
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

    Project ([string]$ProjectName, [string]$ProjectId, [string]$ProjectDescription): base($ProjectName) {
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
    Builds([string]$name, [string]$ProjectName):base($name) {
        $this.ProjectName = $ProjectName
    }

    [object[]] GetChildItem() {
        $obj = @()
        $Builds = Get-VSTeamBuild -ProjectName $this.ProjectName -ErrorAction SilentlyContinue
        foreach ($Build in $Builds) {                 
            $obj += [Build]::new($Build.definition.fullname, $Build.buildnumber, $Build.status, $Build.result, $Build.starttime, $Build.requestedByUser)
        }
        return $obj;
    }
}

class Build : SHiPSLeaf {
    [string]$BuildDefinition = $null
    [string]$BuildNumber = $null
    [string]$BuildStatus = $null
    [string]$BuildResult = $null
    [string]$BuildStartTime = $null
    [string]$BuildRequestedByUser = $null

    Build ([string]$BuildDefinition, [string]$BuildNumber, [string]$BuildStatus, [string]$BuildResult, [string]$BuildStartTime, [string]$BuildRequestedByUser): base($BuildNumber) {
        $this.BuildDefinition = $BuildDefinition
        $this.BuildNumber = $BuildNumber
        $this.BuildStatus = $BuildStatus
        $this.BuildResult = $BuildResult
        $this.BuildStartTime = $BuildStartTime
        $this.BuildRequestedByUser = $BuildRequestedByUser
    }
}

[SHiPSProvider(UseCache = $true)]
class Releases : SHiPSDirectory {

    [string]$ProjectName = $null
    
    # Default constructor
    Releases([string]$name, [string]$ProjectName):base($name) {
        $this.ProjectName = $ProjectName
    }

    [object[]] GetChildItem() {
        $obj = @()
        $Releases = Get-VSTeamRelease -ProjectName $this.ProjectName -ErrorAction SilentlyContinue
        foreach ($Release in $Releases) {
            #$CreatedOn = [DateTime]::ParseExact($Release.createdOn, "yyyy-MM-ddTHH:mm:ss.ffK", $null).ToUniversalTime()  
            #Create array with status info from Environments.
            $EnvironmentStatus = @($Release.Environments.status.environments.status -join ',')          
            $obj += [Release]::new($Release.id, $Release.name, $Release.status, $Release.createdByUser, $Release.createdOn, $EnvironmentStatus)
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
    [string[]]$Environments = $null

    Release ([string]$ReleaseId, [string]$ReleaseName, [string]$ReleaseStatus, [string]$CreatedByUser, [string]$CreatedOn, [array]$Environments): base($ReleaseName) {
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
    Teams([string]$name, [string]$ProjectName):base($name) {
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

    Team ([string]$TeamId, [string]$TeamName, [string]$TeamProjectName, [string]$TeamDescription): base($TeamName) {
        $this.TeamId = $TeamId
        $this.TeamName = $TeamName
        $this.TeamProjectName = $TeamProjectName
        $this.TeamDescription = $TeamDescription
    }
}