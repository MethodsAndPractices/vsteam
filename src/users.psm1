Set-StrictMode -Version Latest

# Load common code
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\common.ps1"

function _buildURL {
   param(
      [string] $Id
   )

   _hasAccount

   if (-not $VSTeamVersionTable.MemberEntitlementManagement) {
      throw 'This account does not support Member Entitlement.'
   }

   $instance = _getEntitlementBase
   $version = $VSTeamVersionTable.MemberEntitlementManagement
   $resource = '/userentitlements'

   if ($Id) {
      $resource += "/$Id"
   }

   # Build the url to list the projects
   return $instance + '/_apis' + $resource + '?api-version=' + $version
}

# Apply types to the returned objects so format and type files can
# identify the object and act on it.
function _applyTypes {
   param(
      [Parameter(Mandatory = $true)]
      $item
   )

   $item.PSObject.TypeNames.Insert(0, 'Team.UserEntitlement')
   $item.accessLevel.PSObject.TypeNames.Insert(0, 'Team.AccessLevel')
}

function Get-VSTeamUser {
   [CmdletBinding(DefaultParameterSetName = 'List')]
   param (
      [Parameter(ParameterSetName = 'List')]
      [int] $Top = 100,
 
      [Parameter(ParameterSetName = 'List')]
      [int] $Skip = 0,

      [Parameter(ParameterSetName = 'List')]
      [ValidateSet('Projects', 'Extensions', 'Grouprules')]
      [string[]] $Select,
 
      [Parameter(ParameterSetName = 'ByID')]
      [Alias('TeamId')]
      [string[]] $Id
   )

   process {
      if ($Id) {
         foreach ($item in $Id) {
            # Build the url to return the single build
            $listurl = _buildURL -Id $item

            # Call the REST API
            $resp = _get -url $listurl
            
            _applyTypes -item $resp

            Write-Output $resp
         }
      }
      else {
         # Build the url to list the teams
         $listurl = _buildURL
            
         $listurl += _appendQueryString -name "top" -value $top -retainZero
         $listurl += _appendQueryString -name "skip" -value $skip -retainZero
         $listurl += _appendQueryString -name "select" -value ($select -join ",")

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

function Add-VSTeamUser {
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $true)]
      [Alias('TeamName')]     
      [string]$Name,
      [string]$Description = ""
   )
   DynamicParam {
      _buildProjectNameDynamicParam
   }

   process { 
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      $listurl = _buildURL -ProjectName $ProjectName
      $body = '{ "name": "' + $Name + '", "description": "' + $Description + '" }'

      # Call the REST API
      $resp = _post -url $listurl -Body $body

      _applyTypes -item $resp -ProjectName $ProjectName

      return $resp
   }
}

function Update-VSTeamUser {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium")]
   param(
      [Parameter(Mandatory = $True, ValueFromPipelineByPropertyName = $true)]
      [Alias('TeamName', 'TeamId', 'TeamToUpdate', 'Id')]
      [string]$Name,
      [string]$NewTeamName,
      [string]$Description,
      [switch] $Force
   )
   DynamicParam {
      _buildProjectNameDynamicParam
   }

   process { 
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      $listurl = _buildURL -ProjectName $ProjectName -Id $Name
      if (-not $NewTeamName -and -not $Description) {
         throw 'You must provide a new team name or description, or both.'
      }

      if ($Force -or $pscmdlet.ShouldProcess($Name, "Update-VSTeamUser")) {
         if (-not $NewTeamName) { 
            $body = '{"description": "' + $Description + '" }'
         }
         if (-not $Description) {
            $body = '{ "name": "' + $NewTeamName + '" }'
         }
         if ($NewTeamName -and $Description) {
            $body = '{ "name": "' + $NewTeamName + '", "description": "' + $Description + '" }'            
         }

         # Call the REST API
         $resp = _patch -url $listurl -Body $body
         
         _applyTypes -item $resp -ProjectName $ProjectName

         return $resp
      }
   }
}

function Remove-VSTeamUser {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
   param(
      [Parameter(Mandatory = $True, ValueFromPipelineByPropertyName = $true)]
      [Alias('Name', 'TeamId', 'TeamName')]
      [string]$Id,

      [switch]$Force
   )
   DynamicParam {
      _buildProjectNameDynamicParam
   }

   process { 
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      $listurl = _buildURL -ProjectName $ProjectName -Id $Id

      if ($Force -or $PSCmdlet.ShouldProcess($Id, "Delete team")) {
         # Call the REST API
         _delete -url $listurl

         Write-Output "Deleted team $Id"
      }
   }
}

Set-Alias Get-User Get-VSTeamUser
Set-Alias Add-User Add-VSTeamUser
Set-Alias Update-User Update-VSTeamUser
Set-Alias Remove-User Remove-VSTeamUser

Export-ModuleMember `
 -Function Get-VSTeamUser, Add-VSTeamUser, Update-VSTeamUser, Remove-VSTeamUser `
 -Alias Get-User, Add-User, Update-User, Remove-User