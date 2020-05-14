class VSTeamWorkItemTypeCache {
   static hidden [dateTime]  $Timestamp           = 0
   static hidden [int]       $MaxAgeMins          = 5
   static hidden [string]    $CachedProjectName   = ''
   static hidden [object]    $WorkItemTypes       = $null
   static hidden [hashtable] $ProcessWITs         = @{}
   static hidden [hashtable] $ProcesTimeStamps    = @{}

   static [Void] Update (  ) {
      [VSTeamWorkItemTypeCache]::CachedProjectName = _getDefaultProject
      [VSTeamWorkItemTypeCache]::WorkItemTypes  = _getWorkItemTypes | Sort-Object -Property Name
      [VSTeamWorkItemTypeCache]::timestamp = (Get-Date) 
   }

   static [void] Invalidate () {
      [VSTeamWorkItemTypeCache]::timestamp = 0
      [VSTeamWorkItemTypeCache]::CachedProjectName = ''
   }

   static [object] GetCurrent () {
         #Update first if the default project has changed or data is too old. 
         if ([VSTeamWorkItemTypeCache]::timestamp.AddMinutes([VSTeamWorkItemTypeCache]::MaxAgeMins)  -lt (Get-Date) -or 
             [VSTeamWorkItemTypeCache]::CachedProjectName -ne (_getDefaultProject)  ) {

             [VSTeamWorkItemTypeCache]::Update()
      }
      return [VSTeamWorkItemTypeCache]::WorkItemTypes
   }

   static [object] GetByProcess ($ProcessName) {
         #Must be a valid proces; update if not time or old time kept for this process. 
      if    ([VSTeamProcessCache]::GetCurrent() -contains $ProcessName -and
            ([VSTeamWorkItemTypeCache]::ProcesTimeStamps[ $ProcessName] -isnot [datetime] -or
             [VSTeamWorkItemTypeCache]::ProcesTimeStamps[ $ProcessName].AddMinutes([VSTeamWorkItemTypeCache]::MaxAgeMin) -lt (Get-Date)
            )
      ) {
             [VSTeamWorkItemTypeCache]::ProcessWITs[$ProcessName]      = Get-VSTeamWorkItemType -ProcessTemplate $ProcessName | Sort-Object -Property Name
             [VSTeamWorkItemTypeCache]::ProcesTimeStamps[$ProcessName] = Get-Date
      }
      return [VSTeamWorkItemTypeCache]::ProcessWITs[$ProcessName] 
   }
   static [void] InvalidateByProcess ($ProcessName) {
      [VSTeamWorkItemTypeCache]::ProcesTimeStamps.Remove( $ProcessName)
   }

}