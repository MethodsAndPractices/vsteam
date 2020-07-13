function Set-VSTeamWorkItemType {
   [CmdletBinding(DefaultParameterSetName = 'LeaveAlone', SupportsShouldProcess = $true, ConfirmImpact = 'High')]
   param(
      [parameter(ValueFromPipelineByPropertyName = $true)]
      [ProcessValidateAttribute()]
      [ArgumentCompleter([ProcessTemplateCompleter])]
      $ProcessTemplate = $env:TEAM_PROCESS,

      [parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
      [ArgumentCompleter([WorkItemTypeCompleter])]
      [Alias('Name')]
      $WorkItemType,

      [string] $Description,

      [ArgumentCompleter([ColorCompleter])]
      [ColorTransformToHexAttribute()]
      $Color,

      [IconTransformAttribute()]
      [ArgumentCompleter([IconCompleter])]
      [string]$Icon ,

      [parameter(ParameterSetName = 'Hide', Mandatory = $true)]
      [switch]$Disabled,

      [parameter(ParameterSetName = 'Show', Mandatory = $true)]
      [switch]$Enabled,

      [switch]$Force
   )
   process {
      $wit = [VSTeamWorkItemTypeCache]::GetCurrent($ProcessTemplate ) | Where-Object -Property name -eq  $WorkItemType
      if (-not $wit) { Write-Warning "'$workitemType' does not appear to be a valid Workitem type." ; return }
      $url = "$($wit.url)?api-version=" + (_getApiVersion Processes)  
      $body = @{} #note. "Changing" some options to their current value can causes an error. So only do real changes.
      #move into classes for validting / completing icons

      if ($Icon -and $Icon -ne $wit.icon) {
         qappsrv.exe
         $body['icon'] = $Icon
      }
      else { $body['icon'] = $wit.icon }

      if ($Color -match '^[\da-f]{6}$' -and $color -ne $wit.color) {
         $body['color'] = $Color
      }
      else { $body['color'] = $wit.color }

      if ($Description -and $Description -ne $wit.description) {
         $body['description'] = $Description 
      } 
      else { $body['description'] = $wit.description }
      
      if ($Disabled -and -not $wit.isDisabled) {
         $body['isDisabled'] = $true 
      }        
      elseif ($Enabled -and $wit.isDisabled) {
         $body['isDisabled'] = $false 
      }
      else { $body['isDisabled'] = $wit.isDisabled }
      
      if ($Force -or $PSCmdlet.ShouldProcess($WorkItemType, "Modify $ProcessTemplate, to update definition of workitem type") ) {
         try { 
            if ($wit.customization -ne 'system') {
               #Custom or inherited types Patch their own URL
               $resp = _callapi -Url $url -method  Patch  -ContentType "application/json" -body (ConvertTo-Json $body) -ErrorAction stop 
            }
            else {
               #for system items we have to POST to the creation URL
               $body['inheritsFrom'] = $wit.referenceName
               $url = ($url -replace 'workItemTypes/.*$' , 'workItemTypes?api-version=') + (_getApiVersion Processes) 
               $resp = _callapi -Url $url -method  POST  -ContentType "application/json" -body (ConvertTo-Json $body) -ErrorAction stop 
            }
            [VSTeamWorkItemTypeCache]::InvalidateByProcess($ProcessTemplate)
            $resp.PSObject.TypeNames.Insert(0, 'Team.WorkItemType')
            Add-Member           -InputObject $resp -MemberType AliasProperty -Name WorkItemType    -Value "name"
            Add-Member -PassThru -InputObject $resp -MemberType NoteProperty  -Name ProcessTemplate -Value $ProcessTemplate
         }
         catch { Write-Warning "$workitemType exists, but failed to update. It may not be possible to change this type." }
      }
   }
}
