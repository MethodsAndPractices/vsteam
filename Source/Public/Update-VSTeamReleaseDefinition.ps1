function Update-VSTeamReleaseDefinition {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium", DefaultParameterSetName = 'JSON',
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Update-VSTeamReleaseDefinition')]
   Param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'File')]
      [string] $InFile,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'JSON')]
      [string] $ReleaseDefinition,

      [switch] $Force,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )

   Process {
      $commonArgs = @{
         Method      = 'Put'
         subDomain   = 'vsrm'
         area        = 'release'
         resource    = 'definitions'
         ProjectName = $ProjectName
         version     = $(_getApiVersion Release)
      }

      if ($Force -or $pscmdlet.ShouldProcess('', "Update Release Definition")) {
         # Call the REST API
         if ($InFile) {
            _callAPI @commonArgs -InFile $InFile | Out-Null
         }
         else {
            _callAPI @commonArgs -Body $ReleaseDefinition | Out-Null
         }
      }
   }
}
