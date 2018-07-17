<#
   The formatting of the results are controlled in .\formats\vsteamPSDrive.format.ps1xml

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
                     - Task1
                     - Task2
            - Release2
               - Teams
                  - Team1
                  - Team2
         - VSTeamRepositories
            - Repo1
               - Ref1
               - Ref2


#region Add-TeamAccount
Add-VSTeamAccount -Account '[accountname]' -PersonalAccessToken '[VSTS Tokenvalue]'
#endregion

#region Create new VSTeam Drive
New-PSDrive -Name VSTeamAccount -PSProvider SHiPS -Root 'VSTeam#VSTeamAccount'
#endregion

#region change directory
Set-Location VSTeamAccount:
#region

#region list Projects
Get-ChildItem
#endregion
#>
using namespace Microsoft.PowerShell.SHiPS

class VSTeamDirectory : SHiPSDirectory {
   # The object returned from the REST API call
   [object] hidden $_internalObj = $null

   # I want the mode to resemble that of
   # a normal file system.
   # d - Directory
   # a - Archive
   # r - Read-only
   # h - Hidden
   # s - System
   # l - Reparse point, symlink, etc.
   [string] hidden $DisplayMode = 'd-----'

   [string]$ProjectName = $null

   # Default constructor
   VSTeamDirectory(
      [string]$Name,
      [string]$ProjectName
   ) : base($Name) {
      $this.ProjectName = $ProjectName
   }

   [void] hidden AddTypeName(
      [string] $name
   ) {
      # The type is used to identify the correct formatter to use.
      # The format for when it is returned by the function and
      # returned by the provider are different. Adding a type name
      # identifies how to format the type.
      # When returned by calling the function and not the provider.
      # This will be formatted without a mode column.
      # When returned by calling the provider.
      # This will be formatted with a mode column like a file or
      # directory.
      $this.PSObject.TypeNames.Insert(0, $name)
   }
}

class VSTeamLeaf : SHiPSLeaf {
   # The object returned from the REST API call
   [object] hidden $_internalObj = $null

   [string]$ID = $null
   [string]$ProjectName = $null

   # I want the mode to resemble that of
   # a normal file system.
   # d - Directory
   # a - Archive
   # r - Read-only
   # h - Hidden
   # s - System
   # l - Reparse point, symlink, etc.
   [string] hidden $DisplayMode = '------'

   # Default constructor
   VSTeamLeaf(
      [string]$Name,
      [string]$ID,
      [string]$ProjectName
   ) : base($Name) {
      $this.ID = $ID
      $this.ProjectName = $ProjectName
   }

   [void] hidden AddTypeName(
      [string] $name
   ) {
      # The type is used to identify the correct formatter to use.
      # The format for when it is returned by the function and
      # returned by the provider are different. Adding a type name
      # identifies how to format the type.
      # When returned by calling the function and not the provider.
      # This will be formatted without a mode column.
      # When returned by calling the provider.
      # This will be formatted with a mode column like a file or
      # directory.
      $this.PSObject.TypeNames.Insert(0, $name)
   }
}

class VSTeamUser : VSTeamLeaf {
   [string]$DisplayName
   [string]$UniqueName

   VSTeamUser(
      [object]$obj,
      [string]$ProjectName
   ) : base($obj.displayName, $obj.id, $ProjectName) {
      $this.UniqueName = $obj.uniqueName
      $this.DisplayName = $obj.displayName

      $this._internalObj = $obj

      $this.AddTypeName('Team.User')
   }

   [string]ToString() {
      return $this.DisplayName
   }
}

[SHiPSProvider(UseCache = $true)]
[SHiPSProvider(BuiltinProgress = $false)]
class VSTeamAccount : SHiPSDirectory {

   # Default constructor
   VSTeamAccount(
      [string]$Name
   ) : base($Name) {
      $this.AddTypeName('Team.Account')
   }

   [object[]] GetChildItem() {
      $items = Get-VSTeamProject

      foreach ($item in $items) {
         $item.AddTypeName('Team.Provider.Project')
      }

      return $items
   }

   [void] hidden AddTypeName(
      [string] $name
   ) {
      # The type is used to identify the correct formatter to use.
      # The format for when it is returned by the function and
      # returned by the provider are different. Adding a type name
      # identifies how to format the type.
      # When returned by calling the function and not the provider.
      # This will be formatted without a mode column.
      # When returned by calling the provider.
      # This will be formatted with a mode column like a file or
      # directory.
      $this.PSObject.TypeNames.Insert(0, $name)
   }
}

