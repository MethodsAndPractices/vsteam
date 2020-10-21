function Add-VSTeamWorkItemType {
   [cmdletbinding(SupportsShouldProcess=$true)]
   param(
      [Parameter(Position=0, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProcessTemplateValidateAttribute()]
      [ArgumentCompleter([vsteam_lib.ProcessTemplateCompleter])]
      $ProcessTemplate = $env:TEAM_PROCESS,

      [parameter(Mandatory = $true,Position=1)]
      [Alias('Name')]
      [string] $WorkItemType,

      [string] $Description,

      [ArgumentCompleter([vsteam_lib.ColorCompleter])]
      [vsteam_lib.ColorTransformToHexAttribute()]
      $Color = '000000',

      [vsteam_lib.IconTransformAttribute()]
      [ArgumentCompleter([vsteam_lib.IconCompleter])]
      [string]$Icon = 'icon_asterisk'
   )
   process {
      $url =  _getProcessTemplateUrl $ProcessTemplate
      if ($url) {$url += "/workitemtypes?api-version=" + (_getApiVersion Processes)}
      else      {Write-Warning "Could not convert '$ProcessTemplate' into a process template"; return}

      $body  = @{
         name  = $WorkItemType
         color = $Color
         icon  = $Icon
      }
      if ($Description)  {$body['description'] =$Description }

      if ($PSCmdlet.ShouldProcess($ProcessTemplate, "Add workitem '$WorkItemType' to process template"))  {
         $resp = _callapi -Url $url -method  Post -body (ConvertTo-Json $body) -ErrorAction Stop
         if ($resp) {
            if ($ProcessTemplate -eq $env:TEAM_PROCESS) {[vsteam_lib.WorkItemTypeCache]::Invalidate()}

            $resp.PSObject.TypeNames.Insert(0, 'vsteam_lib.WorkItemType')
            Add-Member -InputObject $resp -MemberType AliasProperty -Name WorkItemType    -Value "name"
            Add-Member -InputObject $resp -MemberType NoteProperty  -Name ProcessTemplate -Value $ProcessTemplate

            return $resp
         }
      }
   }
}
