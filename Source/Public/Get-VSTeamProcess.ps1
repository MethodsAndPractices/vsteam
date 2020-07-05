# id: 02cc6a73-5cfb-427d-8c8e-b49fb086e8af
# area: processes
# resource name: processes
# route template: _apis/work/{resource}/{processTypeId}
#
# First appears in TFS 2017 U2 with same values in TFS 2017 U3:
# resourceVersion : 1
# minVersion      : 2.1
# maxVersion      : 3.2
# releasedVersion : 0.0
# However, I was unable to get any combination of versions to work.
#
# TFS 2018 U1 returns values
# resourceVersion : 1
# minVersion      : 2.1
# maxVersion      : 4.0
# releasedVersion : 0.0

function Get-VSTeamProcess {
   [CmdletBinding(DefaultParameterSetName = 'List')]
   param(
      [Parameter(ParameterSetName = 'ByName', Position = 0)]
      [ArgumentCompleter([ProcessTemplateCompleter])]
      [Alias('ProcessName', 'ProcessTemplate')]
      $Name = '*',

      [Parameter(DontShow = $true, ParameterSetName = 'List')]
      [int] $Top = 100,

      [Parameter(DontShow = $true, ParameterSetName = 'List')]
      [int] $Skip = 0,

      [Parameter(ParameterSetName = 'ByID')]
      [Alias('ProcessTemplateID')]
      [string] $Id
   )
   process {
      # The REST API ignores Top and Skip but allows them to be specified & the function does the same. 
      if ($PSBoundParameters['Top', 'Skip'] -gt 0) {
         Write-Warning "You specified -Top $Top , -Skip $Skip These parameters are ignored and will be removed in future"
      }

      # Return either a single proces by ID or a list of processes
      if ($id) {
         # Call the REST API with an ID
         $resp = _callAPI -NoProject -Area 'work' -resource 'processes' -id $id  -Version $(_getApiVersion Processes) 

         if ($resp) {
            return [VSTeamProcess]::new($resp)
         }
      }
      else {
         try {
            # Call the REST API
            $resp = _callAPI -NoProject -Area 'work' -resource 'processes' -Version (_getApiVersion Processes)  
         }
         catch {
            # I catch because using -ErrorAction Stop on the Invoke-RestMethod
            # was still running the foreach after and reporting useless errors.
            # This casuses the first error to terminate this execution.
            _handleException $_
         }
         
         # We just fetched all the processes so let's update the cache. Also, cache the URLS for processes
         [VSTeamProcessCache]::processes = $resp.value.name | Sort-Object
         [VSTeamProcessCache]::timestamp = (Get-Date).Minute
         $resp.value | ForEach-Object {
            [VSTeamProcessCache]::urls[$_.name] = (_getInstance) + "/_apis/work/processes/" + $_.TypeId
            [VSTeamProcess]::new($_)
         } | Where-Object { $_.name -like $Name } | Sort-Object -Property Name
      }
   }
}
