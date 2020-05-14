class VSTeamQueryCache {
   static [int] $timestamp = -1
   static [object] $queries = $null
   static [Void] Update () {
      $projectName = (_getDefaultProject)
      if ($projectName) {
         [VSTeamQueryCache]::queries  =  (_callAPi -ProjectName $projectName  -Area wit -Resource queries -version (_getApiVersion core ) -QueryString @{'$depth'=1}
                                         ).value.children | Where-Object -property isfolder -ne "True"  | Select-Object Name,ID | Sort-Object Name
         [VSTeamQueryCache]::timestamp = (Get-Date).TimeOfDay.TotalMinutes
      }
   }
   static [void] Invalidate () {
      [VSTeamQueryCache]::timestamp = -1
   }
   static [object] GetCurrent () {
      if ([VSTeamQueryCache]::timestamp -lt 0 -or
          [VSTeamQueryCache]::timestamp -lt [datetime]::Now.TimeOfDay.TotalMinutes -5) {
          [VSTeamQueryCache]::Update()
      }
      return ([VSTeamQueryCache]::queries)
   }
}