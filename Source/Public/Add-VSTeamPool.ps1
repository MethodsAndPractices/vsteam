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
         autoProvision = $AutoProvision.IsPresent
         autoUpdate = !$NoAutoUpdates.IsPresent
         properties = @{
            "System.AutoAuthorize" = $AutoAuthorize.IsPresent
         }
      }

      $bodyAsJson = $body | ConvertTo-Json

      $resp = _callAPI -Method Post -NoProject -Area distributedtask -Resource pools -Version $(_getApiVersion DistributedTask) -Body $bodyAsJson -ContentType 'application/json;charset=utf-8'

      $pool = [VSTeamPool]::new($resp)

      if ($resp -and $Description) {
         $descriptionAsJson = $Description | ConvertTo-Json
         $null = _callAPI -Method Put -NoProject -Area distributedtask -Resource pools -Id "$($pool.id)/poolmetadata" -Version $(_getApiVersion DistributedTask) -Body $descriptionAsJson -ContentType 'application/json;charset=utf-8'
      }

      Write-Output $pool

   }
}