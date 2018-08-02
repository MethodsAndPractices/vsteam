Set-StrictMode -Version Latest

# Load common code
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\common.ps1"

function Get-VSTeamAgent {
   [CmdletBinding(DefaultParameterSetName = 'List')]
   param(      
      [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0)]
      [int] $PoolId,

      [Parameter(ParameterSetName = 'ByID', Mandatory = $true, ValueFromPipelineByPropertyName = $true, Position = 1)]
      [Alias('AgentID')]
      [string] $Id
   )

   process {

      if ($id) {
         $resp = _callAPI -Area "distributedtask/pools/$PoolId" -Resource agents -Id $id `
            -Body @{includeCapabilities = 'true'} -Version $VSTeamVersionTable.DistributedTask
         
         # Storing the object before you return it cleaned up the pipeline.
         # When I just write the object from the constructor each property
         # seemed to be written
         $item = [VSTeamAgent]::new($resp)

         Write-Output $item
      }
      else {
         $resp = _callAPI -Area "distributedtask/pools/$PoolId" -Resource agents `
            -Body @{includeCapabilities = 'true'} -Version $VSTeamVersionTable.DistributedTask

         $objs = @()

         foreach ($item in $resp.value) {
            $objs += [VSTeamAgent]::new($item)
         }

         Write-Output $objs
      }
   }
}

function Remove-VSTeamAgent {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
   param(      
      [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0)]
      [int] $PoolId,

      [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 1)]
      [Alias('AgentID')]
      [int[]] $Id,

      # Forces the command without confirmation
      [switch] $Force
   )

   process {
      foreach ($item in $Id) {
         if ($force -or $pscmdlet.ShouldProcess($item,"Delete agent")) {
            try {
               _callAPI -Method Delete -Area "distributedtask/pools/$PoolId" -Resource agents -Id $item -Version $VSTeamVersionTable.DistributedTask | Out-Null
               Write-Output "Deleted agent $item"
            }
            catch {
               _handleException $_
            }
         }
      }
   }
}

Set-Alias Get-Agent Get-VSTeamAgent
Set-Alias Remove-Agent Remove-VSTeamAgent

Export-ModuleMember `
   -Function Get-VSTeamAgent, Remove-VSTeamAgent `
   -Alias Get-Agent, Remove-Agent