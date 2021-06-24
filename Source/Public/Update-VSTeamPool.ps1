function Update-VSTeamPool {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium",
      HelpUri = 'https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Update-VSTeamPool')]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, Position = 1)]
      [Alias('PoolID')]
      [int] $Id,

      [Parameter(Mandatory = $false)]
      [string] $Name,

      [Parameter(Mandatory = $false)]
      [string] $Description,

      [Parameter(Mandatory = $false)]
      [switch] $AutoProvision,

      [Parameter(Mandatory = $false)]
      [switch] $NoAutoUpdates
   )

   process {

      if ($force -or $pscmdlet.ShouldProcess($Id, "Update Pool")) {
         $body = @{
            autoProvision = $AutoProvision.IsPresent
            autoUpdate    = !$NoAutoUpdates.IsPresent
         }

         if ($Name) {
            $body.name = $Name
         }

         $bodyAsJson = $body | ConvertTo-Json -Compress

         $resp = _callAPI -Method Patch -NoProject -Area distributedtask -Resource pools -Version $(_getApiVersion DistributedTask) -Id $Id -Body $bodyAsJson

         $pool = [vsteam_lib.AgentPool]::new($resp)

         if ($resp -and $Description) {
            $descriptionAsJson = $Description | ConvertTo-Json
            $null = _callAPI -Method Put -NoProject -Area distributedtask -Resource pools -Id "$($pool.id)/poolmetadata" -Version $(_getApiVersion DistributedTask) -Body $descriptionAsJson
         }

         Write-Output $pool

      }
   }
}