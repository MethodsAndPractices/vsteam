function Add-VSTeamIteration {
   [CmdletBinding()]
   param(
      [CmdletBinding(DefaultParameterSetName = 'ByIteration')]
      [Parameter(Mandatory = $true)]
      [string] $Name,

      [CmdletBinding(DefaultParameterSetName = 'ByIteration')]      
      [Parameter(Mandatory = $false)]
      [string] $Path,

      [CmdletBinding(DefaultParameterSetName = 'ByIteration')]      
      [Parameter(Mandatory = $false)]
      [datetime] $StartDate,

      [CmdletBinding(DefaultParameterSetName = 'ByIteration')]      
      [Parameter(Mandatory = $false)]
      [datetime] $FinishDate
   )

   DynamicParam {
      _buildProjectNameDynamicParam -Mandatory $true
   }

   process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      $resp = Add-VSTeamClassificationNode -Name $Name -StructureGroup "iteration" -Path $Path -ProjectName $ProjectName -StartDate $StartDate -FinishDate $FinishDate

      $resp = [VSTeamClassificationNode]::new($resp, $ProjectName)

      Write-Output $resp
   }
}