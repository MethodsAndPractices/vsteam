function Remove-VSTeamFeed {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High",
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Remove-VSTeamFeed')]
   param (
      [Parameter(ParameterSetName = 'ByID', Position = 0, Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
      [Alias('FeedId')]
      [string[]] $Id,

      [switch] $Force,

      [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )
   process {
      foreach ($item in $id) {
         if ($Force -or $pscmdlet.ShouldProcess($item, "Delete Package Feed")) {

            $commonArgs = @{
               Method = 'DELETE'
               subDomain  = 'feeds'
               Area = 'packaging'
               Resource = 'feeds'
               Id = $item
               Version = $(_getApiVersion Packaging)
            }

            if ($ProjectName) {
               $commonArgs.ProjectName = $ProjectName
            }else{
               $commonArgs.NoProject = $true
            }

            # Call the REST API
            _callAPI @commonArgs | Out-Null

            Write-Output "Deleted Feed $item"
         }
      }
   }
}
