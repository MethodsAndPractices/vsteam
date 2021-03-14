function Set-VSTeamAgentPoolMaintenance {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium", DefaultParameterSetName = "Disabled",
      HelpUri = 'https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Set-VSTeamAgentPoolMaintenance')]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, Position = 1)]
      [Alias('PoolID')]
      [int] $Id,

      [Parameter(Mandatory = $false, ParameterSetName = "Disabled")]
      [switch] $Disable,

      [ValidateRange(0, [int]::MaxValue)]
      [Parameter(Mandatory = $true, ParameterSetName = "Enabled")]
      [int] $JobTimeoutInMinutes,

      [ValidateRange(0, 100)]
      [Parameter(Mandatory = $true, ParameterSetName = "Enabled")]
      [int] $MaxConcurrentAgentsPercentage,

      [ValidateRange(0, [int]::MaxValue)]
      [Parameter(Mandatory = $true, ParameterSetName = "Enabled")]
      [int] $NumberOfHistoryRecordsToKeep,

      [ValidateRange(0, [int]::MaxValue)]
      [Parameter(Mandatory = $true, ParameterSetName = "Enabled")]
      [int] $WorkingDirectoryExpirationInDays,

      [ValidateRange(0, 23)]
      [Parameter(Mandatory = $true, ParameterSetName = "Enabled")]
      [int] $StartHours,

      [ValidateRange(0, 59)]
      [Parameter(Mandatory = $true, ParameterSetName = "Enabled")]
      [int] $StartMinutes,

      [Parameter(Mandatory = $true, ParameterSetName = "Enabled")]
      [vsteam_lib.TimeZoneValidateAttribute()]
      [ArgumentCompleter([vsteam_lib.TimeZoneCompleter])]
      [string] $TimeZoneId,

      [Parameter(Mandatory = $true, ParameterSetName = "Enabled")]
      [vsteam_lib.AgentPoolMaintenanceDays] $WeekDaysToBuild
   )

   process {

      if ($force -or $pscmdlet.ShouldProcess($Id, "Set Pool Maintenance")) {

         $isEnabled = $true
         if ($Disable.IsPresent) {
            $isEnabled = $false
         }

         $resp = _callAPI -Method Get -NoProject -Area distributedtask -Resource pools -Id "$Id/maintenancedefinitions" -Version $(_getApiVersion DistributedTask)
         _applyTypesToAgentPoolMaintenance -item $resp

         if ($resp.count -eq 0) {

            $body = @{
               id = 0
               enabled = $isEnabled
               jobTimeoutInMinutes = $JobTimeoutInMinutes
               maxConcurrentAgentsPercentage = $MaxConcurrentAgentsPercentage
               retentionPolicy = @{
                  numberOfHistoryRecordsToKeep = $NumberOfHistoryRecordsToKeep
               }
               options = @{
                  workingDirectoryExpirationInDays = $WorkingDirectoryExpirationInDays
               }
               scheduleSetting = @{
                  scheduleJobId = "feb6af1b-fc8f-4251-879e-aaf6ca947058"
                  startHours = $StartHours
                  startMinutes = $StartMinutes
                  daysToBuild = ([int]$WeekDaysToBuild)
                  timeZoneId = $TimeZoneId
               }
            }

            $bodyAsJson = $body | ConvertTo-Json -Compress -Depth 50
            $null = _callAPI -Method Post -NoProject -Area distributedtask -Resource pools -Id "$Id/maintenancedefinitions" -Version $(_getApiVersion DistributedTask) -Body $bodyAsJson
         }else {

            $body = $resp.value[0]
            $body.PSObject.Properties.Remove('pool')
            $body.enabled = $isEnabled

            $bodyAsJson = $body | ConvertTo-Json -Compress -Depth 50
            $null = _callAPI -Method Put -NoProject -Area distributedtask -Resource pools -Id "$Id/maintenancedefinitions/$($resp.value[0].id)" -Version $(_getApiVersion DistributedTask) -Body $bodyAsJson
         }
      }
      Set-VSTeamPoolMaintenance -Id -Enable -
   }


}