function Update-VSTeamTaskGroup {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Low",
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Update-VSTeamTaskGroup')]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $Id,

      [Parameter(ParameterSetName = 'ByFile', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $InFile,

      [Parameter(ParameterSetName = 'ByBody', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $Body,

      [switch] $Force,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
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
