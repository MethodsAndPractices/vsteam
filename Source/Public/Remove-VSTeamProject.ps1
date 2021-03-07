function Remove-VSTeamProject {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High",
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Remove-VSTeamProject')]
   param(
      [switch] $Force,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [Alias('ProjectName')]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $Name
   )

   Process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["Name"]

      if ($Force -or $pscmdlet.ShouldProcess($ProjectName, "Delete Project")) {
         # Call the REST API
         $resp = _callAPI -Method DELETE `
            -Resource projects `
            -Id (Get-VSTeamProject $ProjectName).id `
            -Version $(_getApiVersion Core)

         _trackProjectProgress -resp $resp -title 'Deleting team project' -msg "Deleting $ProjectName"

         # Invalidate any cache of projects.
         [vsteam_lib.ProjectCache]::Invalidate()

         Write-Output "Deleted $ProjectName"
      }
   }
}
