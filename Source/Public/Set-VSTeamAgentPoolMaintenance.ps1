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

         $resp = _callAPI -Method Get -NoProject -Area distributedtask -Resource pools -Id "$Id/maintenancedefinitions" -Version $(_getApiVersion DistributedTask)
         $hasSchedule = $resp.count -gt 0

         if ($Disable.IsPresent -and $false -eq $hasSchedule) {
            Write-Error "Cannot deactivate. No Maintenance Schedule existing!"
         }

         $body = $null
         if ($Disable.IsPresent) {
            $isEnabled = $false

            $body = $resp.value[0]
            $body.PSObject.Properties.Remove('pool')
            $body.enabled = $isEnabled
         }else {
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
                  scheduleJobId = (New-Guid).ToString()
                  startHours = $StartHours
                  startMinutes = $StartMinutes
                  daysToBuild = ([int]$WeekDaysToBuild)
                  timeZoneId = $TimeZoneId
               }
            }
         }

         $param = @{ Id = ""; Method = ""}
         if ($hasSchedule) {
            $param.Id = "$Id/maintenancedefinitions"
            $param.Method = "Post"
         }else {
            $param.Id = "$Id/maintenancedefinitions/$($resp.value[0].id)"
            $param.Method = "Put"
         }

         $bodyAsJson = $body | ConvertTo-Json -Compress -Depth 50
         $updateResp = _callAPI -NoProject -Area distributedtask -Resource pools -Body $bodyAsJson -Version $(_getApiVersion DistributedTask) @param
         _applyTypesToAgentPoolMaintenance -item $updateResp

         Write-Output updateResp
      }
   }


}