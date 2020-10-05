$script:processTypeIds = @{}
function _getProcessTemplateUrl {
   Param (
      [Parameter(Mandatory=$true,position=0)]
      $ProcessTemplate
   )
   if ($script:processTypeIds[$ProcessTemplate]) {
         return ((_getInstance) + "/_apis/work/processes/" + $script:processTypeIds[$ProcessTemplate] )
   }
   else {
      $p = Get-VSTeamProcess $ProcessTemplate
      if ($p -and $p.psobject.properties['typeID']) {
         $script:processTypeIds[$ProcessTemplate] = $p.typeid
         return ((_getInstance) + "/_apis/work/processes/" + $p.typeid )
      }
      elseif ($p -and $p.psobject.properties['Id']) {
         $script:processTypeIds[$ProcessTemplate] = $p.Id
         return ((_getInstance) + "/_apis/work/processes/" + $p.Id )
      }
   }
}

function Add-VSTeamWorkItemType {
   [cmdletbinding(SupportsShouldProcess=$true)]
   param(
      [vsteam_lib.ProcessTemplateValidateAttribute()]
      [ArgumentCompleter([vsteam_lib.ProcessTemplateCompleter])]
      $ProcessTemplate = $env:TEAM_PROCESS,

      [parameter(Mandatory = $true)]
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
      $resp = _callapi -Url $url -method  Post  -ContentType "application/json" -body (ConvertTo-Json $body) -erroraction stop
      if ($resp) {
         if ($ProcessTemplate -eq $env:TEAM_PROCESS) {[vsteam_lib.WorkItemTypeCache]::Invalidate()}

         $resp.PSObject.TypeNames.Insert(0, 'vsteam_lib.WorkItemType')
         Add-Member -InputObject $resp -MemberType AliasProperty -Name WorkItemType    -Value "name"
         Add-Member -InputObject $resp -MemberType NoteProperty  -Name ProcessTemplate -Value $ProcessTemplate

         return $resp
      }
   }
}
