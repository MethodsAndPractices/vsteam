function Get-VSTeamProject {
   [CmdletBinding(DefaultParameterSetName = 'List')]
   param(
      [Parameter(ParameterSetName = 'List')]
      [ValidateSet('WellFormed', 'CreatePending', 'Deleting', 'New', 'All')]
      [string] $StateFilter = 'WellFormed',

      [Parameter(ParameterSetName = 'List')]
      [int] $Top = 100,

      [Parameter(ParameterSetName = 'List')]
      [int] $Skip = 0,

      [Parameter(ParameterSetName = 'ByID')]
      [Alias('ProjectID')]
      [string] $Id,
      
      [switch] $IncludeCapabilities,

      [Parameter(ParameterSetName = 'ByName', Mandatory = $true, Position = 0)]
      [UncachedProjectValidateAttribute()]
      [ArgumentCompleter([UncachedProjectCompleter])]
      [string] $Name
   )

   process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["Name"]

      if ($id) {
         $ProjectName = $id
      }

      if ($ProjectName) {
         $queryString = @{ }
         if ($includeCapabilities.IsPresent) {
            $queryString.includeCapabilities = $true
         }

         # Call the REST API
         $resp = _callAPI -Area 'projects' -id $ProjectName `
            -Version $(_getApiVersion Core) -IgnoreDefaultProject `
            -QueryString $queryString

         # Storing the object before you return it cleaned up the pipeline.
         # When I just write the object from the constructor each property
         # seemed to be written
         $project = [VSTeamProject]::new($resp)

         Write-Output $project
      }
      else {
         try {
            # Call the REST API
            $resp = _callAPI -Area 'projects' `
               -Version $(_getApiVersion Core) -IgnoreDefaultProject `
               -QueryString @{
               stateFilter = $stateFilter
               '$top'      = $top
               '$skip'     = $skip
            }

            $objs = @()
            
            foreach ($item in $resp.value) {
               $objs += [VSTeamProject]::new($item)
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
