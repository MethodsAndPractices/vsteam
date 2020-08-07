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
      $commonArgs = @{
         Method      = 'Post'
         Area        = 'distributedtask'
         Resource    = 'taskgroups'
         ProjectName = $ProjectName
         Version     = $(_getApiVersion TaskGroups)
      }

      if ($InFile) {
         $resp = _callAPI @commonArgs -InFile $InFile
      }
      else {
         $resp = _callAPI @commonArgs -Body $Body
      }

      return $resp
   }
}
