Set-StrictMode -Version Latest

# Load common code
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\common.ps1"

# Apply types to the returned objects so format and type files can
# identify the object and act on it.
function _applyTypes {
   param($item)

   $item.PSObject.TypeNames.Insert(0, 'Team.Release')

   if ($item.PSObject.Properties.Match('environments').count -gt 0 -and $null -ne $item.environments) {
      foreach ($e in $item.environments) {
         $e.PSObject.TypeNames.Insert(0, 'Team.Environment')
      }
   }

   $item._links.PSObject.TypeNames.Insert(0, 'Team.Links')
   $item._links.self.PSObject.TypeNames.Insert(0, 'Team.Link')
   $item._links.web.PSObject.TypeNames.Insert(0, 'Team.Link')
}

function Get-VSTeamRelease {
   [CmdletBinding(DefaultParameterSetName = 'List')]
   param(
      [ValidateSet('environments', 'artifacts', 'approvals', 'none')]
      [string] $expand,

      [Parameter(ParameterSetName = 'List')]
      [ValidateSet('Draft', 'Active', 'Abandoned')]
      [string] $statusFilter,

      [Parameter(ParameterSetName = 'List')]
      [int] $definitionId,

      [Parameter(ParameterSetName = 'List')]
      [int] $top,

      [Parameter(ParameterSetName = 'List')]
      [string] $createdBy,

      [Parameter(ParameterSetName = 'List')]
      [DateTime] $minCreatedTime,

      [Parameter(ParameterSetName = 'List')]
      [DateTime] $maxCreatedTime,

      [Parameter(ParameterSetName = 'List')]
      [ValidateSet('ascending', 'descending')]
      [string] $queryOrder,

      [Parameter(ParameterSetName = 'List')]
      [string] $continuationToken,

      [Parameter(ParameterSetName = 'ByID', ValueFromPipelineByPropertyName = $true)]
      [Alias('ReleaseID')]
      [int[]] $id
   )

   DynamicParam {
      _buildProjectNameDynamicParam -Mandatory $false
   }

   process {
      Write-Debug 'Get-VSTeamRelease Process'

      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      if ($id) {
         foreach ($item in $id) {
            $resp = _callAPI -SubDomain vsrm -ProjectName $ProjectName -Area release -id $item -Resource releases -Version $VSTeamVersionTable.Release
            
            # Apply a Type Name so we can use custom format view and custom type extensions
            _applyTypes -item $resp

            Write-Output $resp
         }
      }
      else {
         if ($ProjectName) {
            $listurl = _buildRequestURI -SubDomain vsrm -ProjectName $ProjectName -Area release -Resource releases -Version $VSTeamVersionTable.Release
         }
         else {
            $listurl = _buildRequestURI -SubDomain vsrm -Area release -Resource releases -Version $VSTeamVersionTable.Release
         }

         $QueryString = @{
            '$top'              = $top
            '$expand'           = $expand
            'createdBy'         = $createdBy
            'queryOrder'        = $queryOrder
            'statusFilter'      = $statusFilter
            'definitionId'      = $definitionId
            'minCreatedTime'    = $minCreatedTime
            'maxCreatedTime'    = $maxCreatedTime
            'continuationToken' = $continuationToken
         }

         # Call the REST API
         $resp = _callAPI -url $listurl -QueryString $QueryString

         # Apply a Type Name so we can use custom format view and custom type extensions
         foreach ($item in $resp.value) {
            _applyTypes -item $item
         }

         Write-Output $resp.value
      }
   }
}

