function Update-VSTeamTaskGroup {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Low")]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $Id,

      [Parameter(ParameterSetName = 'ByFile', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $InFile,

      [Parameter(ParameterSetName = 'ByBody', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $Body,

      [switch] $Force,

      [ProjectValidateAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
      [string] $ProjectName
   )

   Process {
      $commonArgs = @{
         Id          = $Id
         Method      = 'Put'
         Area        = 'distributedtask'
         Resource    = 'taskgroups'
         ProjectName = $ProjectName
         Version     = $(_getApiVersion TaskGroups)
      }

      if ($Force -or $pscmdlet.ShouldProcess("Update Task Group")) {
         if ($InFile) {
            $resp = _callAPI @commonArgs -InFile $InFile
         }
         else {
            $resp = _callAPI @commonArgs -Body $Body
         }
      }

      return $resp
   }
}
