Set-StrictMode -Version Latest

# Load common code
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\common.ps1"

function _buildURL {
   param(
      [parameter(Mandatory = $true)]
      [string] $ProjectName,
      [int] $Id,
      [Switch] $Logs,
      [int] $LogIndex
   )

   if (-not $env:TEAM_ACCT) {
      throw 'You must call Add-TeamAccount before calling any other functions in this module.'
   }

   $version = '2.0'
   $resource = "/build/builds"
   $instance = $env:TEAM_ACCT

   if ($id) {
      $resource += "/$id"
   }

   if ($Logs.IsPresent) {
      $resource += "/logs"

      if ($LogIndex) {
         $resource += "/$LogIndex"
      }
   }

   # Build the url to list the projects
   return $instance + "/$projectName/_apis" + $resource + '?api-version=' + $version
}

# Apply types to the returned objects so format and type files can
# identify the object and act on it.
function _applyTypes {
   param($item)

   $item.PSObject.TypeNames.Insert(0, 'Team.Build')
   $item.logs.PSObject.TypeNames.Insert(0, 'Team.Logs')
   $item._links.PSObject.TypeNames.Insert(0, 'Team.Links')
   $item.project.PSObject.TypeNames.Insert(0, 'Team.Project')
   $item.requestedBy.PSObject.TypeNames.Insert(0, 'Team.User')
   $item.requestedFor.PSObject.TypeNames.Insert(0, 'Team.User')
   $item.lastChangedBy.PSObject.TypeNames.Insert(0, 'Team.User')
   $item.repository.PSObject.TypeNames.Insert(0, 'Team.Repository')
   $item.definition.PSObject.TypeNames.Insert(0, 'Team.BuildDefinition')

   if ($item.PSObject.Properties.Match('queue').count -gt 0 -and $item.queue -ne $null) {
      $item.queue.PSObject.TypeNames.Insert(0, 'Team.Queue')
   }

   if ($item.PSObject.Properties.Match('orchestrationPlan').count -gt 0 -and $item.orchestrationPlan -ne $null) {
      $item.orchestrationPlan.PSObject.TypeNames.Insert(0, 'Team.OrchestrationPlan')
   }
}

function Get-Build {
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
      [int[]] $Id
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      if ($id) {
         foreach ($item in $id) {
            # Build the url to return the single build
            $listurl = _buildURL -projectName $ProjectName -id $item

            # Call the REST API
            if (_useWindowsAuthenticationOnPremise) {
               $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Uri $listurl -UseDefaultCredentials
            }
            else {
               $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Uri $listurl -Headers @{Authorization = "Basic $env:TEAM_PAT"}
            }

            _applyTypes -item $resp

            Write-Output $resp
         }
      }
      else {
         # Build the url to list the builds
         $listurl = _buildURL -projectName $ProjectName

         $listurl += _appendQueryString -name "`$top" -value $top
         $listurl += _appendQueryString -name "type" -value $type
         $listurl += _appendQueryString -name "buildNumber" -value $buildNumber
         $listurl += _appendQueryString -name "resultFilter" -value $resultFilter
         $listurl += _appendQueryString -name "statusFilter" -value $statusFilter
         $listurl += _appendQueryString -name "reasonFilter" -value $reasonFilter
         $listurl += _appendQueryString -name "maxBuildsPerDefinition" -value $maxBuildsPerDefinition

         $listurl += _appendQueryString -name "queues" -value ($queues -join ',')
         $listurl += _appendQueryString -name "properties" -value ($properties -join ',')
         $listurl += _appendQueryString -name "definitions" -value ($definitions -join ',')

         # Call the REST API
         if (_useWindowsAuthenticationOnPremise) {
            $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Uri $listurl -UseDefaultCredentials
         }
         else {
            $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Uri $listurl -Headers @{Authorization = "Basic $env:TEAM_PAT"}
         }

         # Apply a Type Name so we can use custom format view and custom type extensions
         foreach ($item in $resp.value) {
            _applyTypes -item $item
         }

         Write-Output $resp.value
      }
   }
}

