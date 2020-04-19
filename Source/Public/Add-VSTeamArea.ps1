function Add-VSTeamArea {
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $true)]
      [string] $Name,

      [Parameter(Mandatory = $false)]
      [string] $Path
   )

   DynamicParam {
      _buildProjectNameDynamicParam -Mandatory $true
   }

   process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      $resp = Add-VSTeamClassificationNode -Name $Name -StructureGroup "areas" -Path $Path -ProjectName $ProjectName

      $resp = [VSTeamClassificationNode]::new($resp, $ProjectName)

      Write-Output $resp
   }
}