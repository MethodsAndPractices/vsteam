function Add-VSTeamTaskGroup {
   [CmdletBinding()]
   param(
      [Parameter(ParameterSetName = 'ByFile', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $InFile,

      [Parameter(ParameterSetName = 'ByBody', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $Body,

      [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
      [ProjectValidateAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      [string] $ProjectName
   )
   process {
      if ($InFile) {
         $resp = _callAPI -Method Post -ProjectName $ProjectName -Area distributedtask -Resource taskgroups -Version $(_getApiVersion TaskGroups) -InFile $InFile -ContentType 'application/json'
      }
      else {
         $resp = _callAPI -Method Post -ProjectName $ProjectName -Area distributedtask -Resource taskgroups -Version $(_getApiVersion TaskGroups) -ContentType 'application/json' -Body $Body
      }

      return $resp
   }
}
