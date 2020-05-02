function Remove-VSTeam {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
   param(
      [Parameter(Mandatory = $True, ValueFromPipelineByPropertyName = $true)]
      [Alias('Name', 'TeamId', 'TeamName')]
      [string]$Id,

      [switch]$Force,

      [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
      [ProjectValidateAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      [string] $ProjectName
   )
   
   process {
      if ($Force -or $PSCmdlet.ShouldProcess($Id, "Delete team")) {
         # Call the REST API
         _callAPI -Area 'projects' -Resource "$ProjectName/teams" -Id $Id `
            -Method Delete -Version $(_getApiVersion Core) | Out-Null

         Write-Output "Deleted team $Id"
      }
   }
}
