function Remove-VSTeamIteration {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
   param(
      [Parameter(Mandatory = $false)]
      [int] $ReClassifyId,
     
      [Parameter(Mandatory = $false)]
      [string] $Path,
      
      [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
      [ProjectValidateAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      [string] $ProjectName,

      [switch] $Force
   )

   process {
      if ($force -or $pscmdlet.ShouldProcess($Path, "Delete iteration")) {
         $null = Remove-VSTeamClassificationNode -StructureGroup 'iterations' -ProjectName $ProjectName -Path $Path -ReClassifyId $ReClassifyId -Force
      }
   }
}