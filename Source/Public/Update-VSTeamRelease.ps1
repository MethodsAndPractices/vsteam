function Update-VSTeamRelease {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium")]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [int] $Id,

      [Parameter(Mandatory = $true)]
      [PSCustomObject] $Release,

      [switch] $Force,

      [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )

   Process {
      $body = $Release | ConvertTo-Json -Depth 99

      if ($Force -or $pscmdlet.ShouldProcess($Id, "Update Release")) {
         # Call the REST API
         $resp = _callAPI -Method PUT -SubDomain vsrm -ProjectName $projectName `
            -Area release `
            -Resource releases `
            -Id $id `
            -body $body `
            -Version $(_getApiVersion Release)

         Write-Output $resp
      }
   }
}
