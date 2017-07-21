Set-StrictMode -Version Latest

# Load common code
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\common.ps1"

# Apply types to the returned objects so format and type files can
# identify the object and act on it.
function _applyTypes {
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

function Get-ReleaseDefinition {
   [CmdletBinding(DefaultParameterSetName='List')]
   param(
      [Parameter(ParameterSetName='List')]
      [ValidateSet('environments','artifacts', 'none')]
      [string] $Expand = 'none',
      [Parameter(ParameterSetName='ByID', ValueFromPipelineByPropertyName=$true)]
      [Alias('ReleaseDefinitionID')]
      [int[]] $Id
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   process {
      Write-Debug 'Get-ReleaseDefinition Process'

      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      if($id) {
         foreach ($item in $id) {
            $listurl = _buildReleaseURL -resource 'definitions' -version '3.0-preview.1' -projectName $projectName -id $item

            # Call the REST API
            Write-Debug 'Get-ReleaseDefinition Call the REST API'
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
         $listurl = _buildReleaseURL -resource 'definitions' -version '3.0-preview.1' -projectName $ProjectName

         if ($expand -ne 'none') {
            $listurl += "&`$expand=$($expand)"
         }

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

function Add-ReleaseDefinition {
   [CmdletBinding()]
   param(
      [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
      [string] $inFile
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   process {
      Write-Debug 'Add-ReleaseDefinition Process'

      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      # Build the url
      $url = _buildReleaseURL -resource 'definitions' -version '3.0-preview.1' -projectName $projectName

      # Call the REST API
      Write-Debug 'Add-ReleaseDefinition Call the REST API'
	  if (_useWindowsAuthenticationOnPremise) {
        $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Method Post -Uri $url -ContentType "application/json" -UseDefaultCredentials -InFile $inFile
	  } else {
        $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Method Post -Uri $url -ContentType "application/json" -Headers @{Authorization = "Basic $env:TEAM_PAT"} -InFile $inFile
	  }

      Write-Output $resp
   }
}

function Remove-ReleaseDefinition {
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
      Write-Debug 'Remove-ReleaseDefinition Process'

      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      foreach ($item in $id) {
         $listurl = _buildReleaseURL -resource 'definitions' -version '3.0-preview.1' -projectName $ProjectName -id $item

         if ($force -or $pscmdlet.ShouldProcess($item, "Delete Release Definition")) {
            # Call the REST API
            Write-Debug 'Remove-ReleaseDefinition Call the REST API'
	        if (_useWindowsAuthenticationOnPremise) {
              $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Method Delete -Uri $listurl -UseDefaultCredentials
	        } else {
              $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Method Delete -Uri $listurl -Headers @{Authorization = "Basic $env:TEAM_PAT"}
	        }

            Write-Output "Deleted release defintion $item"
         }
      }
   }
}

Export-ModuleMember -Alias * -Function Get-ReleaseDefinition, Add-ReleaseDefinition, Remove-ReleaseDefinition