Set-StrictMode -Version Latest

# Load common code
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\common.ps1"

function _buildURL {
   param(
      [parameter(Mandatory = $true)]
      [string] $ProjectName,
      [string] $Id,
      [string] $Name
   )

   _hasAccount

   $instance = $VSTeamVersionTable.Account
   $version = $VSTeamVersionTable.Core
   $resource = "/projects/$ProjectName/teams"

   if ($Id) {
      $resource += "/$Id"
   }
   elseif ($Name) {
      $resource += "/$Name"
   }

   # Build the url to list the projects
   return $instance + '/_apis' + $resource + '?api-version=' + $version
}

# Apply types to the returned objects so format and type files can
# identify the object and act on it.
function _applyTypes {
   param(
      [Parameter(Mandatory = $true)]
      $item,
      [Parameter(Mandatory = $true)]
      $ProjectName
   )

   # Add the ProjectName as a NoteProperty so we can use it further down the pipeline (it's not returned from the REST call)
   $item | Add-Member -MemberType NoteProperty -Name ProjectName -Value $ProjectName
   $item.PSObject.TypeNames.Insert(0, 'Team.Team')
}

function Get-VSTeam {
   [CmdletBinding(DefaultParameterSetName = 'List')]
   param (
      [Parameter(ParameterSetName = 'List')]
      [int] $Top,
 
      [Parameter(ParameterSetName = 'List')]
      [int] $Skip,
 
      [Parameter(ParameterSetName = 'ByID')]
      [Alias('TeamId')]
      [string[]] $Id,

      [Parameter(ParameterSetName = 'ByName')]
      [Alias('TeamName')]
      [string[]] $Name
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      if ($Id) {
         foreach ($item in $Id) {
            # Build the url to return the single build
            $listurl = _buildURL -projectName $ProjectName -Id $item

            # Call the REST API
            $resp = _get -url $listurl
            
            _applyTypes -item $resp -ProjectName $ProjectName

            Write-Output $resp
         }
      }
      elseif ($Name) {
         foreach ($item in $Name) {
            # Build the url to return the single build
            $listurl = _buildURL -projectName $ProjectName -Name $item

            # Call the REST API
            $resp = _get -url $listurl

            _applyTypes -item $resp -ProjectName $ProjectName

            Write-Output $resp
         }
      }
      else {
         # Build the url to list the teams
         $listurl = _buildURL -projectName $ProjectName
            
         $listurl += _appendQueryString -name "`$top" -value $top
         $listurl += _appendQueryString -name "`$skip" -value $skip

         # Call the REST API
         $resp = _get -url $listurl

         # Apply a Type Name so we can use custom format view and custom type extensions
         foreach ($item in $resp.value) {
            _applyTypes -item $item -ProjectName $ProjectName
         }

         Write-Output $resp.value
      }
   } 
}

function Add-VSTeam {
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

function Update-VSTeam {
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

      if ($Force -or $pscmdlet.ShouldProcess($Name, "Update-VSTeam")) {
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
         $resp = _callAPI -Method Patch -url $listurl -Body $body -ContentType 'application/json'
         
         _applyTypes -item $resp -ProjectName $ProjectName

         return $resp
      }
   }
}

function Remove-VSTeam {
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

Set-Alias Get-Team Get-VSTeam
Set-Alias Add-Team Add-VSTeam
Set-Alias Update-Team Update-VSTeam
Set-Alias Remove-Team Remove-VSTeam

Export-ModuleMember `
 -Function Get-VSTeam, Add-VSTeam, Update-VSTeam, Remove-VSTeam `
 -Alias Get-Team, Add-Team, Update-Team, Remove-Team