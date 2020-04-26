function Get-VSTeamProcess {
   [CmdletBinding(DefaultParameterSetName = 'List')]
   param(
      [Parameter(ParameterSetName = 'ByName',Mandatory=$true, Position=0)]
      [ArgumentCompleter([ProcessTemplateCompleter])]
      [Alias('ProcessName','ProcessTemplate')]
      $Name,

      [Parameter(ParameterSetName = 'List')]
      [int] $Top = 100,

      [Parameter(ParameterSetName = 'List')]
      [int] $Skip = 0,

      [Parameter(ParameterSetName = 'ByID')]
      [Alias('ProcessTemplateID')]
      [string] $Id,

   )
   process {
      if ($id) {
         $queryString = @{ }

         # Call the REST API
         $resp = _callAPI -area 'process' -resource 'processes' -id $id `
            -Version $(_getApiVersion Core) `
            -QueryString $queryString -NoProject

         $project = [VSTeamProcess]::new($resp)

         Write-Output $project
      }
      elseif ($Name) {
         # Lookup Process ID by Name
         Get-VSTeamProcess | Where-Object {$_.name -like $ProcessName} | Sort-Object -Property Name
      }
      else {
         # Return list of processes
         try {
            # Call the REST API
            $resp = _callAPI -Area 'work' -resource 'processes' `
               -Version $(_getApiVersion Graph)  -NoProject `
               -QueryString @{
               '$top'  = $top
               '$skip' = $skip
            }

            $objs = @()
            #we just fetched the processes so let's update the cache. Also Cache the URLS for processes
            [VSTeamProcessCache]::processes = $resp.value.name | Sort-Object
            [VSTeamProcessCache]::timestamp = (Get-Date).Minute
            $script:ProcessURLHash = @{}
            foreach ($item in $resp.value) {
               $script:ProcessURLHash[$item.name] = [VSTeamVersions]::Account + "/_apis/work/processes/" + $item.typeId
               $objs += [VSTeamProcess]::new($item)
            }
            $objs | Sort-Object -Property Name
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
