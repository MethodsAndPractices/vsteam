Set-StrictMode -Version Latest

# Load common code
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\common.ps1"

# Apply types to the returned objects so format and type files can
# identify the object and act on it.
function _applyTypesToGitRepository {
   param($item)

   $item.PSObject.TypeNames.Insert(0, 'Team.GitRepository')
}

function Remove-VSTeamGitRepository {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
   param(
      [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
      [guid[]] $Id,
      [switch] $Force
   )

   Process {
      foreach ($item in $id) {
         if ($Force -or $pscmdlet.ShouldProcess($item, "Delete Repository")) {
            try {
               _callAPI -Method Delete -Id $item -Area git -Resource repositories -Version $VSTeamVersionTable.Git | Out-Null
               
               Write-Output "Deleted repository $item"
            }
            catch {
               _handleException $_
            }
         }
      }
   }
}

function Add-VSTeamGitRepository {
   [CmdletBinding()]
   param(
      [parameter(Mandatory = $true)]
      [string] $Name
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   process {
      $ProjectName = $PSBoundParameters["ProjectName"]

      $body = '{"name": "' + $Name + '"}'

      try {
         # Call the REST API
         $resp = _callAPI -ProjectName $ProjectName -Area 'git' -Resource 'repositories' `
            -Method Post -ContentType 'application/json' -Body $body -Version $VSTeamVersionTable.Git

         Write-Output $resp
      }
      catch {
         _handleException $_
      }
   }
}

function Get-VSTeamGitRepository {
   [CmdletBinding(DefaultParameterSetName = 'ByID')]
   param (
      [Parameter(ParameterSetName = 'ByID', ValueFromPipeline = $true)]
      [Alias('RepositoryID')]
      [guid[]] $Id,

      [Parameter(ParameterSetName = 'ByName', ValueFromPipeline = $true)]
      [string[]] $Name
   )

   DynamicParam {
      _buildProjectNameDynamicParam -mandatory $false
   }

   process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      if ($id) {
         foreach ($item in $id) {
            try {
               $resp = _callAPI -ProjectName $ProjectName -Id $item -Area git -Resource repositories -Version $VSTeamVersionTable.Git
               
               _applyTypesToGitRepository -item $resp
               
               Write-Output $resp   
            }
            catch {
               throw $_
            }            
         }
      }
      elseif ($Name) {
         foreach ($item in $Name) {
            try {
               $resp = _callAPI -ProjectName $ProjectName -Id $item -Area git -Resource repositories -Version $VSTeamVersionTable.Git

               _applyTypesToGitRepository -item $resp

               Write-Output $resp
            }
            catch {
               throw $_
            }    
         }
      }
      else {
         try {
            $resp = _callAPI -ProjectName $ProjectName -Area git -Resource repositories -Version $VSTeamVersionTable.Git

            # Apply a Type Name so we can use custom format view and custom type extensions
            foreach ($item in $resp.value) {
               _applyTypesToGitRepository -item $item
            }

            Write-Output $resp.value
         }
         catch {
            throw $_
         }    
      }
   }
}

function Show-VSTeamGitRepository {
   [CmdletBinding()]
   param (
      [Parameter(ValueFromPipelineByPropertyName = $true)]
      [string] $RemoteUrl
   )

   DynamicParam {
      _buildProjectNameDynamicParam -mandatory $false
   }

   process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      if ($RemoteUrl) {
         _showInBrowser $RemoteUrl
      }
      else {
         _showInBrowser "$($VSTeamVersionTable.Account)/_git/$ProjectName"
      }
   }
}

Set-Alias Get-GitRepository Get-VSTeamGitRepository
Set-Alias Show-GitRepository Show-VSTeamGitRepository
Set-Alias Add-GitRepository Add-VSTeamGitRepository
Set-Alias Remove-GitRepository Remove-VSTeamGitRepository

Export-ModuleMember `
   -Function Get-VSTeamGitRepository, Show-VSTeamGitRepository, Add-VSTeamGitRepository, Remove-VSTeamGitRepository `
   -Alias Get-GitRepository, Show-GitRepository, Add-GitRepository, Remove-GitRepository