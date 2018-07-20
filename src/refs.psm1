Set-StrictMode -Version Latest

# Load common code
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\common.ps1"

function Get-VSTeamGitRef {
   [CmdletBinding()]
   param (
      [Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
      [Alias('Id')]
      [guid] $RepositoryID
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      try {
         $resp = _callAPI -ProjectName $ProjectName -Id "$RepositoryID/refs" -Area git -Resource repositories -Version $VSTeamVersionTable.Git

         $obj = @()

         foreach ($item in $resp.value) {
            $obj += [VSTeamRef]::new($item, $ProjectName)
         }

         Write-Output $obj
      }
      catch {
         throw $_
      }
   }
}

Set-Alias Get-GitRef Get-VSTeamGitRef

Export-ModuleMember `
   -Function Get-VSTeamGitRef `
   -Alias Get-GitRef