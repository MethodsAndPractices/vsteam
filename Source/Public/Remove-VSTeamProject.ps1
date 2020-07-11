function Remove-VSTeamProject {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
   param(
      [switch] $Force,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [Alias('ProjectName')]
      [ProjectValidateAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      [string] $Name
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
         [VSTeamProjectCache]::Invalidate()

         Write-Output "Deleted $ProjectName"
      }
   }
}
