function Get-VSTeamProcess {
   [CmdletBinding(DefaultParameterSetName = 'List')]
   param(
      [Parameter(ParameterSetName = 'List')]
      [int] $Top = 100,

      [Parameter(ParameterSetName = 'List')]
      [int] $Skip = 0,

      [Parameter(ParameterSetName = 'ByID')]
      [Alias('ProcessTemplateID')]
      [string] $Id
   )

   DynamicParam {
      [VSTeamProcessCache]::timestamp = -1 

      _buildProcessNameDynamicParam -ParameterSetName 'ByName' -ParameterName 'Name'
   }

   process {
      # Bind the parameter to a friendly variable
      $ProcessName = $PSBoundParameters["Name"]

      if ($id) {
         $queryString = @{}

         # Call the REST API
         $resp = _callAPI -Area 'process/processes' -id $id `
            -Version $([VSTeamVersions]::Core) `
            -QueryString $queryString

         $project = [VSTeamProcess]::new($resp)

         Write-Output $project
      }
      elseif ($ProcessName) {
         # Lookup Process ID by Name
         Get-VSTeamProcess | where-object {$_.name -eq $ProcessName}

      }
      else {
         # Return list of processes
         try {
            # Call the REST API
            $resp = _callAPI -Area 'process/processes' `
               -Version $([VSTeamVersions]::Core) `
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