function Remove-VSTeamIteration {
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $false)]
      [int] $ReClassifyId,
     
      [Parameter(Mandatory = $false)]
      [string] $Path,
      
      [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
      [ProjectValidateAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      [string] $ProjectName
   )

   process {
      $null = Remove-VSTeamClassificationNode -StructureGroup 'iterations' -ProjectName $ProjectName -Path $Path -ReClassifyId $ReClassifyId
   }
}