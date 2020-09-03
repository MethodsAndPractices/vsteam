function Update-VSTeamRelease {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium")]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [int] $Id,

      [Parameter(Mandatory = $true)]
      [PSCustomObject] $Release,

      [switch] $Force,

      [ProjectValidateAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
      [string] $ProjectName
   )

   Process {
      $body = $Release | ConvertTo-Json -Depth 99

      if ($Force -or $pscmdlet.ShouldProcess($Id, "Update Release")) {
         # Call the REST API
         $resp = _callAPI -ProjectName $projectName -SubDomain vsrm -Area release -Resource releases -Id $id  `
            -Method Put -body $body -Version $(_getApiVersion Release)

         Write-Output $resp
      }
   }
}