[SHiPSProvider(UseCache = $true)]
[SHiPSProvider(BuiltinProgress = $false)]
class VSTeamProject : VSTeamDirectory {

   [int]$Revision = 0
   [string]$ID = $null
   [string]$URL = $null
   [string]$State = $null
   [string]$Visibility = $null
   [string]$Description = $null

   VSTeamProject (
      [object]$obj
   ) : base($obj.name, $obj.name) {
      $this.ID = $obj.id
      $this.URL = $obj.url
      $this.State = $obj.state
      $this.Revision = $obj.revision
      $this.Visibility = $obj.visibility

      # The description is not always returned so protect yourself.
      if ($obj.PSObject.Properties.Match('description').count -gt 0) {
         $this.Description = $obj.description
      }

      $this._internalObj = $obj

      $this.AddTypeName('Team.Project')
   }

   [string]ToString() {
      return $this.Name
   }

   [object[]] GetChildItem() {
      return @(
         [VSTeamBuilds]::new('Builds', $this.Name),
         [VSTeamReleases]::new('Releases', $this.Name),
         [VSTeamRepositories]::new('Repositories', $this.Name),
         [VSTeamTeams]::new('Teams', $this.Name)
      )
   }
}

[SHiPSProvider(UseCache = $true)]
[SHiPSProvider(BuiltinProgress = $false)]
class VSTeamBuilds : VSTeamDirectory {

   # Default constructor
   VSTeamBuilds(
      [string]$Name,
      [string]$ProjectName
   ) : base($Name, $ProjectName) {
      $this.AddTypeName('Team.Builds')
   }

   [object[]] GetChildItem() {
      $builds = Get-VSTeamBuild -ProjectName $this.ProjectName -ErrorAction SilentlyContinue

      $objs = @()

      foreach ($build in $builds) {
         $item = [VSTeamBuild]::new(
            $build.definition.name,
            $build.buildnumber,
            $build.status,
            $build.result,
            $build.starttime,
            $build.requestedBy.displayName,
            $build.requestedFor.displayName,
            $build.project.name,
            $build.id)

         $item.AddTypeName('Team.Provider.Build')

         $objs += $item
      }

      return $objs
   }
}

class VSTeamBuild : VSTeamLeaf {
   [datetime]$StartTime
   [string]$Status = $null
   [string]$Result = $null
   [string]$BuildNumber = $null
   [string]$BuildDefinition = $null
   [string]$RequestedByUser = $null
   [string]$RequestedForUser = $null

   VSTeamBuild (
      [string]$BuildDefinition,
      [string]$BuildNumber,
      [string]$Status,
      [string]$Result,
      [datetime]$StartTime,
      [string]$RequestedByUser,
      [string]$RequestedForUser,
      [string]$Projectname,
      [int]$ID
   ) : base($BuildNumber, $ID.ToString(), $Projectname) {
      $this.Status = $Status
      $this.Result = $Result
      $this.StartTime = $StartTime
      $this.BuildNumber = $BuildNumber
      $this.BuildDefinition = $BuildDefinition
      $this.RequestedByUser = $RequestedByUser
      $this.RequestedForUser = $RequestedForUser

      $this.AddTypeName('Team.Build')
   }
}

[SHiPSProvider(UseCache = $true)]
[SHiPSProvider(BuiltinProgress = $false)]
class VSTeamReleases : VSTeamDirectory {

   VSTeamReleases(
      [string]$Name,
      [string]$ProjectName
   ) : base($Name, $ProjectName) {
      $this.AddTypeName('Team.Releases')
   }

   [object[]] GetChildItem() {
      $releases = Get-VSTeamRelease -ProjectName $this.ProjectName -Expand Environments -ErrorAction SilentlyContinue

      $objs = @()

      foreach ($release in $releases) {
         $item = [VSTeamRelease]::new(
            $release,
            $this.ProjectName)

         $item.AddTypeName('Team.Provider.Release')

         $objs += $item
      }

      return $objs
   }
}

