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

function Get-Release {
   [CmdletBinding(DefaultParameterSetName='List')]
   param(
      [ValidateSet('environments','artifacts', 'approvals', 'none')]
      [string] $expand,

      [Parameter(ParameterSetName='List')]
      [ValidateSet('Draft', 'Active', 'Abandoned')]
      [string] $statusFilter,

      [Parameter(ParameterSetName='List')]
      [int] $definitionId,

      [Parameter(ParameterSetName='List')]
      [int] $top,

      [Parameter(ParameterSetName='List')]
      [string] $createdBy,

      [Parameter(ParameterSetName='List')]
      [DateTime] $minCreatedTime,

      [Parameter(ParameterSetName='List')]
      [DateTime] $maxCreatedTime,

      [Parameter(ParameterSetName='List')]
      [ValidateSet('ascending', 'descending')]
      [string] $queryOrder,

      [Parameter(ParameterSetName='List')]
      [string] $continuationToken,

      [Parameter(ParameterSetName='ByID', ValueFromPipelineByPropertyName=$true)]
      [Alias('ReleaseID')]
      [int[]] $id
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   process {
      Write-Debug 'Get-Release Process'

      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      if($id) {
         foreach ($item in $id) {
            $listurl = _buildReleaseURL -resource 'releases' -version '3.0-preview.3' -projectName $projectName -id $item

            # Call the REST API
            Write-Debug 'Get-Release Call the REST API'
            if (_useWindowsAuthenticationOnPremise) {
              $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Uri $listurl -UseDefaultCredentials
            } else {
              $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Uri $listurl -Headers @{Authorization = "Basic $env:TEAM_PAT"}
            }

            # Apply a Type Name so we can use custom format view and custom type extensions
            _applyTypes -item $resp

            Write-Output $resp
         }
      } else {
         $listurl = _buildReleaseURL -resource 'releases' -version '3.0-preview.3' -projectName $ProjectName

         $listurl += _appendQueryString -name "`$top" -value $top
         $listurl += _appendQueryString -name "`$expand" -value $expand
         $listurl += _appendQueryString -name "createdBy" -value $createdBy
         $listurl += _appendQueryString -name "queryOrder" -value $queryOrder
         $listurl += _appendQueryString -name "statusFilter" -value $statusFilter
         $listurl += _appendQueryString -name "definitionId" -value $definitionId
         $listurl += _appendQueryString -name "minCreatedTime" -value $minCreatedTime
         $listurl += _appendQueryString -name "maxCreatedTime" -value $maxCreatedTime
         $listurl += _appendQueryString -name "continuationToken" -value $continuationToken

         # Call the REST API
         if (_useWindowsAuthenticationOnPremise) {
           $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Uri $listurl -UseDefaultCredentials
         } else {
           $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Uri $listurl -Headers @{Authorization = "Basic $env:TEAM_PAT"}
         }

         # Apply a Type Name so we can use custom format view and custom type extensions
         foreach($item in $resp.value) {
            _applyTypes -item $item
         }

         Write-Output $resp.value
      }
   }
}

function Add-Release {
   [CmdletBinding(DefaultParameterSetName='ById', SupportsShouldProcess=$true, ConfirmImpact="Medium")]
   param(
      [Parameter(ParameterSetName='ById', Mandatory=$true)]
      [int] $DefinitionId,

      [Parameter(Mandatory=$false)]
      [string] $Description,

      [Parameter(ParameterSetName='ById', Mandatory=$true)]
      [string] $ArtifactAlias,

      [Parameter()]
      [string] $Name,

      [Parameter(ParameterSetName='ById', Mandatory=$true)]
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
         $defs = Get-ReleaseDefinition -ProjectName $Global:PSDefaultParameterValues["*:projectName"] -expand artifacts
         $arrSet = $defs.name
      } else {
         Write-Verbose 'Call Set-DefaultProject for Tab Complete of DefinitionName'
         $defs = $null
         $arrSet = $null
      }

      $ParameterName = 'DefinitionName'
      $rp = _buildDynamicParam -ParameterName $ParameterName -arrSet $arrSet -ParameterSetName 'ByName' -Mandatory $true
      $dp.Add($ParameterName, $rp)

      if($Global:PSDefaultParameterValues["*:projectName"]) {
         $builds = Get-Build -ProjectName $Global:PSDefaultParameterValues["*:projectName"]
         $arrSet = $builds.name
      } else {
         Write-Verbose 'Call Set-DefaultProject for Tab Complete of BuildName'
         $builds = $null
         $arrSet = $null
      }

      $ParameterName = 'BuildNumber'
      $rp = _buildDynamicParam -ParameterName $ParameterName -arrSet $arrSet -ParameterSetName 'ByName' -Mandatory $true
      $dp.Add($ParameterName, $rp)

      $dp
   }

   process {
      Write-Debug 'Add-Release Process'

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
      $url = _buildReleaseURL -resource 'releases' -version '3.0-preview.3' -projectName $projectName

      $body = '{"definitionId": ' + $DefinitionId + ', "description": "' + $description + '", "artifacts": [{"alias": "' + $artifactAlias + '", "instanceReference": {"id": "' + $buildId + '", "name": "' + $Name + '", "sourceBranch":"' + $SourceBranch + '"}}]}'

      Write-Verbose $body

      # Call the REST API
      if ($force -or $pscmdlet.ShouldProcess($description, "Add Release")) {

         try {
            Write-Debug 'Add-Release Call the REST API'
            if (_useWindowsAuthenticationOnPremise) {
              $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Method Post -Uri $url -ContentType "application/json" -UseDefaultCredentials -Body $body
            } else {
              $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Method Post -Uri $url -ContentType "application/json" -Headers @{Authorization = "Basic $env:TEAM_PAT"} -Body $body
            }

            _applyTypes $resp

            Write-Output $resp
         }
         catch {
            _handleException $_
         }
      }
   }
}

