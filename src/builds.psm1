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

   if ($Logs.IsPresent) {
      $rootUrl = _buildRootURL -ProjectName $ProjectName -Id $Id -LogIndex $LogIndex -Logs
   }
   else {
      $rootUrl = _buildRootURL -ProjectName $ProjectName -Id $Id -LogIndex $LogIndex
   }


   # Build the url to list the projects
   return $rootUrl + '?api-version=' + $VSTeamVersionTable.Build
}

function _buildChildUrl {
   param(
      [parameter(Mandatory = $true)]
      [string] $ProjectName,
      [int] $Id,
      [int] $LogIndex,
      [string] $Child
   )

   $rootUrl = _buildRootURL -ProjectName $ProjectName -Id $Id -LogIndex $LogIndex
 
   # Build the url to list the projects
   return $rootUrl + "/$Child" + '?api-version=' + $VSTeamVersionTable.Build
}

function _buildRootURL {
   param(
      [parameter(Mandatory = $true)]
      [string] $ProjectName,
      [int] $Id,
      [Switch] $Logs,
      [int] $LogIndex
   )
  
   if (-not $VSTeamVersionTable.Account) {
      throw 'You must call Add-VSTeamAccount before calling any other functions in this module.'
   }
  
   $resource = "/build/builds"
   $instance = $VSTeamVersionTable.Account
  
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
   return $instance + "/$projectName/_apis" + $resource
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

   if ($item.PSObject.Properties.Match('queue').count -gt 0 -and $null -ne $item.queue) {
      $item.queue.PSObject.TypeNames.Insert(0, 'Team.Queue')
   }

   if ($item.PSObject.Properties.Match('orchestrationPlan').count -gt 0 -and $null -ne $item.orchestrationPlan) {
      $item.orchestrationPlan.PSObject.TypeNames.Insert(0, 'Team.OrchestrationPlan')
   }
}

function _applyArtifactTypes {
   $item.PSObject.TypeNames.Insert(0, "Team.Build.Artifact")
    
   if ($item.PSObject.Properties.Match('resource').count -gt 0 -and $null -ne $item.resource) {
      $item.resource.PSObject.TypeNames.Insert(0, 'Team.Build.Artifact.Resource')
      $item.resource.properties.PSObject.TypeNames.Insert(0, 'Team.Build.Artifact.Resource.Properties')
   }
}

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
            $resp = _get -url $listurl
            
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
         $resp = _get -url $listurl
         
         # Apply a Type Name so we can use custom format view and custom type extensions
         foreach ($item in $resp.value) {
            _applyTypes -item $item
         }

         Write-Output $resp.value
      }
   }
}

function Show-VSTeamBuild {
   [CmdletBinding(DefaultParameterSetName = 'ByID')]
   param (
      [Parameter(ParameterSetName = 'ByID', ValueFromPipelineByPropertyName = $true)]
      [Alias('BuildID')]
      [int[]] $Id
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      _showInBrowser "$($VSTeamVersionTable.Account)/$ProjectName/_build/index?buildId=$Id"
   }
}

