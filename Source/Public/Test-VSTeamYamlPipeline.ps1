function Test-VSTeamYamlPipeline {   
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [Int32] $PipelineId,
      [Parameter(Mandatory = $false)]
      [string] $FilePath
   )
   DynamicParam {
      _buildProjectNameDynamicParam
   }

   process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      $body = @{
         PreviewRun = $true         
      }

      if ($FilePath) {
         $body.YamlOverride = [string](Get-Content -raw $FilePath)
      }

      try {
         # Call the REST API
         $resp = _callAPI -ProjectName $ProjectName -Area 'pipelines' -Resource "$PipelineId" -id "runs" `
            -Method Post -ContentType 'application/json' -Body ($body | ConvertTo-Json) `
            -Version $([VSTeamVersions]::Build)
      }
      catch {
         if ($PSItem -match 'PipelineValidationException') {
            Write-Error (($PSItem | ConvertFrom-Json).message -replace '/azure-pipelines.yml( ?: ?)? ?', '')
            return
         }
         else {
            throw
         }
      }
      
      return $resp
   }
}