function Test-VSTeamYamlPipeline {
   [CmdletBinding(DefaultParameterSetName = 'WithFilePath',
      HelpUri = 'https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Test-VSTeamYamlPipeline')]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, Position = 1)]
      [Int32] $PipelineId,
      [Parameter(ParameterSetName = 'WithFilePath', Mandatory = $false)]
      [string] $FilePath,
      [Parameter(ParameterSetName = 'WithYamlOverride', Mandatory = $false)]
      [string] $YamlOverride,
      [Parameter(Mandatory = $false)]
      [string] $Branch
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

      if ($Branch) {
         # if full branch name is given then remove the first part

         $body.resources = @{
            pipelines    = $null
            repositories = @{
               self = @{
                  refName = ($Branch -replace 'refs/heads/', '')
               }
            }
            builds       = $null
            containers   = $null
            packages     = $null
         }
      }
      else {
         Write-Warning "No branch specified, Azure DevOps api is using 'ref/heads/main' always as default. Specify a branch name to prevent errors (for details see: https://developercommunity.visualstudio.com/t/API-to-preview-pipeline-run-takes-non-ex/1635377)."
      }

      try {
         # Call the REST API
         $resp = _callAPI -Method POST -ProjectName $ProjectName `
            -Area pipelines `
            -id "$PipelineId/runs" `
            -Body ($body | ConvertTo-Json -Compress -Depth 100) `
            -Version $(_getApiVersion Pipelines)
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
