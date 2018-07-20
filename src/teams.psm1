Set-StrictMode -Version Latest

# Load common code
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\common.ps1"

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
            # Call the REST API
            $resp = _callAPI -Area 'projects' -Resource "$ProjectName/teams" -id $item `
               -Version $VSTeamVersionTable.Core

            $team = [VSTeamTeam]::new($resp, $ProjectName)

            Write-Output $team
         }
      }
      elseif ($Name) {
         foreach ($item in $Name) {
            # Call the REST API
            $resp = _callAPI -Area 'projects' -Resource "$ProjectName/teams" -id $item `
               -Version $VSTeamVersionTable.Core

            $team = [VSTeamTeam]::new($resp, $ProjectName)

            Write-Output $team
         }
      }
      else {
         # Call the REST API
         $resp = _callAPI -Area 'projects' -Resource "$ProjectName/teams" `
            -Version $VSTeamVersionTable.Core `
            -QueryString @{
            '$top'  = $top
            '$skip' = $skip
         }

         $obj = @()

         # Create an instance for each one
         foreach ($item in $resp.value) {
            $obj += [VSTeamTeam]::new($item, $ProjectName)
         }

         Write-Output $obj
      }
   }
}

function Add-VSTeam {
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $true, Position = 1)]
      [Alias('TeamName')]
      [string]$Name,

      [string]$Description = ''
   )
   DynamicParam {
      _buildProjectNameDynamicParam
   }

   process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      $body = '{ "name": "' + $Name + '", "description": "' + $Description + '" }'

      # Call the REST API
      $resp = _callAPI -Area 'projects' -Resource "$ProjectName/teams" `
         -Method Post -ContentType 'application/json' -Body $body -Version $VSTeamVersionTable.Core

      $team = [VSTeamTeam]::new($resp, $ProjectName)

      Write-Output $team
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
         $resp = _callAPI -Area 'projects' -Resource "$ProjectName/teams" -Id $Name `
            -Method Patch -ContentType 'application/json' -Body $body -Version $VSTeamVersionTable.Core

         # Storing the object before you return it cleaned up the pipeline.
         # When I just write the object from the constructor each property
         # seemed to be written
         $team = [VSTeamTeam]::new($resp, $ProjectName)

         Write-Output $team
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

      if ($Force -or $PSCmdlet.ShouldProcess($Id, "Delete team")) {
         # Call the REST API
         _callAPI -Area 'projects' -Resource "$ProjectName/teams" -Id $Id `
            -Method Delete -Version $VSTeamVersionTable.Core | Out-Null

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