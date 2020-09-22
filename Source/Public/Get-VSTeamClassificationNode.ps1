function Get-VSTeamClassificationNode {
   [CmdletBinding(DefaultParameterSetName = 'ById',
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Get-VSTeamClassificationNode')]
   param(
      [ValidateSet("areas", "iterations")]
      [Parameter(Mandatory = $true, ParameterSetName = "ByPath")]
      [string] $StructureGroup,

      [Parameter(Mandatory = $false, ParameterSetName = "ByPath")]
      [string] $Path,

      [Parameter(Mandatory = $true, ParameterSetName = "ById")]
      [int[]] $Id,

      [int] $Depth,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )

   process {
      $idArg = $StructureGroup

      $Path = [uri]::UnescapeDataString($Path)

      if ($Path) {
         $Path = [uri]::EscapeUriString($Path)
         $Path = $Path.TrimStart("/")
         $idArg += "/$Path"
      }

      $queryString = @{ }

      if ($Depth) {
         $queryString.Add("`$Depth", $Depth)
      }

      if ($Id) {
         $queryString.Add("ids", $Id -join ",")
      }

      $commonArgs = @{
         ProjectName = $ProjectName
         Area        = 'wit'
         Resource    = "classificationnodes"
         id          = $idArg
         Version     = $(_getApiVersion Core)
      }

      if ($queryString.Count -gt 0) {
         # Call the REST API
         $resp = _callAPI @commonArgs -QueryString $queryString
      }
      else {
         # Call the REST API
         $resp = _callAPI @commonArgs
      }

      if ([bool]($resp.PSobject.Properties.name -match "value")) {
         try {
            $objs = @()

            foreach ($item in $resp.value) {
               $objs += [vsteam_lib.ClassificationNode]::new($item, $ProjectName)
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
         $classificationNode = [vsteam_lib.ClassificationNode]::new($resp, $ProjectName)

         Write-Output $classificationNode
      }
   }
}