function Add-VSTeamClassificationNode {
   [CmdletBinding()]
   param(
      [CmdletBinding(DefaultParameterSetName = 'ByArea')]
      [CmdletBinding(DefaultParameterSetName = 'ByIteration')]
      [Parameter(Mandatory = $true)]
      [string] $Name,

      [CmdletBinding(DefaultParameterSetName = 'ByArea')]
      [CmdletBinding(DefaultParameterSetName = 'ByIteration')]      
      [ValidateSet("areas", "iterations")]
      [Parameter(Mandatory = $true)]
      [string] $StructureGroup,

      [CmdletBinding(DefaultParameterSetName = 'ByArea')]
      [CmdletBinding(DefaultParameterSetName = 'ByIteration')]      
      [Parameter(Mandatory = $false)]
      [string] $Path = $null,

      [CmdletBinding(DefaultParameterSetName = 'ByIteration')]      
      [Parameter(Mandatory = $false)]
      [datetime] $StartDate,

      [CmdletBinding(DefaultParameterSetName = 'ByIteration')]      
      [Parameter(Mandatory = $false)]
      [datetime] $FinishDate,
      
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

      $body = @{
         name = $Name
      }

      if($StructureGroup -eq "iterations"){
         $body.attributes = @{
            startDate = $StartDate
            finishDate = $FinishDate
          }
      }

      $bodyAsJson = $body | ConvertTo-Json

      # Call the REST API
      $resp = _callAPI -Method "Post" -ProjectName $ProjectName -Area 'wit' -Resource "classificationnodes" -id $id `
         -ContentType 'application/json; charset=utf-8' `
         -body $bodyAsJson `
         -Version $(_getApiVersion Core)
      
      $resp = [VSTeamClassificationNode]::new($resp, $ProjectName)

      Write-Output $resp
   }
}