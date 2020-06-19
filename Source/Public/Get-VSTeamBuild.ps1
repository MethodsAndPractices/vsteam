function Get-VSTeamBuild {
   [CmdletBinding(DefaultParameterSetName = 'List')]
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

      [ArgumentCompleter([BuildCompleter])]
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

      [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
      [ProjectValidateAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      [string] $ProjectName
   )

   process {
      try {
         if ($id) {
            foreach ($item in $id) {
               # Build the url to return the single build
               $resp = _callAPI -ProjectName $projectName -Area 'build' -Resource 'builds' -id $item `
                  -Version $(_getApiVersion Build)

               _applyTypesToBuild -item $resp

               Write-Output $resp
            }
         }
         else {
            # Build the url to list the builds
            $resp = _callAPI -ProjectName $projectName -Area 'build' -Resource 'builds' `
               -Version $(_getApiVersion Build) `
               -Querystring @{
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

            # Apply a Type Name so we can use custom format view and custom type extensions
            foreach ($item in $resp.value) {
               _applyTypesToBuild -item $item
            }

            Write-Output $resp.value
         }
      }
      catch {
         _handleException $_
      }
   }
}