function Get-VSTeamProject {
   [CmdletBinding(DefaultParameterSetName = 'List',
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Get-VSTeamProject')]
   param(
      [Parameter(ParameterSetName = 'List')]
      [ValidateSet('WellFormed', 'CreatePending', 'Deleting', 'New', 'All')]
      [string] $StateFilter = 'WellFormed',

      [Parameter(ParameterSetName = 'List')]
      [int] $Top,

      [Parameter(ParameterSetName = 'List')]
      [int] $Skip,

      [Parameter(ParameterSetName = 'ByID')]
      [Alias('ProjectID')]
      [string] $Id,

      [switch] $IncludeCapabilities,

      [Parameter(ParameterSetName = 'ByName', Position = 0, Mandatory = $true)]
      [vsteam_lib.ProjectValidateAttribute($true)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $Name
   )

   process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["Name"]

      if ($id) {
         $ProjectName = $id
      }

      $commonArgs = @{
         Resource             = 'projects'
         IgnoreDefaultProject = $true
         Version              = $(_getApiVersion Core)
      }

      if ($ProjectName) {
         $queryString = @{ }
         if ($includeCapabilities.IsPresent) {
            $queryString.includeCapabilities = $true
         }

         # Call the REST API
         $resp = _callAPI @commonArgs -id $ProjectName `
            -QueryString $queryString

         # Storing the object before you return it cleaned up the pipeline.
         # When I just write the object from the constructor each property
         # seemed to be written
         $project = [vsteam_lib.Project]::new($resp)

         Write-Output $project
      }
      else {
         try {
            # Call the REST API
            $resp = _callAPI @commonArgs `
               -QueryString @{
               stateFilter = $stateFilter
               '$top'      = $top
               '$skip'     = $skip
            }

            $objs = @()

            foreach ($item in $resp.value) {
               $objs += [vsteam_lib.Project]::new($item)
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
