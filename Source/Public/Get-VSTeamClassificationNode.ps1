function Get-VSTeamClassificationNode {
   [CmdletBinding(DefaultParameterSetName = 'ByIds')]
   param(
      [ValidateSet("areas", "iterations")]
      [Parameter(Mandatory = $true, ParameterSetName="ByPath")]
      [Parameter(Mandatory = $true, ParameterSetName="ByIds")]
      [string] $StructureGroup,

      [Parameter(Mandatory = $false, ParameterSetName="ByPath")]
      [string] $Path,

      [Parameter(Mandatory = $false, ParameterSetName="ByIds")]
      [int[]] $Ids,

      [Parameter(Mandatory = $false, ParameterSetName="ByPath")]
      [Parameter(Mandatory = $false, ParameterSetName="ByIds")]
      [int] $Depth
   )

   DynamicParam {
      _buildProjectNameDynamicParam -Mandatory $true
   }

   process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]
      $id = $StructureGroup

      if ($Path)
      {
         $id += "/$Path"
      }

      $queryString = @{}
      if ($Depth)
      {
         $queryString.Add("`$Depth", $Depth)
      }

      if ($Ids)
      {
         $queryString.Add("Ids", $Ids -join ",")
      }

      if ($queryString.Count -gt 0)
      {
         # Call the REST API
         $resp = _callAPI -ProjectName $ProjectName -Area 'wit' -Resource "classificationnodes" -id $id `
         -Version $([VSTeamVersions]::Core) `
         -QueryString $queryString
      } else {
         # Call the REST API
         $resp = _callAPI -ProjectName $ProjectName -Area 'wit' -Resource "classificationnodes" -id $id `
         -Version $([VSTeamVersions]::Core) `
      }

      Write-Verbose $resp | Select-Object -ExpandProperty value

      # Storing the object before you return it cleaned up the pipeline.
      # When I just write the object from the constructor each property
      # seemed to be written
      $classificationNode =[VSTeamClassificationNode]::new($resp, $ProjectName)

      Write-Output $classificationNode
   }
}