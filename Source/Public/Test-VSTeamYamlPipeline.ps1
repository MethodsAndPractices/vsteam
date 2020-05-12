function Test-VSTeamYamlPipeline {
   [CmdletBinding(DefaultParameterSetName = 'WithFilePath')]
   param(
      [Parameter(ParameterSetName = 'WithFilePath', Mandatory = $true, ValueFromPipelineByPropertyName = $true, Position = 1)]
      [Parameter(ParameterSetName = 'WithYamlOverride', Mandatory = $true, ValueFromPipelineByPropertyName = $true, Position = 1)]
      [Int32] $PipelineId,
      [Parameter(ParameterSetName = 'WithFilePath', Mandatory = $false)]
      [string] $FilePath,
      [Parameter(ParameterSetName = 'WithYamlOverride', Mandatory = $false)]
      [string] $YamlOverride
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
      elseif ($YamlOverride) {
         $body.YamlOverride = $YamlOverride
      }

      try {
         # Call the REST API
         $resp = _callAPI -ProjectName $ProjectName -Area 'pipelines' -Resource "$PipelineId" -id "runs" `
            -Method Post -ContentType 'application/json; charset=utf-8' -Body ($body | ConvertTo-Json) `
            -Version $(_getApiVersion Build)
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

      _applyTypesToYamlPipelineResultType -item $resp

      return $resp
   }
}
