function Get-VSTeamBuildLog {
   [CmdletBinding(DefaultParameterSetName = 'ByID',
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Get-VSTeamBuildLog')]
   param (
      [Parameter(Mandatory = $true, ParameterSetName = 'ByID', ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
      [Alias('BuildID')]
      [int[]] $Id,

      [int] $Index,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )
   process {
      foreach ($item in $id) {
         if (-not $Index) {
            # Build the url to return the logs of the build
            # Call the REST API to get the number of logs for the build
            $resp = _callAPI -ProjectName $projectName `
               -Area build `
               -Resource builds `
               -Id "$item/logs" `
               -Version $(_getApiVersion Build)

            $fullLogIndex = $($resp.count)
         }
         else {
            $fullLogIndex = $Index
         }

         # Now call REST API with the index for the fullLog
         # Build the url to return the single build
         # Call the REST API to get the number of logs for the build
         $resp = _callAPI -ProjectName $projectName `
            -Area build `
            -Resource builds `
            -Id "$item/logs/$fullLogIndex" `
            -Version $(_getApiVersion Build)

         Write-Output $resp
      }
   }
}