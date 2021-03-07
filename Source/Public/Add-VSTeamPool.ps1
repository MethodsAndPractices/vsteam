function Add-VSTeamPool {
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $true, Position = 1)]
      [string] $Name,

      [Parameter(Mandatory = $false)]
      [string] $Description,

      [Parameter(Mandatory = $false)]
      [switch] $AutoProvision,

      [Parameter(Mandatory = $false)]
      [switch] $AutoAuthorize,

      [Parameter(Mandatory = $false)]
      [switch] $NoAutoUpdates
   )

   process {

      $body = @{
         name = $Name
         autoProvision = $AutoProvision.IsPresent
         autoUpdate = !$NoAutoUpdates.IsPresent
         properties = @{
            "System.AutoAuthorize" = $AutoAuthorize.IsPresent
         }
      }

      $bodyAsJson = $body | ConvertTo-Json -Compress

      $resp = _callAPI -Method Post -NoProject -Area distributedtask -Resource pools -Version $(_getApiVersion DistributedTask) -Body $bodyAsJson

      $pool = [vsteam_lib.AgentPool]::new($resp)

      if ($resp -and $Description) {
         $descriptionAsJson = $Description | ConvertTo-Json -Compress
         $null = _callAPI -Method Put -NoProject -Area distributedtask -Resource pools -Id "$($pool.id)/poolmetadata" -Version $(_getApiVersion DistributedTask) -Body $descriptionAsJson
      }

      Write-Output $pool

   }
}