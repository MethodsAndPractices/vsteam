function Update-VSTeamReleaseDefinition {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium", DefaultParameterSetName = 'JSON')]
   Param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'File')]
      [string] $InFile,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'JSON')]
      [string] $ReleaseDefinition,

      [switch] $Force,

      [ProjectValidateAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
      [string] $ProjectName
   )

   Process {
      if ($Force -or $pscmdlet.ShouldProcess('', "Update Release Definition")) {
         # Call the REST API
         if ($InFile) {
            _callAPI -Method Put -ProjectName $ProjectName -SubDomain vsrm -Area Release -Resource definitions -Version $(_getApiVersion Release) -InFile $InFile | Out-Null
         }
         else {
            _callAPI -Method Put -ProjectName $ProjectName -SubDomain vsrm -Area Release -Resource definitions -Version $(_getApiVersion Release) -Body $ReleaseDefinition | Out-Null
         }
      }
   }
}
