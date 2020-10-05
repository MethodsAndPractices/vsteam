function Set-VSTeamWorkItemType {
   [CmdletBinding(DefaultParameterSetName='LeaveAlone',SupportsShouldProcess=$true,ConfirmImpact='High')]
   param(
      [parameter(ValueFromPipelineByPropertyName=$true)]
      [vsteam_lib.ProcessTemplateValidateAttribute()]
      [ArgumentCompleter([vsteam_lib.ProcessTemplateCompleter])]
      $ProcessTemplate = $env:TEAM_PROCESS,

      [parameter(Mandatory = $true,ValueFromPipelineByPropertyName=$true, Position=0)]
      [ArgumentCompleter([vsteam_lib.WorkItemTypeCompleter])]
      [Alias('Name')]
      $WorkItemType,

      [string] $Description,

      [ArgumentCompleter([vsteam_lib.ColorCompleter])]
      [vsteam_lib.ColorTransformToHexAttribute()]
      $Color,

      [vsteam_lib.IconTransformAttribute()]
      [ArgumentCompleter([vsteam_lib.IconCompleter])]
      [string]$Icon ,

      [parameter(ParameterSetName='Hide', Mandatory = $true)]
      [switch]$Disabled,

      [parameter(ParameterSetName='Show', Mandatory = $true)]
      [switch]$Enabled,

      [switch]$Force
   )
   process {
      #Get the existing workitem-type definition. Drop out if can't be found 
      $wit  = Get-VSTeamWorkItemType -ProcessTemplate $ProcessTemplate -WorkItemType $WorkItemType
      if (-not $wit) {Write-Warning "'$workitemType' does not appear to be a valid Workitem type." ; return}
      else           {$url  = $wit.url + "?api-version=" + (_getApiVersion Processes)  }

#region set up the contents to go in the JSON body
      $body = @{} #note. "Changing" some options to their current value has caused errors but those below seem OK...
      if ($Icon -and $Icon -ne $wit.icon) {
               $body['icon']        = $Icon
      }
      else {   $body['icon']        = $wit.icon}

      if ($Color -match '^[\da-f]{6}$' -and $color -ne $wit.color) {
               $body['color']       = $Color
      }
      else {   $body['color']       = $wit.color}

      if ($Description -and $Description -ne $wit.description) {
               $body['description'] = $Description 
      } 
      else {   $body['description'] = $wit.description }
      
      if ($Disabled -and -not $wit.isDisabled) {
               $body['isDisabled']  = $true 
      }        
      elseif($Enabled    -and $wit.isDisabled) {
               $body['isDisabled']  = $false 
      }
      else  {  $body['isDisabled']  = $wit.isDisabled }
#endregion      
     if ($Force -or $PSCmdlet.ShouldProcess($WorkItemType,"Modify $ProcessTemplate, to update definition of workitem type") ) {
         <# Call the REST API - 
            if this system definition POST a new definition inheriting from the existing one
            if it is a custom or inherited defintion use PATCH to make chanages. 
         #>
         try   { 
               if ($wit.customization -ne 'system') { 
                   $resp = _callapi -Url $url -method  Patch  -ContentType "application/json" -body (ConvertTo-Json $body) -ErrorAction stop 
               }
               else { #for system items we have to POST to the creation URL
                  $body['inheritsFrom'] = $wit.referenceName
                  $url    = ($url -replace 'workItemTypes/.*$' , 'workItemTypes?api-version=')  + (_getApiVersion Processes) 
                  $resp = _callapi -Url $url -method  POST  -ContentType "application/json" -body (ConvertTo-Json $body) -ErrorAction stop 
               }

          }
         catch { Write-Warning "$workitemType exists, but failed to update. It may not be possible to change this type."}

         # Apply a Type Name so we can use custom format view and custom type extensions and add workitemType
         # and processTemplate properties to become a parameters when the object is piped into other functions
         _applyTypesWorkItemType -item $resp
         Add-Member -InputObject $resp -MemberType AliasProperty -Name WorkItemType    -Value "name"
         Add-Member -InputObject $resp -MemberType NoteProperty  -Name ProcessTemplate -Value $ProcessTemplate

         return $resp 
      }
   }
}