function Get-BuildLog {
   [CmdletBinding(DefaultParameterSetName = 'ByID')]
   param (
      [Parameter(ParameterSetName = 'ByID', ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
      [Alias('BuildID')]
      [int[]] $Id,
      [int] $Index
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      if ($id) {
         foreach ($item in $id) {
            if (-not $Index) {
               # Build the url to return the logs of the build
               $listurl = _buildURL -projectName $ProjectName -id $item -Logs

               # Call the REST API to get the number of logs for the build
               if (_useWindowsAuthenticationOnPremise) {
                  $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Uri $listurl -UseDefaultCredentials
               }
               else {
                  $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Uri $listurl -Headers @{Authorization = "Basic $env:TEAM_PAT"}
               }

               $fullLogIndex = $($resp.count - 1)
            } else {
               $fullLogIndex = $Index
            }

            # Now call REST API with the index for the fullLog
            # Build the url to return the single build
            $listurl = _buildURL -projectName $ProjectName -id $item -Logs -LogIndex $fullLogIndex

            # Call the REST API to get the number of logs for the build
            if (_useWindowsAuthenticationOnPremise) {
               $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Uri $listurl -UseDefaultCredentials
            }
            else {
               $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Uri $listurl -Headers @{Authorization = "Basic $env:TEAM_PAT"}
            }

            Write-Output $resp.value
         }
      }
      else {
         # Build the url to list the builds
         $listurl = _buildURL -projectName $ProjectName

         $listurl += _appendQueryString -name "`$top" -value $top
         $listurl += _appendQueryString -name "type" -value $type
         $listurl += _appendQueryString -name "buildNumber" -value $buildNumber
         $listurl += _appendQueryString -name "resultFilter" -value $resultFilter
         $listurl += _appendQueryString -name "statusFilter" -value $statusFilter
         $listurl += _appendQueryString -name "reasonFilter" -value $reasonFilter
         $listurl += _appendQueryString -name "maxBuildsPerDefinition" -value $maxBuildsPerDefinition

         $listurl += _appendQueryString -name "queues" -value ($queues -join ',')
         $listurl += _appendQueryString -name "properties" -value ($properties -join ',')
         $listurl += _appendQueryString -name "definitions" -value ($definitions -join ',')

         # Call the REST API
         if (_useWindowsAuthenticationOnPremise) {
            $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Uri $listurl -UseDefaultCredentials
         }
         else {
            $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Uri $listurl -Headers @{Authorization = "Basic $env:TEAM_PAT"}
         }

         # Apply a Type Name so we can use custom format view and custom type extensions
         foreach ($item in $resp.value) {
            _applyTypes -item $item
         }

         Write-Output $resp.value
      }
   }
}

function Add-Build {
   [CmdletBinding()]
   param()
   DynamicParam {
      $dp = _buildProjectNameDynamicParam

      # If they have not set the default project you can't find the
      # validateset so skip that check. However, we still need to give
      # the option to pass a QueueName to use.
      if ($Global:PSDefaultParameterValues["*:projectName"]) {
         $buildDefs = Get-BuildDefinition -ProjectName $Global:PSDefaultParameterValues["*:projectName"]
         $arrSet = $buildDefs.name
      }
      else {
         Write-Verbose 'Call Set-DefaultProject for Tab Complete of BuildDefinition'
         $buildDefs = $null
         $arrSet = $null
      }

      $ParameterName = 'BuildDefinition'
      $rp = _buildDynamicParam -ParameterName $ParameterName -arrSet $arrSet
      $dp.Add($ParameterName, $rp)

      if ($Global:PSDefaultParameterValues["*:projectName"]) {
         $queues = Get-Queue -ProjectName $Global:PSDefaultParameterValues["*:projectName"]
         $arrSet = $queues.name
      }
      else {
         Write-Verbose 'Call Set-DefaultProject for Tab Complete of QueueName'
         $queues = $null
         $arrSet = $null
      }

      $ParameterName = 'QueueName'
      $rp = _buildDynamicParam -ParameterName $ParameterName -arrSet $arrSet
      $dp.Add($ParameterName, $rp)

      $dp
   }

   process {
      # Bind the parameter to a friendly variable
      $QueueName = $PSBoundParameters["QueueName"]
      $ProjectName = $PSBoundParameters["ProjectName"]
      $BuildDefinition = $PSBoundParameters["BuildDefinition"]

      # Build the url to list the projects
      $listurl = _buildURL -ProjectName $ProjectName

      # Find the BuildDefinition id from the name
      $id = Get-BuildDefinition -ProjectName "$ProjectName" -Type All |
         Where-Object { $_.name -eq $BuildDefinition } |
         Select-Object -ExpandProperty id

      $body = '{"definition": {"id": ' + $id + '}}'

      Write-Verbose $body

      # Call the REST API
      if (_useWindowsAuthenticationOnPremise) {
         $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Method Post -ContentType "application/json" -Body $body -Uri $listurl -UseDefaultCredentials
      }
      else {
         $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Method Post -ContentType "application/json" -Body $body -Uri $listurl -Headers @{Authorization = "Basic $env:TEAM_PAT"}
      }

      _applyTypes -item $resp

      return $resp
   }
}

function Remove-Build {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
   param(
      [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
      [int[]] $Id,

      [switch] $Force
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   Process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      foreach ($item in $id) {
         # Build the url to delete the build
         $listurl = _buildURL -projectName $ProjectName -id $item

         if ($Force -or $pscmdlet.ShouldProcess($item, "Delete Build")) {
            try {
               # Call the REST API
               if (_useWindowsAuthenticationOnPremise) {
                  $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Method Delete -Uri $listurl -UseDefaultCredentials
               }
               else {
                  $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Method Delete -Uri $listurl -Headers @{Authorization = "Basic $env:TEAM_PAT"}
               }

               Write-Output "Deleted build $item"
            }
            catch {
               _handleException $_
            }
         }
      }
   }
}

Export-ModuleMember -Alias * -Function Add-Build, Get-Build, Remove-Build, Get-BuildLog