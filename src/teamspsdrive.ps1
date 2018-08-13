<#
   The formatting of the results are controlled in .\formats\vsteamPSDrive.format.ps1xml

   Modeling a VSTeam for example:
   
   Account
   - Agent Pools
     - Pool1
       - Agent1
   - Project1
   - Project2
   - Builds
      - Build1
      - Build2
   - Build Definitions
      - Build Definition 1
         - Process
            - Phases
               - Phase 1
                  - Step 1a
                  - Step 1b
                  - Step 1c
               - Phase 2
                  - Step 2a
                  - Step 2b
      - Build Definition 2
   - Releases
      - Release1
         - Environment 1
         - Attempt 1
            - Task1
            - Task2
            - Task3
      - Release2
   - Teams
      - Team1
      - Team2
   - Repositories
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
      $poolsAndProjects = @(
         [VSTeamPools]::new('Agent Pools')
      )
      
      $items = Get-VSTeamProject | Sort-Object Name

      foreach ($item in $items) {
         $item.AddTypeName('Team.Provider.Project')
         $poolsAndProjects += $item
      }

      return $poolsAndProjects
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
         [VSTeamBuildDefinitions]::new('Build Definitions', $this.Name),
         [VSTeamReleases]::new('Releases', $this.Name),
         [VSTeamRepositories]::new('Repositories', $this.Name),
         [VSTeamTeams]::new('Teams', $this.Name)
      )
   }
}

[SHiPSProvider(UseCache = $true)]
[SHiPSProvider(BuiltinProgress = $false)]
class VSTeamPools : VSTeamDirectory {

   # Default constructor
   VSTeamPools(
      [string]$Name
   ) : base($Name, $null) {
      $this.AddTypeName('Team.Pools')

      $this.DisplayMode = 'd-r-s-'
   }

   [object[]] GetChildItem() {
      $pools = Get-VSTeamPool -ErrorAction SilentlyContinue | Sort-Object name

      $objs = @()

      foreach ($pool in $pools) {
         $pool.AddTypeName('Team.Provider.Pool')

         $objs += $pool
      }

      return $objs
   }
}

[SHiPSProvider(UseCache = $true)]
[SHiPSProvider(BuiltinProgress = $false)]
class VSTeamPool : VSTeamDirectory {

   [int]$id
   [bool]$isHosted = $false
   [VSTeamUser]$owner = $null
   [VSTeamUser]$createdBy = $null

   # The number of agents in the pool
   [int]$count

   # Default constructor
   VSTeamPool(
      [object]$obj
   ) : base($obj.Name, $null) {

      $this.id = $obj.id
      $this.count = $obj.size
      $this.isHosted = $obj.isHosted
      $this.createdBy = [VSTeamUser]::new($obj.createdBy, $null)

      # Depending on TFS/VSTS this might not be returned
      if ($obj.PSObject.Properties.Match('owner').count -gt 0) {
         $this.owner = [VSTeamUser]::new($obj.owner, $null)
      }

      $this.AddTypeName('Team.Pool')

      if ($this.isHosted) {
         $this.DisplayMode = 'd-r-s-'
      }
      else {
         $this.DisplayMode = 'd-----'        
      }

      $this._internalObj = $obj
   }

   [object[]] GetChildItem() {
      $agents = Get-VSTeamAgent -PoolId $this.id -ErrorAction SilentlyContinue

      $objs = @()

      foreach ($agent in $agents) {
         $agent.AddTypeName('Team.Provider.Agent')

         $objs += $agent
      }

      return $objs
   }
}

class VSTeamAgent : VSTeamLeaf {
   [string]$version
   [string]$status
   [string]$os
   [bool]$enabled
   [PSCustomObject]$systemCapabilities

   VSTeamAgent (
      [object]$obj
   ) : base($obj.name, $obj.Id, $null) {

      $this.status = $obj.status
      $this.enabled = $obj.enabled
      $this.version = $obj.version
      $this.systemCapabilities = $obj.systemCapabilities

      # Depending on TFS/VSTS this might not be returned
      if ($obj.PSObject.Properties.Match('osDescription').count -gt 0) {
         $this.os = $obj.osDescription
      }

      $this._internalObj = $obj

      $this.AddTypeName('Team.Agent')
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
            $build,
            $build.project.name)

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
   [VSTeamUser]$RequestedBy = $null
   [VSTeamUser]$RequestedFor = $null
   [VSTeamUser]$LastChangedBy = $null

