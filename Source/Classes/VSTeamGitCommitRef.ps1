class VSTeamGitCommitRef : VSTeamLeaf {
   [VSTeamGitUserDate]$Author = $null
   [VSTeamGitUserDate]$Committer = $null
   [string]$Comment=$null
   [string]$CommitId = $null
   [string]$RemoteUrl = $null
   [string]$Url = $null

   VSTeamGitCommitRef (
      [object]$obj,
      [string]$ProjectName
   ) : base($obj.comment, $obj.commitId, $ProjectName) {

      $this.Author = [VSTeamGitUserDate]::new($obj.author, $ProjectName)
      $this.Committer = [VSTeamGitUserDate]::new($obj.committer, $ProjectName)
      $this.CommitId = $obj.commitId
      $this.Comment = $obj.comment
      $this.RemoteUrl = $obj.remoteUrl
      $this.Url = $obj.url

      $this._internalObj = $obj

      $this.AddTypeName('Team.GitCommitRef')
   }
}