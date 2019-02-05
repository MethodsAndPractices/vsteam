using namespace Microsoft.PowerShell.SHiPS

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