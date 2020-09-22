function Update-VSTeamServiceEndpoint {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium",
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Update-VSTeamServiceEndpoint')]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $id,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [hashtable] $object,

      [switch] $Force,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )

   Process {
      $body = $object | ConvertTo-Json

      if ($Force -or $pscmdlet.ShouldProcess($id, "Update Service Endpoint")) {
         # Call the REST API
         $resp = _callAPI -ProjectName $projectName -Area 'distributedtask' -Resource 'serviceendpoints' -Id $id  `
            -Method PUT -ContentType 'application/json' -body $body -Version $(_getApiVersion ServiceEndpoints)

         _trackServiceEndpointProgress -projectName $projectName -resp $resp -title 'Updating Service Endpoint' -msg "Updating $id"

         return Get-VSTeamServiceEndpoint -ProjectName $ProjectName -id $id
      }
   }
}
