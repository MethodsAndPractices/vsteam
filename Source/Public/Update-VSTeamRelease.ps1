function Update-VSTeamRelease {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium")]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [int] $Id,

      [Parameter(Mandatory = $true)]
      [PSCustomObject] $Release,

      [switch] $Force,

      [Parameter(Mandatory = $true, Position = 0)]
      [ValidateProjectAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      $ProjectName
   )

   Process {
      $body = $Release | ConvertTo-Json -Depth 99

      if ($Force -or $pscmdlet.ShouldProcess($Id, "Update Release")) {
         # Call the REST API
         $resp = _callAPI -ProjectName $projectName -SubDomain vsrm -Area release -Resource releases -Id $id  `
            -Method Put -ContentType 'application/json' -body $body -Version $(_getApiVersion Release)

         Write-Output $resp
      }
   }
}
