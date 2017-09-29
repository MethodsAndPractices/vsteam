Set-StrictMode -Version Latest

# Load common code
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\common.ps1"

function _buildURL {
   param(
      [parameter(Mandatory = $true)]
      [string] $ProjectName,
      [int] $Id
   )

   if (-not $env:TEAM_ACCT) {
      throw 'You must call Add-VSTeamAccount before calling any other functions in this module.'
   }

   $version = '2.0'
   $resource = "/build/definitions"
   $instance = $env:TEAM_ACCT

   if ($id) {
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

   if ($item.PSObject.Properties.Match('authoredBy').count -gt 0 -and $null -ne $item.authoredBy) {
      $item.authoredBy.PSObject.TypeNames.Insert(0, 'Team.User')
   }

   if ($item.PSObject.Properties.Match('_links').count -gt 0 -and $null -ne $item._links) {
      $item._links.PSObject.TypeNames.Insert(0, 'Team.Links')
   }

   if ($item.PSObject.Properties.Match('queue').count -gt 0 -and $null -ne $item.queue) {
      $item.queue.PSObject.TypeNames.Insert(0, 'Team.Queue')
   }

   # Only returned for a single item
   if ($item.PSObject.Properties.Match('variables').count -gt 0 -and $null -ne $item.variables) {
      $item.variables.PSObject.TypeNames.Insert(0, 'Team.Variables')
   }

   if ($item.PSObject.Properties.Match('repository').count -gt 0 -and $null -ne $item.repository) {
      $item.repository.PSObject.TypeNames.Insert(0, 'Team.Repository')
   }
}

function Get-VSTeamBuildDefinition {
   [CmdletBinding(DefaultParameterSetName = 'List')]
   param(
      [Parameter(ParameterSetName = 'List')]
      [string] $Filter,
      
      [Parameter(ParameterSetName = 'List')]
      [ValidateSet('build', 'xaml', 'All')]
      [string] $Type = 'All',
      
      [Parameter(ParameterSetName = 'ByID', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [Alias('BuildDefinitionID')]
      [int[]] $Id,
      
      [Parameter(ParameterSetName = 'ByID')]
      [int] $Revision
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      if ($id) {
         foreach ($item in $id) {
            # Build the url to list the projects
            $listurl = _buildURL -projectName $projectName -id $item

            if ($revision) {
               $listurl += "&revision=$revision"
            }

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
         # Build the url
         $listurl = _buildURL -projectName $ProjectName

         if ($type -ne 'All') {
            $listurl += "&type=$type"
         }

         if ($filter) {
            $listurl += "&name=$filter"
         }

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

function Show-VSTeamBuildDefinition {
   [CmdletBinding(DefaultParameterSetName = 'List')]
   param(
      [Parameter(ParameterSetName = 'List')]
      [string] $Filter,
      
      [Parameter(ParameterSetName = 'List')]
      [ValidateSet('Mine', 'All', 'Queued', 'XAML')]
      [string] $Type = 'All',
      
      [Parameter(ParameterSetName = 'ByID', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [Alias('BuildDefinitionID')]
      [int[]] $Id,

      [Parameter(ParameterSetName = 'List')]
      [string] $Path = '\'
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      # Build the url
      $url = "$($env:TEAM_ACCT)/$ProjectName/_build"

      if ($id) {
         $url += "/index?definitionId=$id"
      }
      else {
         switch ($type) {
            'Mine' {
               $url += '/index?_a=mine&path='
            }
            'XAML' {
               $url += '/xaml&path='
            }
            'Queued' {
               $url += '/index?_a=queued&path='
            }
            Default {
               # All
               $url += '/index?_a=allDefinitions&path='
            }
         }

         # Make sure path starts with \
         if ($Path[0] -ne '\') {
            $Path = '\' + $Path
         }

         $url += [System.Web.HttpUtility]::UrlEncode($Path)
      }

      _showInBrowser $url
   }
}

function Add-VSTeamBuildDefinition {
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
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
      if (_useWindowsAuthenticationOnPremise) {
         $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Method Post -Uri $url -ContentType "application/json" -UseDefaultCredentials -InFile $inFile
      }
      else {
         $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Method Post -Uri $url -ContentType "application/json" -Headers @{Authorization = "Basic $env:TEAM_PAT"} -InFile $inFile
      }

      return $resp
   }
}

function Remove-VSTeamBuildDefinition {
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
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      foreach ($item in $id) {
         $listurl = _buildURL -projectName $ProjectName -id $item

         if ($Force -or $pscmdlet.ShouldProcess($item, "Delete Build Definition")) {
            # Call the REST API
            if (_useWindowsAuthenticationOnPremise) {
               $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Method Delete -Uri $listurl -UseDefaultCredentials
            }
            else {
               $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Method Delete -Uri $listurl -Headers @{Authorization = "Basic $env:TEAM_PAT"}
            }

            Write-Output "Deleted build defintion $item"
         }
      }
   }
}

Set-Alias Get-BuildDefinition Get-VSTeamBuildDefinition
Set-Alias Add-BuildDefinition Add-VSTeamBuildDefinition
Set-Alias Show-BuildDefinition Show-VSTeamBuildDefinition
Set-Alias Remove-BuildDefinition Remove-VSTeamBuildDefinition

Export-ModuleMember -Alias * -Function Show-VSTeamBuildDefinition, Get-VSTeamBuildDefinition, Add-VSTeamBuildDefinition, Remove-VSTeamBuildDefinition