   VSTeamBuild (
      [object]$obj,
      [string]$Projectname
   ) : base($obj.buildNumber, $obj.id.ToString(), $Projectname) {
      $this.Status = $obj.status
      $this.Result = $obj.result
      $this.StartTime = $obj.startTime
      $this.BuildNumber = $obj.buildNumber
      $this.BuildDefinition = $obj.definition.name
      $this.RequestedBy = [VSTeamUser]::new($obj.requestedBy, $Projectname)
      $this.RequestedFor = [VSTeamUser]::new($obj.requestedFor, $Projectname)
      $this.LastChangedBy = [VSTeamUser]::new($obj.lastChangedBy, $Projectname)

      $this._internalObj = $obj

      $this.AddTypeName('Team.Build')
   }
}

[SHiPSProvider(UseCache = $true)]
[SHiPSProvider(BuiltinProgress = $false)]
class VSTeamBuildDefinitions : VSTeamDirectory {

   # Default constructor
   VSTeamBuildDefinitions(
      [string]$Name,
      [string]$ProjectName
   ) : base($Name, $ProjectName) {
   }

   [object[]] GetChildItem() {
      $buildDefinitions = Get-VSTeamBuildDefinition -ProjectName $this.ProjectName -ErrorAction SilentlyContinue

      $objs = @()

      foreach ($buildDefinition in $buildDefinitions) {
         $item = [VSTeamBuildDefinition]::new(
            $buildDefinition,
            $buildDefinition.project.name)

         $item.AddTypeName('Team.BuildDefinition')            

         $objs += $item
      }

      return $objs
   }
}

class VSTeamBuildDefinition : VSTeamLeaf {
   [VSTeamUser]$AuthoredBy = $null
   [VSTeamBuildDefinitionProcess]$Process = $null
   
   VSTeamBuildDefinition (
      [object]$obj,
      [string]$Projectname
   ) : base($obj.name, $obj.id.ToString(), $Projectname) {
      $this.AuthoredBy = [VSTeamUser]::new($obj.authoredBy, $Projectname)
      
      if ($obj.PSObject.Properties.Match('process').count -gt 0) {
         $this.Process = [VSTeamBuildDefinitionProcess]::new($obj.process, $Projectname)
      }      

      $this._internalObj = $obj

      $this.AddTypeName('Team.BuildDefinition')
   }
}

class VSTeamBuildDefinitionProcessPhaseStep : VSTeamLeaf {
   [bool]$Enabled = $true
   [bool]$ContinueOnError = $false
   [bool]$AlwaysRun = $true
   [int]$TimeoutInMinutes = 0
   [string]$Condition = $null
   [object]$Inputs = $null
   [object]$Task = $null
   
   VSTeamBuildDefinitionProcessPhaseStep(
      [object]$obj,
      [int]$stepNo,
      [string]$Projectname
   ) : base($obj.displayName, $stepNo.ToString(), $Projectname) {
      $this.Enabled = $obj.enabled
      $this.ContinueOnError = $obj.continueOnError
      $this.AlwaysRun = $obj.alwaysRun
      $this.TimeoutInMinutes = $obj.timeoutInMinutes
      $this.Condition = $obj.condition
      $this.Inputs = $obj.inputs
      $this.Task = $obj.task

      $this._internalObj = $obj
   }
}

class VSTeamBuildDefinitionProcessPhase : VSTeamDirectory {
   [VSTeamBuildDefinitionProcessPhaseStep[]] $Steps

   VSTeamBuildDefinitionProcessPhase(
      [object]$obj,
      [string]$Projectname
   ) : base($obj.name, $Projectname) {
      $stepNo = 0
      foreach ($step in $obj.steps) {
         $stepNo++
         $this.Steps += [VSTeamBuildDefinitionProcessPhaseStep]::new($step, $stepNo, $Projectname)
      }

      $this._internalObj = $obj
   }
}

class VSTeamBuildDefinitionProcess : VSTeamDirectory {
   [VSTeamBuildDefinitionProcessPhase[]] $Phases

   VSTeamBuildDefinitionProcess (
      [object]$obj,
      [string]$Projectname
   ) : base("Process", $Projectname) {
      foreach ($phase in $obj.phases) {
         $this.Phases += [VSTeamBuildDefinitionProcessPhase]::new($phase, $Projectname)
      }

      $this._internalObj = $obj
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
class VSTeamGitRepository : VSTeamDirectory {

   [int]$Size = 0
   [string]$ID = $null
   [string]$URL = $null
   [string]$sshURL = $null
   [string]$RemoteURL = $null
   [string]$DefaultBranch = $null
   [VSTeamProject]$Project = $null

   VSTeamGitRepository(
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