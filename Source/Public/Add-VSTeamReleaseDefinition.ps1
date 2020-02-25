function Add-VSTeamReleaseDefinition {
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $inFile
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   process {
      Write-Debug 'Add-VSTeamReleaseDefinition Process'

      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      $resp = _callAPI -Method Post -subDomain vsrm -Area release -Resource definitions -ProjectName $ProjectName `
         -Version $([VSTeamVersions]::Release) -inFile $inFile -ContentType 'application/json;charset=utf-8'

      Write-Output $resp
   }
}