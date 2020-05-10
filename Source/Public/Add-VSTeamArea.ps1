function Add-VSTeamArea {
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $true)]
      [string] $Name,

      [Parameter(Mandatory = $false)]
      [string] $Path,

      
      [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
      [ProjectValidateAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      [string] $ProjectName
   )

   process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      $resp = Add-VSTeamClassificationNode -Name $Name -StructureGroup "areas" -Path $Path -ProjectName $ProjectName

      $resp = [VSTeamClassificationNode]::new($resp, $ProjectName)

      Write-Output $resp
   }
}