using namespace Microsoft.PowerShell.SHiPS

[SHiPSProvider(UseCache = $true)]
class VSTeamGitRepository : VSTeamDirectory {

   [long]$Size = 0
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

      if ($obj.PSObject.Properties.Match('remoteURL').count -gt 0) {
         $this.RemoteURL = $obj.remoteURL
      }

      if ($obj.PSObject.Properties.Match('project').count -gt 0) {
         $this.Project = [VSTeamProject]::new($obj.project)
      }

      $this._internalObj = $obj

      $this.AddTypeName('Team.Repository')
   }

   [object[]] GetChildItem() {
      $items = Get-VSTeamGitRef -ProjectName $this.ProjectName -RepositoryID $this.id

      foreach ($item in $items) {
         $item.AddTypeName('Team.Provider.GitRef')
      }

      return $items
   }
}