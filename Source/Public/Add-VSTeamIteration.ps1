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
      [datetime] $FinishDate
   )

   DynamicParam {
      _buildProjectNameDynamicParam -Mandatory $true
   }

   process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

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