[SHiPSProvider(UseCache = $true)]
[SHiPSProvider(BuiltinProgress = $false)]
class VSTeamRelease : VSTeamDirectory {
   [string]$ID = $null
   [string]$Status = $null
   [object]$Environments = $null
   [VSTeamUser]$CreatedBy = $null
   [VSTeamUser]$RequestedFor = $null
   [VSTeamUser]$ModifiedBy = $null
   [string]$DefinitionName = $null
   [object]$releaseDefinition = $null
   [datetime]$CreatedOn #DateTime is not nullable

   VSTeamRelease (
      [object]$obj,
      [string]$ProjectName
   ) : base($obj.name, $ProjectName) {
      $this.ID = $obj.id
      $this.Status = $obj.status
      $this.CreatedOn = $obj.createdOn
      $this.Environments = $obj.environments
      $this.releaseDefinition = $obj.releaseDefinition
      $this.DefinitionName = $obj.releaseDefinition.name
      $this.CreatedBy = [VSTeamUser]::new($obj.createdBy, $ProjectName)
      $this.ModifiedBy = [VSTeamUser]::new($obj.modifiedBy, $ProjectName)
      $this.RequestedFor = [VSTeamUser]::new($obj.requestedFor, $ProjectName)

      $this._internalObj = $obj

      $this.AddTypeName('Team.Release')
   }

   [object[]] GetChildItem() {
      $envs = Get-VSTeamRelease -ProjectName $this.projectName -Id $this.id -Expand Environments | Select-Object -ExpandProperty Environments

      $obj = @()

      foreach ($env in $envs) {
         $obj += [VSTeamEnvironment]::new(
            $env.name,
            $env.status,
            $this.projectname,
            $this.id,
            $env.Id)
      }

      return $obj
   }
}

[SHiPSProvider(UseCache = $false)]
[SHiPSProvider(BuiltinProgress = $false)]
class VSTeamEnvironment : VSTeamDirectory {
   [string]$Status = $null
   [int]$ReleaseId = $null
   [int]$Environmentid = $null

   VSTeamEnvironment (
      [string]$Name,
      [string]$Status,
      [string]$ProjectName,
      [int]$ReleaseId,
      [int]$Environmentid
   ) : base($Name, $ProjectName) {
      $this.Status = $Status
      $this.ReleaseId = $ReleaseId
      $this.Environmentid = $Environmentid

      $this.AddTypeName('Team.Environment')
   }

