function Remove-VSTeamArea {
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $false)]
      [int] $ReClassifyId,
     
      [Parameter(Mandatory = $false)]
      [string] $Path
   )

   DynamicParam {
      _buildProjectNameDynamicParam -Mandatory $true
   }

   process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      $null = Remove-VSTeamClassificationNode -StructureGroup 'areas' -ProjectName $ProjectName -Path $Path -ReClassifyId $ReClassifyId
   }
}