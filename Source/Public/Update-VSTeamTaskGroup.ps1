function Update-VSTeamTaskGroup {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Low")]
   param(       
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $Id,

      [Parameter(ParameterSetName = 'ByFile', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $InFile,

      [Parameter(ParameterSetName = 'ByBody', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $Body,

      [switch] $Force
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      if ($Force -or $pscmdlet.ShouldProcess("Update Task Group")) {
         if ($InFile) {
            $resp = _callAPI -Method Put -ProjectName $ProjectName -Area distributedtask -Resource taskgroups -Version $([VSTeamVersions]::TaskGroups) -InFile $InFile -ContentType 'application/json;charset=utf-8' -Id $Id
         }
         else {
            $resp = _callAPI -Method Put -ProjectName $ProjectName -Area distributedtask -Resource taskgroups -Version $([VSTeamVersions]::TaskGroups) -Body $Body -ContentType 'application/json;charset=utf-8' -Id $Id 
         }
      }
      
      return $resp
   }
}
