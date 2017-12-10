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
      [Alias('UserId')]
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
      [Alias('UserEmail')]     
      [string]$Email,
      [ValidateSet('Advanced', 'EarlyAdopter', 'Express', 'None', 'Professional', 'StakeHolder')]
      [string]$License = 'EarlyAdopter',
      [ValidateSet('Custom', 'ProjectAdministrator', 'ProjectContributor', 'ProjectReader', 'ProjectStakeholder')]
      [string]$Group = 'ProjectContributor'
   )
   
   DynamicParam {
      _buildProjectNameDynamicParam -Mandatory $false
   }

   process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      $listurl = _buildURL -ProjectName $ProjectName
      $obj = @{
         accessLevel = @{
            accountLicenseType = $License
         }
         user = @{
            principalName = $email
            subjectKind = 'user'
         }
         projectEntitlements = @{
            group = @{
               groupType = $Group
            }
            projectRef = @{
               id = $ProjectName
            }
         }
      }

      $body = $obj | ConvertTo-Json

      # Call the REST API
      _post -url $listurl -Body $body
   }
}

function Remove-VSTeamUser {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High", DefaultParameterSetName = 'ById')]
   param(
      [Parameter(ParameterSetName = 'ById', Mandatory = $True, ValueFromPipelineByPropertyName = $true)]
      [Alias('UserId')]
      [string]$Id,

      [Parameter(ParameterSetName = 'ByEmail', Mandatory = $True, ValueFromPipelineByPropertyName = $true)]
      [Alias('UserEmail')]
     [string]$Email,

      [switch]$Force
   )

   process { 
      if ($email) {
         # We have to go find the id
         $user = Get-VSTeamUser | ? email -eq $email

         if(-not $user) {
            throw "Could not find user with an email equal to $email"
         }

         $id = $user.id
      }

      $listurl = _buildURL -Id $Id

      if ($Force -or $PSCmdlet.ShouldProcess($Id, "Delete user")) {
         # Call the REST API
         _delete -url $listurl

         Write-Output "Deleted user $Id"
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