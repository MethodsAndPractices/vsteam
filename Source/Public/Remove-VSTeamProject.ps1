function Remove-VSTeamProject {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
   param(
      [switch] $Force,

      [Parameter(Mandatory = $true)]
      [Alias('ProjectName')]
      [ValidateProjectAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      $Name
   )
   
   Process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["Name"]

      if ($Force -or $pscmdlet.ShouldProcess($ProjectName, "Delete Project")) {
         # Call the REST API
         $resp = _callAPI -Area 'projects' -Id (Get-VSTeamProject $ProjectName).id `
            -Method Delete -Version $(_getApiVersion Core)

         _trackProjectProgress -resp $resp -title 'Deleting team project' -msg "Deleting $ProjectName"

         # Invalidate any cache of projects.
         [VSTeamProjectCache]::timestamp = -1

         Write-Output "Deleted $ProjectName"
      }
   }
}