function Get-VSTeamBuildLog {
   [CmdletBinding(DefaultParameterSetName = 'ByID')]
   param (
      [Parameter(Mandatory = $true, ParameterSetName = 'ByID', ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
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

      foreach ($item in $id) {
         if (-not $Index) {
            # Build the url to return the logs of the build
            $listurl = _buildURL -projectName $ProjectName -id $item -Logs

            # Call the REST API to get the number of logs for the build
            $resp = _get -url $listurl

            $fullLogIndex = $($resp.count - 1)
         }
         else {
            $fullLogIndex = $Index
         }

         # Now call REST API with the index for the fullLog
         # Build the url to return the single build
         $listurl = _buildURL -projectName $ProjectName -id $item -Logs -LogIndex $fullLogIndex

         # Call the REST API to get the number of logs for the build
         $resp = _get -url $listurl

         Write-Output $resp.value
      }     
   }
}

function Add-VSTeamBuild {
   [CmdletBinding(DefaultParameterSetName = 'ByName')]
   param(
      [Parameter(ParameterSetName = 'ByID', ValueFromPipelineByPropertyName = $true)]
      [Int32] $BuildDefinitionId
   )
   DynamicParam {
      $dp = _buildProjectNameDynamicParam

      # If they have not set the default project you can't find the
      # validateset so skip that check. However, we still need to give
      # the option to pass a QueueName to use.
      if ($Global:PSDefaultParameterValues["*:projectName"]) {
         $queues = Get-VSTeamQueue -ProjectName $Global:PSDefaultParameterValues["*:projectName"]
         $arrSet = $queues.name
      }
      else {
         Write-Verbose 'Call Set-VSTeamDefaultProject for Tab Complete of QueueName'
         $queues = $null
         $arrSet = $null
      }

      $ParameterName = 'QueueName'
      $rp = _buildDynamicParam -ParameterName $ParameterName -arrSet $arrSet
      $dp.Add($ParameterName, $rp)

      if ($Global:PSDefaultParameterValues["*:projectName"]) {
         $buildDefs = Get-VSTeamBuildDefinition -ProjectName $Global:PSDefaultParameterValues["*:projectName"]
         $arrSet = $buildDefs.fullname
      }
      else {
         Write-Verbose 'Call Set-VSTeamDefaultProject for Tab Complete of BuildDefinition'
         $buildDefs = $null
         $arrSet = $null
      }

      $ParameterName = 'BuildDefinitionName'
      $rp = _buildDynamicParam -ParameterName $ParameterName -arrSet $arrSet -ParameterSetName 'ByName'
      $dp.Add($ParameterName, $rp)

      $dp
   }

   process {
      # Bind the parameter to a friendly variable
      $QueueName = $PSBoundParameters["QueueName"]
      $ProjectName = $PSBoundParameters["ProjectName"]
      $BuildDefinition = $PSBoundParameters["BuildDefinitionName"]

      # Build the url
      $listurl = _buildURL -ProjectName $ProjectName

      if ($BuildDefinitionId) {
         $id = $BuildDefinitionId
      }
      else {
         # Find the BuildDefinition id from the name
         $id = Get-VSTeamBuildDefinition -ProjectName "$ProjectName" -Type All |
            Where-Object { $_.fullname -eq $BuildDefinition } |
            Select-Object -ExpandProperty id
      }

      $queueSection = $null
      if ($QueueName) {
         $queueId = Get-VSTeamQueue -ProjectName "$ProjectName" -queueName "$QueueName" |
            Select-Object -ExpandProperty Id

         $queueSection = ', "queue": {"id": ' + $queueId + '}'
      }

      $body = '{"definition": {"id": ' + $id + '}' + $queueSection + '}'

      Write-Verbose $body

      # Call the REST API
      $resp = _post -url $listurl -Body $body
      
      _applyTypes -item $resp

      return $resp
   }
}

function Remove-VSTeamBuild {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
   param(
      [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
      [Alias('BuildID')]
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
               $resp = _delete -url $listurl
               
               Write-Output "Deleted build $item"
            }
            catch {
               _handleException $_
            }
         }
      }
   }
}

