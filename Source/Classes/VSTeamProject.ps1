using namespace Microsoft.PowerShell.SHiPS

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
         [VSTeamBuildDefinitions]::new('Build Definitions', $this.Name),
         [VSTeamBuilds]::new('Builds', $this.Name),
         [VSTeamQueues]::new('Queues', $this.Name),
         [VSTeamReleaseDefinitions]::new('Release Definitions', $this.Name),
         [VSTeamReleases]::new('Releases', $this.Name),
         [VSTeamRepositories]::new('Repositories', $this.Name),
         [VSTeamTeams]::new('Teams', $this.Name)
      )
   }
}