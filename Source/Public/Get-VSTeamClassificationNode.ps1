function Get-VSTeamClassificationNode {
   [CmdletBinding(DefaultParameterSetName = 'ByIds')]
   param(
      [ValidateSet("areas", "iterations")]
      [Parameter(Mandatory = $true, ParameterSetName = "ByPath")]
      [string] $StructureGroup,

      [Parameter(Mandatory = $false, ParameterSetName = "ByPath")]
      [string] $Path,

      [Parameter(Mandatory = $false, ParameterSetName = "ByIds")]
      [int[]] $Ids,

      [Parameter(Mandatory = $false, ParameterSetName = "ByPath")]
      [Parameter(Mandatory = $false, ParameterSetName = "ByIds")]
      [int] $Depth,

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

      $queryString = @{ }
      
      if ($Depth) {
         $queryString.Add("`$Depth", $Depth)
      }

      if ($Ids) {
         $queryString.Add("Ids", $Ids -join ",")
      }

      if ($queryString.Count -gt 0) {
         # Call the REST API
         $resp = _callAPI -Method "Get" -ProjectName $ProjectName -Area 'wit' -Resource "classificationnodes" -id $id `
            -Version $(_getApiVersion Core) `
            -QueryString $queryString
      }
      else {
         # Call the REST API
         $resp = _callAPI -Method "Get" -ProjectName $ProjectName -Area 'wit' -Resource "classificationnodes" -id $id `
            -Version $(_getApiVersion Core) `
      
      }

      if ([bool]($resp.PSobject.Properties.name -match "value")) {
         try {
            $objs = @()
   
            foreach ($item in $resp.value) {
               $objs += [VSTeamClassificationNode]::new($item, $ProjectName)
            }
   
            Write-Output $objs
         }
         catch {
            # I catch because using -ErrorAction Stop on the Invoke-RestMethod
            # was still running the foreach after and reporting useless errors.
            # This casuses the first error to terminate this execution.
            _handleException $_
         }
      }
      else {
         # Storing the object before you return it cleaned up the pipeline.
         # When I just write the object from the constructor each property
         # seemed to be written
         $classificationNode = [VSTeamClassificationNode]::new($resp, $ProjectName)

         Write-Output $classificationNode
      }
   }
}