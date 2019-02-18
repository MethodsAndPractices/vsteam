using namespace Microsoft.PowerShell.SHiPS

[SHiPSProvider(UseCache = $false)]
[SHiPSProvider(BuiltinProgress = $false)]
class VSTeamBuildDefinition : VSTeamDirectory {

   [int]$id = -1
   [int]$Revision = -1
   [string]$Path = $null
   [object]$Tags = $null
   [object]$Options = $null
   [object]$Triggers = $null
   [object]$Variables = $null
   [object]$Repository = $null
   [VSTeamQueue]$Queue = $null
   [object]$RetentionRules = $null
   [VSTeamUser]$AuthoredBy = $null
   [string]$BuildNumberFormat = $null
   [string]$JobAuthorizationScope = $null
   [VSTeamGitRepository]$GitRepository = $null
   [datetime]$CreatedOn = [datetime]::MinValue
   [VSTeamBuildDefinitionProcess]$Process = $null
   [VSTeamBuildDefinitionProcessPhaseStep[]]$Steps = $null
   [string[]]$Demands = $null

   VSTeamBuildDefinition (
      [object]$obj,
      [string]$Projectname
   ) : base($obj.name, $Projectname) {

      $this.id = $obj.id
      $this.Path = $obj.path
      $this.Revision = $obj.revision
      $this.Variables = $obj.variables
      $this.CreatedOn = $obj.createdDate
      $this.JobAuthorizationScope = $obj.jobAuthorizationScope
      $this.AuthoredBy = [VSTeamUser]::new($obj.authoredBy, $Projectname)

      # These might not be returned
      if ($obj.PSObject.Properties.Match('queue').count -gt 0) {
         $this.Queue = [VSTeamQueue]::new($obj.queue, $Projectname)
      }
      if ($obj.PSObject.Properties.Match('triggers').count -gt 0) {
         $this.Triggers = $obj.triggers
      }

      if ($obj.PSObject.Properties.Match('retentionRules').count -gt 0) {
         $this.RetentionRules = $obj.retentionRules
      }

      if ($obj.PSObject.Properties.Match('demands').count -gt 0) {
         $this.Demands = $obj.demands
      }

      if ($obj.PSObject.Properties.Match('options').count -gt 0) {
         $this.Options = $obj.options
      }

      if ($obj.PSObject.Properties.Match('tags').count -gt 0) {
         $this.Tags = $obj.tags
      }

      if ($obj.PSObject.Properties.Match('repository').count -gt 0) {
         if($obj.repository.type -eq "TfsGit") {
            $this.GitRepository = [VSTeamGitRepository]::new($obj.repository, $Projectname)
         } else {
            $this.Repository = $obj.repository
         }
      }

      # This is only in VSTS. In TFS it is a build property
      if ($obj.PSObject.Properties.Match('process').count -gt 0) {
         $this.Process = [VSTeamBuildDefinitionProcess]::new($obj.process, $Projectname)
      }

      # TFS 2017/2018
      if ($obj.PSObject.Properties.Match('build').count -gt 0) {
         $stepNo = 0
         foreach ($step in $obj.build) {
            $stepNo++
            $this.Steps += [VSTeamBuildDefinitionProcessPhaseStep]::new($step, $stepNo, $Projectname)
         }
      }

      if ($obj.PSObject.Properties.Match('BuildNumberFormat').count -gt 0) {
         $this.BuildNumberFormat = $obj.buildNumberFormat
      }

      $this._internalObj = $obj

      $this.AddTypeName('Team.BuildDefinition')
   }

   [object[]] GetChildItem() {

      if ($null -ne $this.Steps) {
         return $this.Steps
      }

      if ($this.Process.Type -eq 1) {
         return $this.Process.Phases
      }
      else {
         return $this.Process
      }
   }
}