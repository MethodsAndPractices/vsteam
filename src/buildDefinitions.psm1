Set-StrictMode -Version Latest

# Load common code
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\common.ps1"

# Apply types to the returned objects so format and type files can
# identify the object and act on it.
function _applyTypesToBuildDefinition {
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

   if ($item.PSObject.Properties.Match('process').count -gt 0 -and $null -ne $item.process) {
      $item.process.PSObject.TypeNames.Insert(0, 'Team.Process')
      if ($item.process.PSObject.Properties.Match('phases').count -gt 0 -and $null -ne $item.process.phases) {
         foreach($phase in $item.process.phases) {
            $phase.PSObject.TypeNames.Insert(0, 'Team.Phase')
         }
      }
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
            $resp = _callAPI -ProjectName $ProjectName -Id $item -Area build -Resource definitions -Version $VSTeamVersionTable.Build `
               -QueryString @{revision = $revision}
            
            _applyTypesToBuildDefinition -item $resp

            Write-Output $resp
         }
      }
      else {
         $resp = _callAPI -ProjectName $ProjectName -Area build -Resource definitions -Version $VSTeamVersionTable.Build `
            -QueryString @{type = $type; name = $filter}
         
         # Apply a Type Name so we can use custom format view and custom type extensions
         foreach ($item in $resp.value) {
            _applyTypesToBuildDefinition -item $item
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
      $url = "$($VSTeamVersionTable.Account)/$ProjectName/_build"

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

      $resp = _callAPI -Method Post -ProjectName $ProjectName -Area build -Resource definitions -Version $VSTeamVersionTable.Build -infile $InFile -ContentType 'application/json'

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
         if ($Force -or $pscmdlet.ShouldProcess($item, "Delete Build Definition")) {
            # Call the REST API
            _callAPI -Method Delete -ProjectName $ProjectName -Area build -Resource definitions -Id $item -Version $VSTeamVersionTable.Build | Out-Null

            Write-Output "Deleted build defintion $item"
         }
      }
   }
}

function Update-VSTeamBuildDefinition {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium")]
   Param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [int] $Id,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $InFile,

      # Forces the command without confirmation
      [switch] $Force
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   Process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      if ($Force -or $pscmdlet.ShouldProcess($Id, "Update Build Definition")) {
         # Call the REST API
         _callAPI -Method Put -ProjectName $ProjectName -Area build -Resource definitions -Id $Id -Version $VSTeamVersionTable.Build -InFile $InFile -ContentType 'application/json' | Out-Null
      }
   }
}

Set-Alias Get-BuildDefinition Get-VSTeamBuildDefinition
Set-Alias Add-BuildDefinition Add-VSTeamBuildDefinition
Set-Alias Show-BuildDefinition Show-VSTeamBuildDefinition
Set-Alias Remove-BuildDefinition Remove-VSTeamBuildDefinition
Set-Alias Update-BuildDefinition Update-VSTeamBuildDefinition

Export-ModuleMember `
   -Function Show-VSTeamBuildDefinition, Get-VSTeamBuildDefinition, Add-VSTeamBuildDefinition,
Remove-VSTeamBuildDefinition, Update-VSTeamBuildDefinition `
   -Alias Get-BuildDefinition, Add-BuildDefinition, Show-BuildDefinition, Remove-BuildDefinition, 
Update-BuildDefinition