function Add-VSTeamBuildDefinition {
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $InFile
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      $resp = _callAPI -Method Post -ProjectName $ProjectName -Area build -Resource definitions -Version $([VSTeamVersions]::Build) -infile $InFile -ContentType 'application/json;charset=utf-8'

      return $resp
   }
}