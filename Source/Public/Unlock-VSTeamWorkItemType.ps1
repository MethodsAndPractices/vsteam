function Unlock-VSTeamWorkItemType {
   [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='High')]
   param(
      [Parameter(Position=0,ValueFromPipeline=$true,Mandatory=$true)]
      $WorkItemType,

      [AllowNull()]
      [ValidateSet('behaviors','layout','states')]
      [string[]]$Expand,

      [switch]$Force
   )
   process {
      if (-not ($WorkItemType.psobject.properties["customization"] -and $WorkItemType.customization -eq 'system')) {
         return $WorkItemType
      }
      else {
         $url  = ($WorkItemType.url -replace '/workItemTypes/.*$', '/workItemTypes?api-version=') +  (_getApiVersion Processes)
         $body = @{
            color        = $WorkItemType.color
            description  = $WorkItemType.description
            icon         = $WorkItemType.icon
            inheritsFrom = $WorkItemType.referenceName
            isDisabled   = $WorkItemType.isDisabled
            name         = $WorkItemType.name
         }
         if ($force -or $PSCmdlet.ShouldProcess($WorkItemType.name,"Update WorkItemType")) {
            $resp = _callAPI -Url $url -method Post -body (ConvertTo-Json $body)
            if ($expand) {Get-VSTeamWorkItemType -ProcessTemplate $WorkItemType.ProcessTemplate -WorkItemType $WorkItemType.name -Expand $Expand}
            else         {
               # Apply a Type Name so we can use custom format view and/or custom type extensions
               #  add members to help piping into other functions
               _applyTypesWorkItemType -item $resp
               Add-Member -InputObject $resp -MemberType AliasProperty -Name "WorkItemType"    -Value "name"
               if ($WorkItemType.psobject.properties["ProcessTemplate"]) {
                  Add-Member -InputObject $resp -MemberType NoteProperty  -Name "ProcessTemplate" -Value $WorkItemType.ProcessTemplate
               }
               return $resp
            }
         }
      }
   }
}

