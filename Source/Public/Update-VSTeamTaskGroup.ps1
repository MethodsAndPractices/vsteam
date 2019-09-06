function Update-VSTeamTaskGroup {
   [CmdletBinding()]
   param(       
      [Parameter(Mandatory)]
      [string] $Id,

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
         $resp = _callAPI -Method Put -ProjectName $ProjectName -Area distributedtask -Resource taskgroups -Version $([VSTeamVersions]::TaskGroups) -InFile $InFile -ContentType 'application/json' -Id $Id
      }
      else {
         $resp = _callAPI -Method Put -ProjectName $ProjectName -Area distributedtask -Resource taskgroups -Version $([VSTeamVersions]::TaskGroups) -Body $Body -ContentType 'application/json' -Id $Id   
      }
      
      return $resp
   }
}
