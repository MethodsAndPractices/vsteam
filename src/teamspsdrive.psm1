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
                       - Environment 1
                           - Attempt 1
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
   VSAccount(
      [string]$name) : base($name) {
   }

   [object[]] GetChildItem() {
      $Projects = Get-VSTeamProject

      $obj = @()
      
      foreach ($Project in $Projects) {                 
         $obj += [Project]::new(
            $Project.name,
            $Project.id,
            $Project.description)
      }

      return $obj;
   }
}

[SHiPSProvider(UseCache = $true)]
class Project : SHiPSDirectory {
    
   [string]$ProjectId = $null
   [string]$ProjectName = $null
   [string]$ProjectDescription = $null

   Project (
      [string]$ProjectName,
      [string]$ProjectId,
      [string]$ProjectDescription) : base($ProjectName) {
      $this.ProjectId = $ProjectId
      $this.ProjectName = $ProjectName
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
   Builds(
      [string]$name,
      [string]$ProjectName) : base($name) {
      $this.ProjectName = $ProjectName
   }

   [object[]] GetChildItem() {      
      $Builds = Get-VSTeamBuild -ProjectName $this.ProjectName -ErrorAction SilentlyContinue
      
      $obj = @()

      foreach ($Build in $Builds) {                 
         $obj += [Build]::new(
            $Build.definition.fullname, 
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
   [int]$id = $null
   [datetime]$starttime
   [string]$status = $null
   [string]$result = $null
   [string]$buildNumber = $null
   [string]$projectname = $null
   [string]$BuildDefinition = $null
   [string]$requestedByUser = $null
   [string]$requestedForUser = $null

   Build (
      [string]$BuildDefinition, 
      [string]$buildNumber, 
      [string]$status, 
      [string]$result, 
      [datetime]$starttime, 
      [string]$requestedByUser,
      [string]$requestedForUser,
      [string]$projectname,
      [int]$id) : base($buildNumber) {
      $this.id = $id
      $this.status = $status
      $this.result = $result
      $this.starttime = $starttime
      $this.buildNumber = $buildNumber
      $this.projectname = $projectname
      $this.BuildDefinition = $BuildDefinition
      $this.requestedByUser = $requestedByUser
      $this.requestedForUser = $requestedForUser
   }
}

[SHiPSProvider(UseCache = $true)]
class Releases : SHiPSDirectory {

   [string]$ProjectName = $null
    
   # Default constructor
   Releases(
      [string]$name,
      [string]$ProjectName) : base($name) {
      $this.ProjectName = $ProjectName
   }

   [object[]] GetChildItem() {
      $Releases = Get-VSTeamRelease -ProjectName $this.ProjectName -Expand environments -ErrorAction SilentlyContinue

      $obj = @()

      foreach ($Release in $Releases) {
         $obj += [Release]::new(
            $Release.id, 
            $Release.name, 
            $Release.status,
            $Release.createdOn, 
            $Release.environments,
            $Release.createdByUser,
            $this.ProjectName)
      }

      return $obj;
   }
}

[SHiPSProvider(UseCache = $true)]
class Release : SHiPSDirectory {
   [string]$id = $null
   [string]$status = $null
   [string]$releasename = $null
   [string]$ProjectName = $null
   [object]$environments = $null
   [string]$createdByUser = $null
   [datetime]$createdOn #DateTime is not nullable

   Release (
      [int]$id, 
      [string]$releasename, 
      [string]$status,
      [datetime]$createdOn,
      [object]$environments, 
      [string]$createdByUser,
      [string]$ProjectName) : base($releasename) {
      $this.id = $id
      $this.status = $status
      $this.createdOn = $createdOn
      $this.ProjectName = $ProjectName  
      $this.releasename = $releasename
      $this.environments = $environments
      $this.createdByUser = $createdByUser     
   } 

   [object[]] GetChildItem() {
      $Envs = Get-VSTeamRelease -ProjectName $this.projectName -Id $this.id -Expand Environments | Select-Object -ExpandProperty Environments
      
      $obj = @()

      foreach ($Env in $Envs) {
         $obj += [Environment]::new(
            $Env.name,
            $Env.status,
            $this.projectname, 
            $this.id,
            $Env.Id)
      }      

      return $obj;
   }
}

[SHiPSProvider(UseCache = $true)]
class Environment : SHiPSDirectory {
   [string]$status = $null
   [int]$releaseId = $null
   [int]$environmentid = $null
   [string]$projectname = $null

   Environment ( 
      [string]$name,
      [string]$status,
      [string]$projectname,
      [int]$releaseId,
      [int]$environmentid) : base($name) {
      $this.status = $status
      $this.releaseId = $releaseId
      $this.projectname = $projectname
      $this.environmentid = $environmentid
   }

   [object[]] GetChildItem() {
      $Attempts = Get-VSTeamRelease -ProjectName $this.projectName -Id $this.releaseId -Expand Environments `
         | Select-Object -ExpandProperty environments `
         | Where-Object id -eq $this.environmentid `
         | Select-Object -ExpandProperty deploysteps
      
      $obj = @()
      
      foreach ($Attempt in $Attempts) {       
         $obj += [Attempt]::new(
            "Attempt $($Attempt.Attempt)",
            $Attempt.status,
            $this.projectname,
            $this.releaseId,
            $this.environmentid,
            $Attempt.id)
      }
      
      return $obj;
   }
}

[SHiPSProvider(UseCache = $true)]
class Attempt: SHiPSDirectory {
   [string]$status = $null
   [int]$releaseId = $null
   [int]$attemptid = $null
   [int]$environmentid = $null
   [string]$projectname = $null

   Attempt ( 
      [string]$name,
      [string]$status,
      [string]$projectname,
      [int]$releaseId,
      [int]$environmentid,
      [int]$attemptid) : base($name) {
      $this.status = $status
      $this.attemptid = $attemptid
      $this.releaseId = $releaseId
      $this.projectname = $projectname
      $this.environmentid = $environmentid
   }

   [object[]] GetChildItem() {
      $Tasks = Get-VSTeamRelease -ProjectName $this.projectName -Id $this.releaseId -Expand Environments `
         | Select-Object -ExpandProperty environments `
         | Where-Object id -eq $this.environmentid `
         | Select-Object -ExpandProperty deploysteps `
         | Where-Object id -eq $this.attemptid `
         | Select-Object @{Name="Tasks"; Expression={ $_.releaseDeployPhases.deploymentJobs.tasks}} `
         | Select-Object -ExpandProperty tasks
      
      $obj = @()
      
      foreach ($Task in $Tasks) {       
         $obj += [Task]::new(
            $Task.id,
            $Task.name,
            $Task.status,
            $Task.logUrl)
      }
      
      return $obj;
   }
}

class Task : SHiPSLeaf {
   [string]$id = $null
   [string]$logUrl = $null
   [string]$status = $null

   Task (
      [string]$id,
      [string]$name,
      [string]$status,
      [string]$logUrl) : base($name) {
      $this.id = $id
      $this.logUrl = $logUrl
      $this.status = $status
   }
}

[SHiPSProvider(UseCache = $true)]
class Teams : SHiPSDirectory {

   [string]$ProjectName = $null
    
   # Default constructor
   Teams(
      [string]$name,
      [string]$ProjectName) : base($name) {
      $this.ProjectName = $ProjectName
   }

   [object[]] GetChildItem() {
      $Teams = Get-VSTeam -ProjectName $this.ProjectName -ErrorAction SilentlyContinue
      
      $obj = @()
      
      foreach ($Team in $Teams) {       
         $obj += [Team]::new(
            $Team.id,
            $Team.name,
            $Team.ProjectName,
            $Team.description)
      }
      
      return $obj;
   }
}

class Team : SHiPSLeaf {
   [string]$TeamId = $null
   [string]$TeamName = $null    
   [string]$TeamProjectName = $null
   [string]$TeamDescription = $null

   Team (
      [string]$TeamId,
      [string]$TeamName,
      [string]$TeamProjectName, 
      [string]$TeamDescription) : base($TeamName) {
      $this.TeamId = $TeamId
      $this.TeamName = $TeamName
      $this.TeamProjectName = $TeamProjectName
      $this.TeamDescription = $TeamDescription
   }
}