function Remove-Release {
   [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact="High")]
   param(
      [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
      [int[]] $Id,

      # Forces the command without confirmation
      [switch] $Force
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   Process {
      Write-Debug 'Remove-Release Process'

      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      foreach ($item in $id) {
         $listurl = _buildReleaseURL -resource 'releases' -version '3.0-preview.3' -projectName $ProjectName -id $item

         if ($force -or $pscmdlet.ShouldProcess($item, "Delete Release")) {
            Write-Debug 'Remove-Release Call the REST API'

            try {
               # Call the REST API
               if (_useWindowsAuthenticationOnPremise) {
                 $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Method Delete -Uri $listurl -UseDefaultCredentials
               } else {
                 $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Method Delete -Uri $listurl -Headers @{Authorization = "Basic $env:TEAM_PAT"}
               }

               Write-Output "Deleted release $item"
            }
            catch {
               _handleException $_
            }
         }
      }
   }
}

function Set-ReleaseStatus {
   [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact="Medium")]
   param(
      [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
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
      Write-Debug 'Set-ReleaseStatus Process'

      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      $body = '{ "status": "' + $status + '" }'

      foreach ($item in $id) {
         $listurl = _buildReleaseURL -resource 'releases' -version '3.0-preview.3' -projectName $ProjectName -id $item

         if ($force -or $pscmdlet.ShouldProcess($item, "Delete Release")) {
            Write-Debug 'Remove-Release Call the REST API'

            try {
               # Call the REST API
               if (_useWindowsAuthenticationOnPremise) {
                 $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Method Patch -Uri $listurl -ContentType "application/json" -UseDefaultCredentials -Body $body
               } else {
                 $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Method Patch -Uri $listurl -ContentType "application/json" -Headers @{Authorization = "Basic $env:TEAM_PAT"} -Body $body
               }

               Write-Output "Release $item status changed to $status"
            }
            catch {
               _handleException $_
            }
         }
      }
   }
}

function Add-ReleaseEnvironment {
   [CmdletBinding(DefaultParameterSetName='ById', SupportsShouldProcess=$true, ConfirmImpact="Medium")]
   param(
      [Parameter(ParameterSetName='ById', Mandatory=$true)]
      [int] $ReleaseId,   

      [Parameter(ParameterSetName='ById', Mandatory=$true)]
      [string] $EnvironmentId,

      [Parameter(ParameterSetName='ById', Mandatory=$true)]
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
         $defs = Get-ReleaseDefinition -ProjectName $Global:PSDefaultParameterValues["*:projectName"] -expand artifacts
         $arrSet = $defs.name
      } else {
         Write-Verbose 'Call Set-DefaultProject for Tab Complete of DefinitionName'
         $defs = $null
         $arrSet = $null
      }

      $ParameterName = 'DefinitionName'
      $rp = _buildDynamicParam -ParameterName $ParameterName -arrSet $arrSet -ParameterSetName 'ByName' -Mandatory $true
      $dp.Add($ParameterName, $rp)

      if($Global:PSDefaultParameterValues["*:projectName"]) {
         $builds = Get-Build -ProjectName $Global:PSDefaultParameterValues["*:projectName"]
         $arrSet = $builds.name
      } else {
         Write-Verbose 'Call Set-DefaultProject for Tab Complete of BuildName'
         $builds = $null
         $arrSet = $null
      }

      $ParameterName = 'BuildNumber'
      $rp = _buildDynamicParam -ParameterName $ParameterName -arrSet $arrSet -ParameterSetName 'ByName' -Mandatory $true
      $dp.Add($ParameterName, $rp)

      $dp
   }

   process {
      Write-Debug 'Add-ReleaseEnvironment Process'

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
                              -version '3.0-preview.3'
                              -projectName $projectName

      $body = '{"status": "' + $EnvironmentStatus + '"}'       

      Write-Verbose $body

      # Call the REST API
      if ($force -or $pscmdlet.ShouldProcess("Add ReleaseEnvironment")) {

         try {
            Write-Debug 'Add-ReleaseEnvironment Call the REST API'
            if (_useWindowsAuthenticationOnPremise) {
              $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Method Patch -Uri $url -ContentType "application/json" -UseDefaultCredentials -Body $body
            } else {
              $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Method Patch -Uri $url -ContentType "application/json" -Headers @{Authorization = "Basic $env:TEAM_PAT"} -Body $body
            }

            # _applyTypes $resp

            Write-Output $resp
         }
         catch {
            _handleException $_
         }
      }
   }
}

Export-ModuleMember -Alias * -Function Get-Release, Add-Release, Remove-Release, Set-ReleaseStatus, Add-ReleaseEnvironment