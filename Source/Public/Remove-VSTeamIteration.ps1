function Remove-VSTeamIteration {
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

      $null = Remove-VSTeamClassificationNode -StructureGroup 'iterations' -ProjectName $ProjectName -Path $Path -ReClassifyId $ReClassifyId
   }
}