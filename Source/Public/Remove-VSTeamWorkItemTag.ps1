function Remove-VSTeamWorkItemTag {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High", DefaultParameterSetName = 'ByID',
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Remove-VSTeamWorkItemTag')]
    param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $TagIdOrName,

      [switch] $Force,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )

   Process {
      if ($Force -or $pscmdlet.ShouldProcess($item, "Delete work item tag from all work items in this team project")) {
         try {
            _callAPI -Method DELETE `
               -Area "wit" `
               -Resource "tags" `
               -id $TagIdOrName `
               -Version $(_getApiVersion WorkItemTracking) | Out-Null

            Write-Output "Deleted tag $TagIdOrName"
         }
         catch {
            _handleException $_
         }
      }    
   }
}