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

      [parameter(ParameterSetName='Process')]
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
         #Get URL for the process - see if we cached it first, if not, request it.
         if ($script:ProcessURLHash -and $script:ProcessURLHash[$ProcessTemplate]) {
                  $url =  $script:ProcessURLHash[$ProcessTemplate]
         }
         else   { $url =  (Get-VSTeamProcess -Name $ProcessTemplate).url}
         if (-not $url) {throw "Could not find the Process for '$ProcessTemplate" ; return}
         else   { $url += "/workitemtypes?api-version=" + (_getApiVersion Graph)}

         if ($Expand) { $resp = _callAPI -Url $url -QueryString @{'$expand' = ($Expand -Join ',').ToLower() }    }
         else         { $resp = _callapi -Url $url }

         if (-not $WorkItemType)  {$WorkItemType = '*'}
         $resp.value | Where-Object {$_.name -like $workitemType} | ForEach-Object {
               _applyTypesWorkItemType -item $_
               #Add members so that we can pipe this into other commands which look for these as valuebypropertyName
               Add-Member           -InputObject $_ -MemberType AliasProperty -Name WorkItemType    -Value "name"
               Add-Member -PassThru -InputObject $_ -MemberType NoteProperty  -Name ProcessTemplate -Value $ProcessTemplate
         }
      }
      else {
         $resp = _callAPI -ProjectName $ProjectName -Area 'wit' -Resource 'workitemtypes' -Version $(_getApiVersion Core)

         # This call returns JSON with "": which causes the ConvertFrom-Json to fail.
         # To replace all the "": with "_end":
         $resp = $resp.Replace('"":', '"_end":') | ConvertFrom-Json

         # Apply a Type Name so we can use custom format view and custom type extensions
         foreach ($item in $resp.value) {
            _applyTypesWorkItemType -item $item
         }

         return $resp.value
      }
   }
}