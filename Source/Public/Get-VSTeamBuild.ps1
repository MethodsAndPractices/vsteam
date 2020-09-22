function Get-VSTeamBuild {
   [CmdletBinding(DefaultParameterSetName = 'List',
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Get-VSTeamBuild')]
   param (
      [Parameter(ParameterSetName = 'List')]
      [int] $Top,

      [Parameter(ParameterSetName = 'List')]
      [ValidateSet('succeeded', 'partiallySucceeded', 'failed', 'canceled')]
      [string] $ResultFilter,

      [Parameter(ParameterSetName = 'List')]
      [ValidateSet('manual', 'individualCI', 'batchedCI', 'schedule', 'userCreated', 'validateShelveset', 'checkInShelveset', 'triggered', 'all')]
      [string] $ReasonFilter,

      [Parameter(ParameterSetName = 'List')]
      [ValidateSet('inProgress', 'completed', 'cancelling', 'postponed', 'notStarted', 'all')]
      [string] $StatusFilter,

      [Parameter(ParameterSetName = 'List')]
      [int[]] $Queues,

      [Parameter(ParameterSetName = 'List')]
      [int[]] $Definitions,

      [ArgumentCompleter([vsteam_lib.BuildCompleter])]
      [Parameter(ParameterSetName = 'List')]
      [string] $BuildNumber,

      [Parameter(ParameterSetName = 'List')]
      [ValidateSet('build', 'xaml')]
      [string] $Type,

      [Parameter(ParameterSetName = 'List')]
      [int] $MaxBuildsPerDefinition,

      [Parameter(ParameterSetName = 'List')]
      [string[]] $Properties,

      [Parameter(ParameterSetName = 'ByID', ValueFromPipeline = $true)]
      [Alias('BuildID')]

      [int[]] $Id,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )

   process {
      try {
         if ($id) {
            foreach ($item in $id) {
               # Build the url to return the single build
               $resp = _callAPI -ProjectName $projectName `
                  -Area build `
                  -Resource builds `
                  -id $item `
                  -Version $(_getApiVersion Build)

               $build = [vsteam_lib.Build]::new($resp, $ProjectName)

               Write-Output $build
            }
         }
         else {
            # Build the url to list the builds
            $querystring = @{
               '$top'                   = $top
               'type'                   = $type
               'buildNumber'            = $buildNumber
               'resultFilter'           = $resultFilter
               'statusFilter'           = $statusFilter
               'reasonFilter'           = $reasonFilter
               'maxBuildsPerDefinition' = $maxBuildsPerDefinition
               'queues'                 = ($queues -join ',')
               'properties'             = ($properties -join ',')
               'definitions'            = ($definitions -join ',')
            }

            $resp = _callAPI -ProjectName $projectName `
               -Area build `
               -Resource builds `
               -Querystring $queryString `
               -Version $(_getApiVersion Build)

            $objs = @()

            foreach ($item in $resp.value) {
               $objs += [vsteam_lib.Build]::new($item, $ProjectName)
            }

            Write-Output $objs
         }
      }
      catch {
         _handleException $_
      }
   }
}