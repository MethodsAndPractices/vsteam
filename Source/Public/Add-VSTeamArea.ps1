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
      $resp = Add-VSTeamClassificationNode -Name $Name -StructureGroup "areas" -Path $Path -ProjectName $ProjectName

      Write-Output $resp
   }
}