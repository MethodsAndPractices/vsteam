function Add-VSTeamWorkItemType {
   [cmdletbinding(SupportsShouldProcess=$true)]
   param(
      [ProcessValidateAttribute()]
      [ArgumentCompleter([ProcessTemplateCompleter])]
      $ProcessTemplate = $env:TEAM_PROCESS,

      [parameter(Mandatory = $true)]
      [Alias('Name')]
      [string] $WorkItemType,

      [string] $Description,

      [ArgumentCompleter([ColorCompleter])]
      [ColorTransformToHexAttribute()]
      $Color = '000000',

      [IconTransformAttribute()]
      [ArgumentCompleter([IconCompleter])]
      [string]$Icon = 'icon_asterisk'
   )

   $url =  [VSTeamProcessCache]::GetURl($ProcessTemplate)
   if (-not $url) {Write-Warning "Could not convert '$ProcessTemplate' into a process template"; return}
   $url += "/workitemtypes?api-version=" + (_getApiVersion ProcessDefinition)  
   
   $body  = @{
      name  = $WorkItemType
      color = $Color 
      icon  = $Icon
   }
   if ($Description)  {$body['description'] =$Description }

   if ($PSCmdlet.ShouldProcess($ProcessTemplate, "Add workitem '$WorkItemType' to process template"))  {

      $resp = _callapi -Url $url -method  Post  -ContentType "application/json" -body (ConvertTo-Json $body)
      [VSTeamWorkItemTypeCache]::InvalidateByProcess($ProcessTemplate)
      $resp.PSObject.TypeNames.Insert(0, 'Team.WorkItemType')
      Add-Member           -InputObject $resp -MemberType AliasProperty -Name WorkItemType    -Value "name"
      Add-Member -PassThru -InputObject $resp -MemberType NoteProperty  -Name ProcessTemplate -Value $ProcessTemplate
   }
}

