class VSTeamGitUserDate : VSTeamLeaf {
   [DateTime]$Date = [DateTime]::MinValue
   [string]$Email = $null

   VSTeamGitUserDate (
      [object]$obj,
      [string]$ProjectName
   ) : base($obj.email, $obj.email, $ProjectName) {

      $this.Date = $obj.date
      $this.Email = $obj.email
      $this.Name = $obj.name

      $this._internalObj = $obj

      $this.AddTypeName('Team.GitUserDate')
   }
}