function Get-VSTeamProcess {
   [CmdletBinding(DefaultParameterSetName = 'List')]
   param(
      [Parameter(ParameterSetName = 'List')]
      [int] $Top = 100,

      [Parameter(ParameterSetName = 'List')]
      [int] $Skip = 0,

      [Parameter(ParameterSetName = 'ByID')]
      [Alias('ProcessTemplateID')]
      [string] $Id,

      [Parameter(ParameterSetName = 'ByName', Mandatory = $true)]
      [ProcessValidateAttribute()]
      [ArgumentCompleter([ProcessCompleter])]
      [string] $Name
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
         Get-VSTeamProcess | where-object { $_.name -eq $Name }
      }
      else {
         # Return list of processes
         try {
            # Call the REST API
            $resp = _callAPI -area 'process' -resource 'processes' `
               -Version $(_getApiVersion Core) -NoProject `
               -QueryString @{
               '$top'  = $top
               '$skip' = $skip
            }

            $objs = @()
            
            foreach ($item in $resp.value) {
               $objs += [VSTeamProcess]::new($item)
            }

            Write-Output $objs
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