function Show-VSTeamRelease {
   [CmdletBinding(DefaultParameterSetName = 'ById')]
   param(
      [Parameter(ParameterSetName = 'ByID', ValueFromPipelineByPropertyName = $true, Mandatory = $true, Position = 1)]
      [Alias('ReleaseID')]
      [int] $id
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   process {
      Write-Debug 'Show-VSTeamRelease Process'

      if ($id -lt 1) {
         Throw "$id is not a valid id. Value must be greater than 0."
      }

      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      # Build the url
      _showInBrowser "$($VSTeamVersionTable.Account)/$ProjectName/_release?releaseId=$id"
   }
}

function Add-VSTeamRelease {
   [CmdletBinding(DefaultParameterSetName = 'ById', SupportsShouldProcess = $true, ConfirmImpact = "Medium")]
   param(
      [Parameter(ParameterSetName = 'ById', Mandatory = $true)]
      [int] $DefinitionId,

      [Parameter(Mandatory = $false)]
      [string] $Description,

      [Parameter(ParameterSetName = 'ById', Mandatory = $true)]
      [string] $ArtifactAlias,

      [Parameter()]
      [string] $Name,

      [Parameter(ParameterSetName = 'ById', Mandatory = $true)]
      [string] $BuildId,

      [Parameter()]
      [string] $SourceBranch,

      # Forces the command without confirmation
      [switch] $Force
   )

   DynamicParam {
      $dp = _buildProjectNameDynamicParam

      # If they have not set the default project you can't find the
      # validateset so skip that check. However, we still need to give
      # the option to pass by name.
      if ($Global:PSDefaultParameterValues["*:projectName"]) {
         $defs = Get-VSTeamReleaseDefinition -ProjectName $Global:PSDefaultParameterValues["*:projectName"] -expand artifacts
         $arrSet = $defs.name
      }
      else {
         Write-Verbose 'Call Set-VSTeamDefaultProject for Tab Complete of DefinitionName'
         $defs = $null
         $arrSet = $null
      }

      $ParameterName = 'DefinitionName'
      $rp = _buildDynamicParam -ParameterName $ParameterName -arrSet $arrSet -ParameterSetName 'ByName' -Mandatory $true
      $dp.Add($ParameterName, $rp)

      if ($Global:PSDefaultParameterValues["*:projectName"]) {
         $builds = Get-VSTeamBuild -ProjectName $Global:PSDefaultParameterValues["*:projectName"]
         $arrSet = $builds.name
      }
      else {
         Write-Verbose 'Call Set-VSTeamDefaultProject for Tab Complete of BuildName'
         $builds = $null
         $arrSet = $null
      }

      $ParameterName = 'BuildNumber'
      $rp = _buildDynamicParam -ParameterName $ParameterName -arrSet $arrSet -ParameterSetName 'ByName' -Mandatory $true
      $dp.Add($ParameterName, $rp)

      $dp
   }

   process {
      Write-Debug 'Add-VSTeamRelease Process'

      # Bind the parameter to a friendly variable
      $BuildNumber = $PSBoundParameters["BuildNumber"]
      $ProjectName = $PSBoundParameters["ProjectName"]
      $DefinitionName = $PSBoundParameters["DefinitionName"]

      #Write-Verbose $builds

      if ($builds -and -not $buildId) {
         $buildId = $builds | Where-Object {$_.name -eq $BuildNumber} | Select-Object -ExpandProperty id
      }

      if ($defs -and -not $artifactAlias) {
         $def = $defs | Where-Object {$_.name -eq $DefinitionName}
         $DefinitionId = $def | Select-Object -ExpandProperty id

         $artifactAlias = $def.artifacts[0].alias
      }

      # Build the url
      $url = _buildReleaseURL -resource 'releases' -projectName $projectName

      $body = '{"definitionId": ' + $DefinitionId + ', "description": "' + $description + '", "artifacts": [{"alias": "' + $artifactAlias + '", "instanceReference": {"id": "' + $buildId + '", "name": "' + $Name + '", "sourceBranch":"' + $SourceBranch + '"}}]}'

      Write-Verbose $body

      # Call the REST API
      if ($force -or $pscmdlet.ShouldProcess($description, "Add Release")) {

         try {
            Write-Debug 'Add-VSTeamRelease Call the REST API'
            $resp = _post -url $url -body $body

            _applyTypes $resp

            Write-Output $resp
         }
         catch {
            _handleException $_
         }
      }
   }
}

function Remove-VSTeamRelease {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [int[]] $Id,

      # Forces the command without confirmation
      [switch] $Force
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   Process {
      Write-Debug 'Remove-VSTeamRelease Process'

      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      foreach ($item in $id) {
         if ($force -or $pscmdlet.ShouldProcess($item, "Delete Release")) {
            Write-Debug 'Remove-VSTeamRelease Call the REST API'

            try {
               # Call the REST API
               _callAPI -Method Delete -SubDomain vsrm -Area release -Resource releases -ProjectName $ProjectName -id $item -Version $VSTeamVersionTable.Release | Out-Null

               Write-Output "Deleted release $item"
            }
            catch {
               _handleException $_
            }
         }
      }
   }
}

function Set-VSTeamReleaseStatus {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium")]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [int[]] $Id,

      [ValidateSet('Active', 'Abandoned')]
      [string] $status,

      # Forces the command without confirmation
      [switch] $Force
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   Process {
      Write-Debug 'Set-VSTeamReleaseStatus Process'

      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      $body = '{ "status": "' + $status + '" }'

      foreach ($item in $id) {
         if ($force -or $pscmdlet.ShouldProcess($item, "Delete Release")) {
            Write-Debug 'Remove-VSTeamRelease Call the REST API'

            try {
               # Call the REST API
               _callAPI -Method Patch -SubDomain vsrm -Area release -Resource releases -projectName $ProjectName -id $item `
                  -body $body -ContentType 'application/json' -Version $VSTeamVersionTable.Release | Out-Null

               Write-Output "Release $item status changed to $status"
            }
            catch {
               _handleException $_
            }
         }
      }
   }
}

function Add-VSTeamReleaseEnvironment {
   [CmdletBinding(DefaultParameterSetName = 'ById', SupportsShouldProcess = $true, ConfirmImpact = "Medium")]
   param(
      [Parameter(ParameterSetName = 'ById', Mandatory = $true)]
      [int] $ReleaseId,   

      [Parameter(ParameterSetName = 'ById', Mandatory = $true)]
      [string] $EnvironmentId,

      [Parameter(ParameterSetName = 'ById', Mandatory = $true)]
      [string] $EnvironmentStatus,

      # Forces the command without confirmation
      [switch] $Force
   )

   DynamicParam {
      $dp = _buildProjectNameDynamicParam

      # If they have not set the default project you can't find the
      # validateset so skip that check. However, we still need to give
      # the option to pass by name.
      if ($Global:PSDefaultParameterValues["*:projectName"]) {
         $defs = Get-VSTeamReleaseDefinition -ProjectName $Global:PSDefaultParameterValues["*:projectName"] -expand artifacts
         $arrSet = $defs.name
      }
      else {
         Write-Verbose 'Call Set-VSTeamDefaultProject for Tab Complete of DefinitionName'
         $defs = $null
         $arrSet = $null
      }

      $ParameterName = 'DefinitionName'
      $rp = _buildDynamicParam -ParameterName $ParameterName -arrSet $arrSet -ParameterSetName 'ByName' -Mandatory $true
      $dp.Add($ParameterName, $rp)

      if ($Global:PSDefaultParameterValues["*:projectName"]) {
         $builds = Get-VSTeamBuild -ProjectName $Global:PSDefaultParameterValues["*:projectName"]
         $arrSet = $builds.name
      }
      else {
         Write-Verbose 'Call Set-VSTeamDefaultProject for Tab Complete of BuildName'
         $builds = $null
         $arrSet = $null
      }

      $ParameterName = 'BuildNumber'
      $rp = _buildDynamicParam -ParameterName $ParameterName -arrSet $arrSet -ParameterSetName 'ByName' -Mandatory $true
      $dp.Add($ParameterName, $rp)

      $dp
   }

   process {
      Write-Debug 'Add-VSTeamReleaseEnvironment Process'

      # Bind the parameter to a friendly variable
      $BuildNumber = $PSBoundParameters["BuildNumber"]
      $ProjectName = $PSBoundParameters["ProjectName"]
      $DefinitionName = $PSBoundParameters["DefinitionName"]

      #Write-Verbose $builds

      if ($builds -and -not $buildId) {
         $buildId = $builds | Where-Object {$_.name -eq $BuildNumber} | Select-Object -ExpandProperty id
      }

      if ($defs -and -not $artifactAlias) {
         $def = $defs | Where-Object {$_.name -eq $DefinitionName}
         
         $artifactAlias = $def.artifacts[0].alias
      }

      # Build the url
      $url = _buildReleaseURL -resource "releases/$ReleaseId/environments/$EnvironmentId"
      -projectName $projectName

      $body = '{"status": "' + $EnvironmentStatus + '"}'       

      Write-Verbose $body

      # Call the REST API
      if ($force -or $pscmdlet.ShouldProcess("Add ReleaseEnvironment")) {

         try {
            Write-Debug 'Add-VSTeamReleaseEnvironment Call the REST API'
            $resp = _callAPI -Method Patch -url $url -body $body -ContentType 'application/json'

            # _applyTypes $resp

            Write-Output $resp
         }
         catch {
            _handleException $_
         }
      }
   }
}

Set-Alias Get-Release Get-VSTeamRelease
Set-Alias Show-Release Show-VSTeamRelease
Set-Alias Add-Release Add-VSTeamRelease
Set-Alias Remove-Release Remove-VSTeamRelease
Set-Alias Set-ReleaseStatus Set-VSTeamReleaseStatus
Set-Alias Add-ReleaseEnvironment Add-VSTeamReleaseEnvironment

Export-ModuleMember `
   -Function Get-VSTeamRelease, Show-VSTeamRelease, Add-VSTeamRelease, Remove-VSTeamRelease, 
Set-VSTeamReleaseStatus, Add-VSTeamReleaseEnvironment `
   -Alias Get-Release, Show-Release, Add-Release, Remove-Release, Set-ReleaseStatus,
Add-ReleaseEnvironment