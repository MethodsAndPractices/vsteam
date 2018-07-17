Set-StrictMode -Version Latest

# Load common code
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\common.ps1"

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

         # Storing the object before you return it cleaned up the pipeline.
         # When I just write the object from the constructor each property
         # seemed to be written
         $repo = [VSTeamRepository]::new($resp, $ProjectName)

         Write-Output $repo
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

               # Storing the object before you return it cleaned up the pipeline.
               # When I just write the object from the constructor each property
               # seemed to be written
               $item = [VSTeamRepository]::new($resp, $ProjectName)

               Write-Output $item
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

               # Storing the object before you return it cleaned up the pipeline.
               # When I just write the object from the constructor each property
               # seemed to be written
               $item = [VSTeamRepository]::new($resp, $ProjectName)

               Write-Output $item
            }
            catch {
               throw $_
            }
         }
      }
      else {
         try {
            $resp = _callAPI -ProjectName $ProjectName -Area git -Resource repositories -Version $VSTeamVersionTable.Git

            $objs = @()

            foreach ($item in $resp.value) {
               $objs += [VSTeamRepository]::new($item, $ProjectName)
            }

            Write-Output $objs
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