function Update-VSTeamBuild {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium")]
   param(
      [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
      [Alias('BuildID')]
      [Int] $Id,

      [parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
      [bool] $KeepForever,

      [parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $BuildNumber,

      [switch] $Force
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   Process {
      $ProjectName = $PSBoundParameters["ProjectName"]

      if ($Force -or $pscmdlet.ShouldProcess($Id, "Update-VSTeamBuild")) {

         $updateUrl = _buildURL -ProjectName $ProjectName -Id $Id

         $body = '{'
            
         $items = New-Object System.Collections.ArrayList

         if ($KeepForever -ne $null) {
            $items.Add("`"keepForever`": $($KeepForever.ToString().ToLower())") > $null
         }

         if ($buildNumber -ne $null -and $buildNumber.Length -gt 0) {
            $items.Add("`"buildNumber`": `"$BuildNumber`"") > $null
         }

         if ($items -ne $null -and $items.count -gt 0) {
            $body += ($items -join ", ")
         }
                
         $body += '}'

         # Call the REST API
         $resp = _patch -url $updateUrl -body $body
      }
   }
}

function Get-VSTeamBuildTag {
   param(
      [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
      [Alias('BuildID')]
      [int] $Id
   )
    
   DynamicParam {
      _buildProjectNameDynamicParam
   }

   Process {
      $ProjectName = $PSBoundParameters["ProjectName"]
        
      $rootUrl = _buildChildUrl -projectName $ProjectName -id $Id -child "tags"

      # Call the REST API
      $resp = _get -url $rootUrl

      return $resp.value
   }
}

function Add-VSTeamBuildTag {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Low")]
   param(
      [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
      [string[]] $Tags,

      [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
      [Alias('BuildID')]
      [int[]] $Id,

      [switch] $Force
   )
    
   DynamicParam {
      _buildProjectNameDynamicParam
   }

   Process {
      $ProjectName = $PSBoundParameters["ProjectName"]
        
      foreach ($item in $id) {
         if ($Force -or $pscmdlet.ShouldProcess($item, "Add-VSTeamBuildTag")) {
                
            $rootUrl = _buildChildUrl -projectName $ProjectName -id $item -child "tags"

            foreach ($tag in $tags) {

               $tagUrl = $rootUrl + "&tag=$tag"

               # Call the REST API
               _put -url $tagUrl
            }
         }
      }
   }
}

function Remove-VSTeamBuildTag {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Low")]
   param(
      [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
      [string[]] $Tags,
        
      [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
      [Alias('BuildID')]
      [int[]] $Id,

      [switch] $Force
   )
    
   DynamicParam {
      _buildProjectNameDynamicParam
   }

   Process {
      $ProjectName = $PSBoundParameters["ProjectName"]

      foreach ($item in $id) {
         if ($Force -or $pscmdlet.ShouldProcess($item, "Remove-VSTeamBuildTag")) {

            $rootUrl = _buildChildUrl -projectName $ProjectName -id $item -child "tags"

            foreach ($tag in $tags) {
               $tagUrl = $rootUrl + "&tag=$tag"

               # Call the REST API
               _delete -url $tagUrl
            }
         }
      }
   }
}

function Get-VSTeamBuildArtifact {
   param(
      [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
      [Alias('BuildID')]
      [int] $Id
   )
    
   DynamicParam {
      _buildProjectNameDynamicParam
   }

   Process {
      $ProjectName = $PSBoundParameters["ProjectName"]
        
      $rootUrl = _buildChildUrl -projectName $ProjectName -id $Id -child "artifacts"

      # Call the REST API
      $resp = _get -url $rootUrl

      foreach ($item in $resp.value) {
         _applyArtifactTypes -item $item
      }

      Write-Output $resp.value
   }
}

Set-Alias Get-Build Get-VSTeamBuild
Set-Alias Show-Build Show-VSTeamBuild
Set-Alias Get-BuildLog Get-VSTeamBuildLog
Set-Alias Get-BuildTag Get-VSTeamBuildTag
Set-Alias Get-BuildArtifact Get-VSTeamBuildArtifact
Set-Alias Add-Build Add-VSTeamBuild
Set-Alias Add-BuildTag Add-VSTeamBuildTag
Set-Alias Remove-Build Remove-VSTeamBuild
Set-Alias Remove-BuildTag Remove-VSTeamBuildTag
Set-Alias Update-Build Update-VSTeamBuild

Export-ModuleMember `
   -Function Add-VSTeamBuild, Get-VSTeamBuild, Remove-VSTeamBuild, Get-VSTeamBuildLog, 
Add-VSTeamBuildTag, Get-VSTeamBuildTag, Remove-VSTeamBuildTag, 
Get-VSTeamBuildArtifact, Update-VSTeamBuild, Show-VSTeamBuild `
   -Alias Get-Build, Show-Build, Get-BuildLog, Get-BuildTag, Get-BuildArtifact, Add-Build, Add-BuildTag,
Remove-Build, Remove-BuildTag, Update-Build