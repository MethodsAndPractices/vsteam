function Add-VSTeamTaskGroup {
   [CmdletBinding()]
   param(
      [Parameter(ParameterSetName = 'ByFile', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $InFile,

      [Parameter(ParameterSetName = 'ByBody', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $Body
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      if ($InFile) {
         $resp = _callAPI -Method Post -ProjectName $ProjectName -Area distributedtask -Resource taskgroups -Version $(_getApiVersion TaskGroups) -InFile $InFile -ContentType 'application/json'
      }
      else {
         $resp = _callAPI -Method Post -ProjectName $ProjectName -Area distributedtask -Resource taskgroups -Version $(_getApiVersion TaskGroups) -ContentType 'application/json' -Body $Body
      }

      return $resp
   }
}