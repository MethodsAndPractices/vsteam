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
            $resp = _callAPI -subDomain vsrm -Area release -resource definitions -Version $([VSTeamVersions]::Release) -projectName $projectName -id $item

            # Apply a Type Name so we can use custom format view and custom type extensions
            _applyTypesToReleaseDefinition -item $resp

            Write-Output $resp
         }
      }
      else {
         $listurl = _buildRequestURI -subDomain vsrm -Area release -resource 'definitions' -Version $([VSTeamVersions]::Release) -projectName $ProjectName

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