   [object[]] GetChildItem() {
      $attempts = Get-VSTeamRelease -ProjectName $this.ProjectName -Id $this.releaseId -Expand Environments `
         | Select-Object -ExpandProperty environments `
         | Where-Object id -eq $this.environmentid `
         | Select-Object -ExpandProperty deploysteps

      $objs = @()

      foreach ($attempt in $attempts) {
         $item = [VSTeamAttempt]::new(
            'Attempt ' + $attempt.Attempt,
            $attempt.status,
            $this.projectname,
            $this.releaseId,
            $this.environmentid,
            $attempt.id)

         $item.AddTypeName('Team.Provider.Attempt')

         $objs += $item
      }

      return $objs
   }
}

[SHiPSProvider(UseCache = $false)]
[SHiPSProvider(BuiltinProgress = $false)]
class VSTeamAttempt: VSTeamDirectory {
   [string]$Status = $null
   [int]$ReleaseId = $null
   [int]$Attemptid = $null
   [int]$Environmentid = $null

   VSTeamAttempt (
      [string]$Name,
      [string]$Status,
      [string]$Projectname,
      [int]$ReleaseId,
      [int]$Environmentid,
      [int]$Attemptid
   ) : base($Name, $Projectname) {
      $this.Status = $Status
      $this.Attemptid = $Attemptid
      $this.ReleaseId = $ReleaseId
      $this.Environmentid = $Environmentid

      $this.AddTypeName('Team.Attempt')
   }

   [object[]] GetChildItem() {
      $Tasks = Get-VSTeamRelease -ProjectName $this.projectName -Id $this.releaseId -Expand Environments `
         | Select-Object -ExpandProperty environments `
         | Where-Object id -eq $this.environmentid `
         | Select-Object -ExpandProperty deploysteps `
         | Where-Object id -eq $this.attemptid `
         | Select-Object @{Name = "Tasks"; Expression = { $_.releaseDeployPhases.deploymentJobs.tasks}} `
         | Select-Object -ExpandProperty tasks

      $obj = @()

      foreach ($Task in $Tasks) {
         $item = [VSTeamTask]::new($Task, $this.projectName)

         $item.AddTypeName('Team.Provider.Task')

         $obj += $item
      }

      return $obj
   }
}

class VSTeamTask : VSTeamLeaf {
   [string]$LogURL = $null
   [string]$Status = $null

   VSTeamTask (
      [object]$obj,
      [string]$ProjectName
   ) : base($obj.Name, $obj.id, $ProjectName) {
      $this.LogURL = $obj.logUrl
      $this.Status = $obj.status

      $this._internalObj = $obj

      $this.AddTypeName('Team.Task')
   }
}

[SHiPSProvider(UseCache = $true)]
class VSTeamRepositories : VSTeamDirectory {

   # Default constructor
   VSTeamRepositories(
      [string]$Name,
      [string]$ProjectName
   ) : base($Name, $ProjectName) {
      $this.AddTypeName('Team.Repositories')
   }

   [object[]] GetChildItem() {
      $items = Get-VSTeamGitRepository -ProjectName $this.ProjectName -ErrorAction SilentlyContinue

      foreach ($item in $items) {
         $item.AddTypeName('Team.Provider.Repository')
      }

      return $items
   }
}

[SHiPSProvider(UseCache = $true)]
class VSTeamRepository : VSTeamDirectory {

   [int]$Size = 0
   [string]$ID = $null
   [string]$URL = $null
   [string]$sshURL = $null
   [string]$RemoteURL = $null
   [string]$DefaultBranch = $null
   [VSTeamProject]$Project = $null

   VSTeamRepository(
      [object]$obj,
      [string]$ProjectName
   ) : base($obj.name, $ProjectName) {
      $this.ID = $obj.id
      $this.URL = $obj.Url

      # Depending on TFS/VSTS these might not be returned
      if ($obj.PSObject.Properties.Match('size').count -gt 0) {
         $this.Size = $obj.size
      }

      if ($obj.PSObject.Properties.Match('sshUrl').count -gt 0) {
         $this.sshURL = $obj.sshUrl
      }
      
      if ($obj.PSObject.Properties.Match('defaultBranch').count -gt 0) {
         $this.DefaultBranch = $obj.defaultBranch
      }

      $this.RemoteURL = $obj.remoteURL
      $this.Project = [VSTeamProject]::new($obj.project)

      $this._internalObj = $obj

      $this.AddTypeName('Team.Repository')
   }

   [object[]] GetChildItem() {
      $items = Get-VSTeamGitRef -ProjectName $this.ProjectName -RepositoryID $this.id -ErrorAction SilentlyContinue

      foreach ($item in $items) {
         $item.AddTypeName('Team.Provider.GitRef')
      }

      return $items
   }
}

class VSTeamRef : VSTeamLeaf {
   [VSTeamUser]$Creator = $null

   # The name passed to the base class is changed. For example if you pass
   # refs/heads/appcenter as the name it is converted into refs-heads-appcenter.
   # So I store it twice so I have the original value as well.
   [string]$RefName = $null

   VSTeamRef (
      [object]$obj,
      [string]$ProjectName
   ) : base($obj.name, $obj.objectId, $ProjectName) {
      $this.RefName = $obj.name
      $this.Creator = [VSTeamUser]::new($obj.creator, $ProjectName)

      $this._internalObj = $obj

      $this.AddTypeName('Team.GitRef')
   }
}

[SHiPSProvider(UseCache = $true)]
class VSTeamTeams : VSTeamDirectory {
   VSTeamTeams(
      [string]$Name,
      [string]$ProjectName
   ) : base($Name, $ProjectName) {
      $this.AddTypeName('Team.Teams')
   }

   [object[]] GetChildItem() {
      $items = Get-VSTeam -ProjectName $this.ProjectName -ErrorAction SilentlyContinue

      foreach ($item in $items) {
         $item.AddTypeName('Team.Provider.Team')
      }

      return $items
   }
}

class VSTeamTeam : VSTeamLeaf {
   [string]$Description = $null

   VSTeamTeam (
      [object]$obj,
      [string]$ProjectName
   ) : base($obj.name, $obj.Id, $ProjectName) {
      $this.Description = $obj.Description

      $this._internalObj = $obj

      $this.AddTypeName('Team.Team')
   }
}