function Update-VSTeamWorkItemTag {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium", DefaultParameterSetName = 'JSON',
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Update-VSTeamWorkItemTag')]
   Param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $TagIdOrName,

      [switch] $Force,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )

   process {
      if ($Force -or $pscmdlet.ShouldProcess($Id, "Update Work Item Tag")) {
         $resp = _callAPI -Method PATCH -ProjectName $ProjectName `
            -Area wit `
            -Resource tags `
            -Id $TagIdOrName `
            -Body $body `
            -Version $(_getApiVersion WorkItemTracking)

         Write-Output $resp
      }
   }
}