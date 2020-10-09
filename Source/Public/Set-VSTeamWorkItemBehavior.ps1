function Set-VSTeamWorkItemBehavior {
   [CmdletBinding(DefaultParameterSetName='AddOrSet',SupportsShouldProcess=$true,ConfirmImpact='High')]
   param(
      [parameter(ValueFromPipelineByPropertyName=$true)]
      [vsteam_lib.ProcessTemplateValidateAttribute()]
      [ArgumentCompleter([vsteam_lib.ProcessTemplateCompleter])]
      $ProcessTemplate = $env:TEAM_PROCESS,

      [parameter(Mandatory = $true,ValueFromPipelineByPropertyName=$true, Position=0)]
      [ArgumentCompleter([vsteam_lib.WorkItemTypeCompleter])]
      [string]$WorkItemType,

      [parameter(Mandatory =$true, ParameterSetName='AddOrSet')]
      [string]$Behavior,

      [parameter(ParameterSetName='AddOrSet')]
      [switch]$IsDefault,

      [parameter(Mandatory =$true, ParameterSetName='Delete')]
      [switch]$Remove,

      [switch]$Force
   )
   process {
      #Get real backlog behaviors - skip those with a rank of 0 
      if (-not $remove) {
         $processbehaviors = Get-VSTeamProcessBehavior -ProcessTemplate $ProcessTemplate | Where-Object Rank -gt 0 
         #Allow either the name or feature name
         if ($Behavior -in $processbehaviors.name) {
             $Behavior = $processbehaviors.Where({$_.name -eq $Behavior}).referencename 
         }
         if ($Behavior -notin $processbehaviors.referencename) {
            Write-Warning ("$Behavior is not a valid behavior name. Possible names are '" + ($processbehaviors.name -join "', '") + "'") ; return
         }
      }
      $wit = Get-VSTeamWorkitemType -ProcessTemplate $ProcessTemplate -WorkItemType $WorkItemType -Expand behaviors

      $url = ($wit.url -replace '/workItemTypes/' , '/workitemtypesbehaviors/')
      if     ($Remove -and $wit.behaviors.Count -eq 0  ) {Write-Warning  "Nothing to do!" ;return}
      elseif ($Remove) {
            foreach ($b in $wit.behaviors) {
               if ($force -or $PSCmdlet.ShouldProcess($wit.name,'Remove behavior from WorkItem Type')) {
                  $params = @{
                     url = "$url/behaviors/{0}?api-version={1}" -f $b.behavior.id, (_getApiVersion Processes)
                     method = 'Delete' 
                   }
                _callAPI @params
               }
            }
            return
      }
      if ($wit.behaviors.count -gt 0 -and  $wit.behaviors.behavior.id -contains $Behavior) {
         Write-Warning "'$workitemType' is already assigned to $Behavior!. To change the default, remove and re-add it." ;return
      }
      if ($wit.behaviors.count -gt 0 -and  $wit.behaviors.behavior.id -notcontains $Behavior) {
         Write-Warning ("'$workitemType' is already assigned to $($wit.behaviors.behavior.id) remove it before assigning to another type") ; return
      }
      
      $params = @{
         method      = "Post"
         url         = "$url/behaviors?api-version=" + (_getApiVersion Processes)  
         ContentType = "application/json" 
         body        = ConvertTo-JSON @{
            behavior  = @{id= $Behavior} 
            isDefault = $IsDefault -as [bool]
            id        = $wit.referenceName
         }
      }
      if ($Force -or $PSCmdlet.ShouldProcess($WorkItemType,"Modify $ProcessTemplate to update definition of workitem type") ) {
         try   { 
            $resp = _callapi @params -ErrorAction stop  
            $r = [PSCustomObject][ordered]@{ ProcessTemplate = $ProcessTemplate; 
                                             WorkItemType    = $WorkItemType 
                                             Behavior        = $resp.behavior.id
                                             IsDefault       = $resp.isdefault  }
            $r.PSObject.TypeNames.Insert(0, 'vsteam_lib.WorkItembehavior')
            
            return $r
         }
         catch { Write-Warning "$workitemType exists, but failed to update. It may not be possible to change this type."}
      }
   }
}
