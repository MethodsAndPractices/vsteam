function Remove-VSTeamClassificationNode {
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $false)]
      [int] $ReClassifyId,
    
      [ValidateSet("areas", "iterations")]
      [Parameter(Mandatory = $true)]
      [string] $StructureGroup,
     
      [Parameter(Mandatory = $false)]
      [string] $Path,

      [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
      [ProjectValidateAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      [string] $ProjectName
   )

   process {
      $id = $StructureGroup

      $Path = [uri]::UnescapeDataString($Path)

      if ($Path) {
         $Path = [uri]::EscapeUriString($Path)
         $Path = $Path.TrimStart("/")
         $id += "/$Path"
      }

      $queryString = @{}
      if ($ReClassifyId)
      {
         $queryString.Add("`$ReClassifyId", $ReClassifyId)
      }

      # Call the REST API
      $null = _callAPI -Method "Delete" -ProjectName $ProjectName -Area 'wit' -Resource "classificationnodes" -id $id `
         -ContentType 'application/json; charset=utf-8' `
         -QueryString $queryString `
         -Version $(_getApiVersion Core)
   }
}