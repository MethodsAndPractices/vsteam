function Add-VSTeamIteration {
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $true)]
      [string] $Name,
   
      [Parameter(Mandatory = $false)]
      [string] $Path,
  
      [Parameter(Mandatory = $false)]
      [datetime] $StartDate,

      [Parameter(Mandatory = $false)]
      [datetime] $FinishDate,
      
      [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
      [ProjectValidateAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      [string] $ProjectName
   )

   process {
      $params = @{}

      if($StartDate){
         $params.StartDate = $StartDate
      }

      if($FinishDate){
         $params.FinishDate = $FinishDate
      }

      $resp = Add-VSTeamClassificationNode -Name $Name -StructureGroup "iterations" -Path $Path -ProjectName $ProjectName @params

      $resp = [VSTeamClassificationNode]::new($resp, $ProjectName)

      Write-Output $resp
   }
}