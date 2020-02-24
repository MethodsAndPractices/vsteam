function Get-VSTeamGitStats {
   [CmdletBinding(DefaultParameterSetName = "ByOptionalName")]
   param (
      [Parameter(ParameterSetName = "ByVersion", ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
      [Parameter(ParameterSetName = "ByOptionalName", ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
      [Alias('Id')]
      [guid] $RepositoryId,

      [Parameter(ParameterSetName = 'ByVersion', Mandatory = $false)]
      [Parameter(ParameterSetName = 'ByOptionalName', Mandatory = $false)]
      [string] $BranchName,

      [ValidateSet("firstParent", "none", "previousChange")]
      [Parameter(ParameterSetName = 'ByVersion', Mandatory = $false)]
      [string] $VersionOptions,

      [Parameter(ParameterSetName = 'ByVersion', Mandatory = $true)]
      [string] $Version,

      [Parameter(ParameterSetName = 'ByVersion', Mandatory = $true)]
      [ValidateSet("branch", "commit", "tag")]
      [string] $VersionType
   )

   DynamicParam {
      _buildProjectNameDynamicParam -Mandatory $true
   }

   process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      if (($VersionType -eq "commit") -and ($Version -eq $null -or $Version -eq ''))
      {
         throw "If you have a -VersionType of 'commit' you need to set a commit id as -Version";
      }

      try {
         $queryString = @{
            'name'                                 = $BranchName
            'baseVersionDescriptor.versionType'    = $VersionType
            'baseVersionDescriptor.version'        = $Version
            'baseVersionDescriptor.versionOptions' = $VersionOptions
         }

         $resp = _callAPI -ProjectName $ProjectName -Id "$RepositoryID/stats/branches" -Area git -Resource repositories -Version $([VSTeamVersions]::Git) -QueryString $queryString

         $hasValueProp = $resp.PSObject.Properties.Match('value')

         if (0 -eq $hasValueProp.count) {
            _applyTypes $resp "VSTeam.GitStats"
            Write-Output $resp
         } else {
            $obj = @()
            foreach ($item in $resp.value) {
               _applyTypes $item "VSTeam.GitStats"
               $obj += $item
            }

            Write-Output $obj
         }
      }
      catch {
         throw $_
      }
   }
}