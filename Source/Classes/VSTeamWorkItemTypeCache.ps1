class VSTeamWorkItemTypeCache {
   static hidden [dateTime]  $Timestamp           = 0
   static hidden [int]       $MaxAgeMins          = 5
   static hidden [string]    $CachedProjectName   = ''
   static hidden [object[]]  $WorkItemTypes       = @()
   static hidden [hashtable] $ProcessWITs         = @{}
   static hidden [hashtable] $ProcessTimeStamps   = @{}

   #Allow the class to be  updated with a list. If no list is given we'll get the one first 
   static [Void] Update ([object[]]$NewItems, $ProjectName) {
      [VSTeamWorkItemTypeCache]::WorkItemTypes = $NewItems 
      [VSTeamWorkItemTypeCache]::CachedProjectName =  $ProjectName 
      [VSTeamWorkItemTypeCache]::timestamp = Get-Date
   }
   static [Void] Update (  ) {
      [VSTeamWorkItemTypeCache]::WorkItemTypes = @()
      $projectName=  _getDefaultProject
      $list = @() + (Get-VSTeamWorkItemType -ProjectName $projectName | Where-Object {-Not $_.hidden} |Sort-Object -Property Name)
      #if Get-VSTeamWorkItemType  didn't update the cache for us, do it now.
      if ($list -and [VSTeamWorkItemTypeCache]::WorkItemTypes.count -eq 0)  {[VSTeamWorkItemTypeCache]::update($list,$projectName) }
   }

   static [bool] HasExpired () { 
      return ([VSTeamWorkItemTypeCache]::timestamp.AddMinutes([VSTeamWorkItemTypeCache]::MaxAgeMins) -lt (Get-Date)) 
   }
   static [object[]] GetCurrent () {
         #Update first if the default project has changed or data is too old. 
         if ([VSTeamWorkItemTypeCache]::HasExpired() -or 
             [VSTeamWorkItemTypeCache]::CachedProjectName -ne (_getDefaultProject)  ) {
             [VSTeamWorkItemTypeCache]::Update()
      }
      return [VSTeamWorkItemTypeCache]::WorkItemTypes
   }
   static [void] Invalidate () {
      [VSTeamWorkItemTypeCache]::timestamp = 0
      [VSTeamWorkItemTypeCache]::CachedProjectName = ''
   }
   static [bool] HasExpiredByProcess ([string]$ProcessName) { 
      return ([VSTeamWorkItemTypeCache]::ProcessTimeStamps[$ProcessName] -isnot [datetime] -or
              [VSTeamWorkItemTypeCache]::ProcessTimeStamps[$ProcessName].AddMinutes([VSTeamWorkItemTypeCache]::MaxAgeMin) -lt (Get-Date)) 
   } 
   static [Void] UpdateByProcess ([string]$ProcessName, [object[]]$NewItems) {
         [VSTeamWorkItemTypeCache]::ProcessWITs[$ProcessName]       = $NewItems
         [VSTeamWorkItemTypeCache]::ProcessTimeStamps[$ProcessName] = Get-Date 
   }
   static [Void] UpdateByProcess ([string]$ProcessName) {
         [VSTeamWorkItemTypeCache]::ProcessWITs[$ProcessName]       = @()
         $list = Get-VSTeamWorkItemType -ProcessTemplate $ProcessName | Sort-Object -Property Name
         if ([VSTeamWorkItemTypeCache]::ProcessWITs[$ProcessName].Count -eq 0) {
             [VSTeamWorkItemTypeCache]::UpdateByProcess($ProcessName,$list)
         }
   }
   static [object[]] GetByProcess ([string]$ProcessName) {
      #if ProcessNameIsBlank return the defaults 
      if ([string]::IsNullOrEmpty($ProcessName)) {
         return [VSTeamWorkItemTypeCache]::GetCurrent()
      }
      else {
         #Must be a valid proces; update if no time or old time kept for this process. 
         if    ([VSTeamProcessCache]::GetCurrent() -contains $ProcessName -and [VSTeamWorkItemTypeCache]::HasExpiredByProcess($ProcessName)) {
                [VSTeamWorkItemTypeCache]::UpdateByProcess($ProcessName)
         }
         return [VSTeamWorkItemTypeCache]::ProcessWITs[$ProcessName] 
      }
   }
   static [void] InvalidateByProcess ([string]$ProcessName) {
      [VSTeamWorkItemTypeCache]::ProcessTimeStamps.Remove( $ProcessName)
   }
}