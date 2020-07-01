function Get-VSTeamWorkItemType {
   [CmdletBinding(DefaultParameterSetName = 'List')]
   param(
      [Parameter(ParameterSetName = 'List',  Mandatory = $true, ValueFromPipelineByPropertyName = $true , Position = 0)]
      [parameter(ParameterSetName='Process', Mandatory = $false)]
      [ProjectValidateAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      $ProjectName,

      [parameter(ParameterSetName='Process', Mandatory = $true , ValueFromPipelineByPropertyName = $true)]
      [ProcessValidateAttribute()]
      [ArgumentCompleter([ProcessTemplateCompleter])]
      $ProcessTemplate,

      [ArgumentCompleter([WorkItemTypeCompleter])]
      [Alias('Name')]
      $WorkItemType,

      [parameter(ParameterSetName='Process',ValueFromPipelineByPropertyName=$true)]
      [ValidateSet('behaviors','layout','states')]
      [string[]]$Expand
   )

   Process {
      # Call the REST API
      if ($WorkItemType -and -not $ProcessTemplate) {
         $resp = _callAPI -ProjectName $ProjectName -Area 'wit' -Resource 'workitemtypes'  `
            -Version $(_getApiVersion Core) -id $WorkItemType

         # This call returns JSON with "": which causes the ConvertFrom-Json to fail.
         # To replace all the "": with "_end":
         $resp = $resp.Replace('"":', '"_end":') | ConvertFrom-Json

         _applyTypesWorkItemType -item $resp

         return $resp
      }
      elseif ($ProcessTemplate) {
         #Get URL for the process from the cache. Cache will be up to date because it was used to validate $ProcessTemplate
         $url =  [VSTeamProcessCache]::GetURl($ProcessTemplate)
         if (-not $url) {Write-Warning "Could not find the Process for '$ProcessTemplate" ; return}
         else   { $url += "/workitemtypes?api-version=" + (_getApiVersion ProcessDefinition)}

         #Call the rest API
         if ($Expand) { $resp = _callAPI -Url $url -QueryString @{'$expand' = ($Expand -Join ',').ToLower() }    }
         else         { $resp = _callapi -Url $url }

         # Add Type for formatting and members to allow piping into commands which look for these as workitemType and ProcessTemplate b-property name
         $resp.value  | ForEach-Object {
               _applyTypesWorkItemType -item $_

               Add-Member -InputObject $_ -MemberType AliasProperty -Name WorkItemType    -Value "name"
               Add-Member -InputObject $_ -MemberType NoteProperty  -Name ProcessTemplate -Value $ProcessTemplate
         }

         # Update cache 
         [VSTeamWorkItemTypeCache]::ProcessWITs[$ProcessTemplate] = $resp.value
         [VSTeamWorkItemTypeCache]::ProcessTimeStamps[$ProcessTemplate] = Get-Date

         #Filter if -WorkItemType was specified
         if (-not $WorkItemType)  { return $resp.value } 
         else { $resp.value | Where-Object {$_.name -like $workitemType} }
      }
      else {
         $resp = _callAPI -ProjectName $ProjectName -Area 'wit' -Resource 'workitemtypes' -Version $(_getApiVersion Core)

         # This call returns JSON with "": which causes the ConvertFrom-Json to fail.
         # To replace all the "": with "_end":
         $resp = $resp.Replace('"":', '"_end":') | ConvertFrom-Json

         #This is rich information but it includes some work item types which are hidden. So find them and mark them.
         $categories = _callAPI -ProjectName $ProjectName -area 'wit' -resource 'workitemtypecategories' -version $(_getApiVersion Core)
         $hidden     = $categories.value.where({$_.referencename -eq "Microsoft.HiddenCategory"}).workitemtypes.name

         # Apply a Type Name so we can use custom format view and custom type extensions
         foreach ($item in $resp.value) {
            _applyTypesWorkItemType -item $item
            Add-Member -PassThru -InputObject $item -MemberType NoteProperty -Name "Hidden" -Value ($item.name -in $hidden)
         }
      }
   }
}