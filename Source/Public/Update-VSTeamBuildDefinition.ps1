function Update-VSTeamBuildDefinition {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium", DefaultParameterSetName = 'JSON')]
   Param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [int] $Id,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'File')]
      [string] $InFile,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'JSON')]
      [string] $BuildDefinition,

      [switch] $Force,

      [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
      [ProjectValidateAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      [string] $ProjectName
   )

   process {
      if ($Force -or $pscmdlet.ShouldProcess($Id, "Update Build Definition")) {
         # Call the REST API

         if ($InFile) {
            _callAPI -Method Put -ProjectName $ProjectName -Area build -Resource definitions -Id $Id -Version $(_getApiVersion Build) -InFile $InFile | Out-Null
         }
         else {
            _callAPI -Method Put -ProjectName $ProjectName -Area build -Resource definitions -Id $Id -Version $(_getApiVersion Build) -Body $BuildDefinition | Out-Null
         }
      }
   }
}
