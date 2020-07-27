class VSTeamQueryCache {
   static [int] $timestamp = -1
   static [object] $queries = $null

   static [Void] Update() {
      $projectName = (_getDefaultProject)

      if ($projectName) {
         [VSTeamQueryCache]::queries = $(_callAPi -ProjectName $projectName `
               -Area wit -Resource queries -QueryString @{'$depth' = 1 } -version $(_getApiVersion core)).value.children | 
         Where-Object -Property isfolder -ne "True" | 
         Select-Object Name, ID | 
         Sort-Object Name
               
         [VSTeamQueryCache]::timestamp = (Get-Date).TimeOfDay.TotalMinutes
      }
   }

   static [void] Invalidate() {
      [VSTeamQueryCache]::timestamp = -1
   }

   static [object] GetCurrent() {
      if (_hasQueryCacheExpired) {
         [VSTeamQueryCache]::Update()
      }

      return ([VSTeamQueryCache]::queries)
   }
}