Set-StrictMode -Version Latest

# Load common code
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\common.ps1"

function _buildURL {
   param(
      [parameter(Mandatory=$true)]
      [string] $ProjectName,
      [int] $Id
   )

   if(-not $env:TEAM_ACCT) {
      throw 'You must call Add-TeamAccount before calling any other functions in this module.'
   }

   $version = '2.0'
   $resource = "/build/definitions"
   $instance = $env:TEAM_ACCT

   if($id) {
      $resource += "/$id"
   }

   # Build the url to list the projects
   return $instance + "/$projectName/_apis" + $resource + '?api-version=' + $version
}

# Apply types to the returned objects so format and type files can
# identify the object and act on it.
function _applyTypes {
   param($item)

   $item.PSObject.TypeNames.Insert(0, 'Team.BuildDefinition')

   $item.project.PSObject.TypeNames.Insert(0, 'Team.Project')

   if($item.PSObject.Properties.Match('authoredBy').count -gt 0 -and $item.authoredBy -ne $null) {
      $item.authoredBy.PSObject.TypeNames.Insert(0, 'Team.User')
   }

   if($item.PSObject.Properties.Match('_links').count -gt 0 -and $item._links -ne $null) {
      $item._links.PSObject.TypeNames.Insert(0, 'Team.Links')
   }

   if($item.PSObject.Properties.Match('queue').count -gt 0 -and $item.queue -ne $null) {
      $item.queue.PSObject.TypeNames.Insert(0, 'Team.Queue')
   }

   # Only returned for a single item
   if($item.PSObject.Properties.Match('variables').count -gt 0 -and $item.variables -ne $null) {
      $item.variables.PSObject.TypeNames.Insert(0, 'Team.Variables')
   }

   if($item.PSObject.Properties.Match('repository').count -gt 0 -and $item.repository -ne $null) {
      $item.repository.PSObject.TypeNames.Insert(0, 'Team.Repository')
   }
}

function Get-BuildDefinition {
   [CmdletBinding(DefaultParameterSetName='List')]
   param(
      [Parameter(ParameterSetName='List')]
      [string] $Filter,
      [Parameter(ParameterSetName='List')]
      [ValidateSet('build','xaml', 'All')]
      [string] $Type = 'All',
      [Parameter(ParameterSetName='ByID', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
      [Alias('BuildDefinitionID')]
      [int[]] $Id,
      [Parameter(ParameterSetName='ByID')]
      [int] $Revision
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      if($id) {
         foreach ($item in $id) {
            # Build the url to list the projects
            $listurl = _buildURL -projectName $projectName -id $item

            if ($revision) {
               $listurl += "&revision=$revision"
            }

            # Call the REST API
            $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Uri $listurl -Headers @{Authorization = "Basic $env:TEAM_PAT"}

            _applyTypes -item $resp

            Write-Output $resp
         }
      } else {
         # Build the url
         $listurl = _buildURL -projectName $ProjectName

         if ($type -ne 'All') {
            $listurl += "&type=$type"
         }

         if($filter) {
            $listurl += "&name=$filter"
         }

         # Call the REST API
         $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Uri $listurl -Headers @{Authorization = "Basic $env:TEAM_PAT"}

         # Apply a Type Name so we can use custom format view and custom type extensions
         foreach($item in $resp.value) {
            _applyTypes -item $item
         }

         Write-Output $resp.value
      }
   }
}

function Add-BuildDefinition {
   [CmdletBinding()]
   param(
      [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
      [string] $InFile
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      # Build the url
      $url = _buildURL -projectName $projectName

      # Call the REST API
      $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Method Post -Uri $url -ContentType "application/json" -Headers @{Authorization = "Basic $env:TEAM_PAT"} -InFile $inFile

      return $resp
   }
}

function Remove-BuildDefinition {
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
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      foreach ($item in $id) {
         $listurl = _buildURL -projectName $ProjectName -id $item

         if ($Force -or $pscmdlet.ShouldProcess($item, "Delete Build Definition")) {
            # Call the REST API
            $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Method Delete -Uri $listurl -Headers @{Authorization = "Basic $env:TEAM_PAT"}

            Write-Output "Deleted build defintion $item"
         }
      }
   }
}

Export-ModuleMember -Alias * -Function Get-BuildDefinition, Add-BuildDefinition, Remove-BuildDefinition