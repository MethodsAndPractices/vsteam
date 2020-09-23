function Update-VSTeamBuildDefinition {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium", DefaultParameterSetName = 'JSON',
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Update-VSTeamBuildDefinition')]
   Param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [int] $Id,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'File')]
      [string] $InFile,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'JSON')]
      [string] $BuildDefinition,

      [switch] $Force,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )

   process {
      if ($Force -or $pscmdlet.ShouldProcess($Id, "Update Build Definition")) {
         # Call the REST API

         if ($InFile) {
            _callAPI -Method PUT -ProjectName $ProjectName `
               -Area build `
               -Resource definitions `
               -Id $Id `
               -InFile $InFile `
               -Version $(_getApiVersion Build) | Out-Null
         }
         else {
            _callAPI -Method PUT -ProjectName $ProjectName `
               -Area build `
               -Resource definitions `
               -Id $Id `
               -Body $BuildDefinition `
               -Version $(_getApiVersion Build) | Out-Null
         }
      }
   }
}
