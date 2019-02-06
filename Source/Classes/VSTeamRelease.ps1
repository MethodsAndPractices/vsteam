using namespace Microsoft.PowerShell.SHiPS

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