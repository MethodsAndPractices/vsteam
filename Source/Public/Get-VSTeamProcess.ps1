function Get-VSTeamProcess {
   [CmdletBinding(DefaultParameterSetName = 'List')]
  # [OutputType([vsteamprocess])]
   param(
      [Parameter(ParameterSetName = 'ByName', Position=0)]
      [ArgumentCompleter([ProcessTemplateCompleter])]
      [Alias('ProcessName','ProcessTemplate')]
      $Name = '*',

      [Parameter(DontShow=$true, ParameterSetName = 'List')]
      [int] $Top = 100,

      [Parameter(DontShow=$true, ParameterSetName = 'List')]
      [int] $Skip = 0,

      [Parameter(ParameterSetName = 'ByID')]
      [Alias('ProcessTemplateID')]
      [string] $Id
   )
   process {
      # The REST API ignores Top and Skip but allows them to be specified & the function does the same. 

      # Return either a single proces by ID or a list of processes
      if ($id) {
         # Call the REST API with an ID
         $resp = _callAPI -NoProject -area 'work' -resource 'processes' -id $id  -Version $(_getApiVersion Core) 

         if ($resp) {
            return [VSTeamProcess]::new($resp)
         }
      }
      else {
         try {
            # Call the REST API
            $resp = _callAPI -NoProject -Area 'work' -resource 'processes' -Version (_getApiVersion core)  

            #we just fetched all the processes so let's update the cache. Also, cache the URLS for processes
            [VSTeamProcessCache]::processes = $resp.value.name | Sort-Object
            [VSTeamProcessCache]::timestamp = (Get-Date).Minute
            $resp.value | ForEach-Object {
               [VSTeamProcessCache]::urls[$_.name] =  (_getInstance) + "/_apis/work/processes/" + $_.TypeId
               [VSTeamProcess]::new($_)
            } | Where-Object {$_.name -like $Name} | Sort-Object -Property Name
         }
         catch {
            # I catch because using -ErrorAction Stop on the Invoke-RestMethod
            # was still running the foreach after and reporting useless errors.
            # This casuses the first error to terminate this execution.
            _handleException $_
         }
      }
   }
}
