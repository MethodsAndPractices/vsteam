using namespace Microsoft.PowerShell.SHiPS

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