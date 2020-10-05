function Get-VSTeamWorkItemType {
   [CmdletBinding(DefaultParameterSetName = 'List',
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Get-VSTeamWorkItemType')]
   param(
      [Parameter(ParameterSetName = 'List',  Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [parameter(ParameterSetName='Process', Mandatory = $false)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName,

      [parameter(ParameterSetName='Process', Mandatory = $true , ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProcessTemplateValidateAttribute()]
      [ArgumentCompleter([vsteam_lib.ProcessTemplateCompleter])]
      $ProcessTemplate,

      [Parameter()]
      [ArgumentCompleter([vsteam_lib.WorkItemTypeCompleter])]
      [string] $WorkItemType = '*',

      [parameter(ParameterSetName='Process',ValueFromPipelineByPropertyName=$true)]
      [ValidateSet('behaviors','layout','states')]
      [string[]]$Expand
   )

   process {
      <# Call the REST API in one of 2 ways; 
        if process template is given, then call as work/processes/workitemtypes (this API doesn't take a workitem ID, and so always returns multiple values)
        otherwise call as wit/workitemtypes  (JSON needs special conversion and contains mutliple  values)
        DON'T validate $workitem type and call with wit/workitemtypes/name - instead allow wildcards and filter down  the workitem(s) will be in $resp after the IF / ELSE 
      #>
      $commonArgs = @{
         ProjectName = $ProjectName
         Area        = 'wit'
         Resource    = 'workitemtypes'
         Version     = $(_getApiVersion Core)
      }
      if (-not $ProcessTemplate) {
         $resp = _callAPI @commonArgs

         # This call returns JSON with "": which causes the ConvertFrom-Json to fail.
         # To replace all the "": with "_end":
         $resp = $resp.Replace('"":', '"_end":') | ConvertFrom-Json | Select-Object -ExpandProperty Value

         #Find Workitem-Types that are hidden in this project 
         #(they may be visible in others using the same process template)
         $commonArgs.Resource = 'workitemtypecategories'
         $resp2  = _callAPI @commonArgs
         if (-not $resp2) {$hidden = @() }
         else             {$hidden = $resp2.value.where({$_.referencename -eq "Microsoft.HiddenCategory"}).workitemtypes.name}

         #Add a property named "hidden" to workitem types, so we can filter pick-lists to visible itmes only later.
         foreach ($item in $resp) {
            Add-Member -InputObject $item  -MemberType NoteProperty -Name "Hidden" -Value ($item.name -in $hidden)
         }

         if ($ProjectName -eq $env:TEAM_PROJECT -and $env:TEAM_PROCESS) {$ProcessTemplate = $env:TEAM_PROCESS}
      }
      else {  
         $url = _getProcessTemplateUrl $ProcessTemplate
         if (-not $url) {Write-Warning "Could not find the Process for '$ProcessTemplate" ; return}
         else           { $url += "/workitemtypes?api-version=" + (_getApiVersion Processes)}
         
         if ($Expand) { $resp = _callAPI -Url $url -QueryString @{'$expand' = ($Expand -Join ',').ToLower() }    }
         else         { $resp = _callapi -Url $url }

         $resp = $resp.value 
      }

      <# Apply a Type Name so we can use custom format view and custom type extensions
         add an alias so that workitemType can become a parameter when the object is piped into other functions
         and the processTemplate name (if there is one) for the same reason. 
         And finally return the items, filtered to any name we given
      #>
      foreach ($item in $resp) {
         _applyTypesWorkItemType -item $item
         Add-Member    -InputObject $item -MemberType AliasProperty -Name "WorkItemType"    -Value "name"
         if ($ProcessTemplate) {
            Add-Member -InputObject $item -MemberType NoteProperty  -Name "ProcessTemplate" -Value $ProcessTemplate
         }
      }

      return ($resp | Where-Object -Property Name -like $WorkItemType)
   }
}