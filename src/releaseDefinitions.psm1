Set-StrictMode -Version Latest

# Load common code
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\common.ps1"

# Apply types to the returned objects so format and type files can
# identify the object and act on it.
function _applyTypesToReleaseDefinition {
   param($item)

   $item.PSObject.TypeNames.Insert(0, 'Team.ReleaseDefinition')

   $item._links.PSObject.TypeNames.Insert(0, 'Team.Links')
   $item._links.self.PSObject.TypeNames.Insert(0, 'Team.Link')
   $item._links.web.PSObject.TypeNames.Insert(0, 'Team.Link')
   $item.createdBy.PSObject.TypeNames.Insert(0, 'Team.User')
   $item.modifiedBy.PSObject.TypeNames.Insert(0, 'Team.User')

   # This is not always returned depends on expand flag
   if ($item.PSObject.Properties.Match('artifacts').count -gt 0 -and $null -ne $item.artifacts) {
      $item.artifacts.PSObject.TypeNames.Insert(0, 'Team.Artifacts')
   }

   if ($item.PSObject.Properties.Match('retentionPolicy').count -gt 0 -and $null -ne $item.retentionPolicy) {
      $item.retentionPolicy.PSObject.TypeNames.Insert(0, 'Team.RetentionPolicy')
   }

   if ($item.PSObject.Properties.Match('lastRelease').count -gt 0 -and $null -ne $item.lastRelease) {
      # This is VSTS
      $item.lastRelease.PSObject.TypeNames.Insert(0, 'Team.Release')
   }
}

function Get-VSTeamReleaseDefinition {
   [CmdletBinding(DefaultParameterSetName = 'List')]
   param(
      [Parameter(ParameterSetName = 'List')]
      [ValidateSet('environments', 'artifacts', 'none')]
      [string] $Expand = 'none',
      [Parameter(ParameterSetName = 'ByID', ValueFromPipelineByPropertyName = $true)]
      [Alias('ReleaseDefinitionID')]
      [int[]] $Id
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   process {
      Write-Debug 'Get-VSTeamReleaseDefinition Process'

      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      if ($id) {
         foreach ($item in $id) {
            $resp = _callAPI -subDomain vsrm -Area release -resource definitions -version $VSTeamVersionTable.Release -projectName $projectName -id $item

            # Apply a Type Name so we can use custom format view and custom type extensions
            _applyTypesToReleaseDefinition -item $resp

            Write-Output $resp
         }
      }
      else {
         $listurl = _buildRequestURI -subDomain vsrm -Area release -resource 'definitions' -version $VSTeamVersionTable.Release -projectName $ProjectName

         if ($expand -ne 'none') {
            $listurl += "&`$expand=$($expand)"
         }

         # Call the REST API
         $resp = _callAPI -url $listurl
         
         # Apply a Type Name so we can use custom format view and custom type extensions
         foreach ($item in $resp.value) {
            _applyTypesToReleaseDefinition -item $item
         }

         Write-Output $resp.value
      }
   }
}

function Show-VSTeamReleaseDefinition {
   [CmdletBinding()]
   param(
      [Parameter(ParameterSetName = 'ByID', ValueFromPipelineByPropertyName = $true)]
      [Alias('ReleaseDefinitionID')]
      [int] $Id
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   process {
      Write-Debug 'Show-VSTeamReleaseDefinition Process'

      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      # Build the url
      $url = "$($VSTeamVersionTable.Account)/$ProjectName/_release"
      
      if ($id) {
         $url += "?definitionId=$id"
      }
      
      Show-Browser $url
   }
}

function Add-VSTeamReleaseDefinition {
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $inFile
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   process {
      Write-Debug 'Add-VSTeamReleaseDefinition Process'

      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      $resp = _callAPI -Method Post -subDomain vsrm -Area release -Resource definitions -ProjectName $ProjectName `
         -version $VSTeamVersionTable.Release -inFile $inFile -ContentType 'application/json'

      Write-Output $resp
   }
}

function Remove-VSTeamReleaseDefinition {
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
      Write-Debug 'Remove-VSTeamReleaseDefinition Process'

      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      foreach ($item in $id) {
         if ($force -or $pscmdlet.ShouldProcess($item, "Delete Release Definition")) {
            _callAPI -Method Delete -subDomain vsrm -Area release -Resource definitions -Version $VSTeamVersionTable.Release -projectName $ProjectName -id $item  | Out-Null
            
            Write-Output "Deleted release defintion $item"
         }
      }
   }
}

Set-Alias Get-ReleaseDefinition Get-VSTeamReleaseDefinition
Set-Alias Show-ReleaseDefinition Show-VSTeamReleaseDefinition
Set-Alias Add-ReleaseDefinition Add-VSTeamReleaseDefinition
Set-Alias Remove-ReleaseDefinition Remove-VSTeamReleaseDefinition

Export-ModuleMember `
   -Function Get-VSTeamReleaseDefinition, Show-VSTeamReleaseDefinition, Add-VSTeamReleaseDefinition,
Remove-VSTeamReleaseDefinition `
   -Alias Get-ReleaseDefinition, Show-ReleaseDefinition, Add-ReleaseDefinition, Remove-ReleaseDefinition