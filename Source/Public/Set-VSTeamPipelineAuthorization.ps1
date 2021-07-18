function Set-VSTeamPipelineAuthorization {
   [CmdletBinding(DefaultParameterSetName = 'AuthorizeResource', SupportsShouldProcess = $true, ConfirmImpact = "Mediem",
      HelpUri = 'https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Set-VSTeamPipelineBilling')]
   param (
      [Parameter(ParameterSetName = 'AuthorizeResource', Mandatory = $true, ValueFromPipeline = $true, Position = 0)]
      [int[]] $PipelineIds,
      [Parameter(ParameterSetName = 'AuthorizeResource', Mandatory = $true)]
      [Parameter(ParameterSetName = 'AuthorizeAll', Mandatory = $true)]
      [string]
      $ResourceId,
      [Parameter(ParameterSetName = 'AuthorizeResource', Mandatory = $true)]
      [Parameter(ParameterSetName = 'AuthorizeAll', Mandatory = $true)]
      [string]
      [ValidateSet("Queue", "Endpoint", "Environment", "VariableGroup", "SecureFile", "Repository")]
      $ResourceType,
      [Parameter(ParameterSetName = 'AuthorizeResource', Mandatory = $true)]
      [bool]
      $Authorize,
      [Parameter(ParameterSetName = 'AuthorizeAll', Mandatory = $true)]
      [bool]
      $AuthorizeAll
   )

   process {
      $permPipeBody = @{
         # this part is actually disabling auto approval for pipelines (also future) to use this resource

         allPipelines = @{
            authorized = $AuthorizeAll
         }
         # this part is tragetting specific pipelines that are supposed to be authorized for the resource
         pipelines    = @( )
      }

      $permPipeBody.pipelines = $PipelineIds | ForEach-Object {
         @{
            id         = $_
            authorized = $Authorize
         }
      }

      $permPipeJsonBody = $permPipeBody | ConvertTo-Json -Compress -Depth 100

      if ($PSCmdlet.ShouldProcess("$ResourceType $ResourceId with Pipeline $PipelineId", $Authorized)) {

         $resp = _callAPI -Method PATCH -NoProject `
            -Area 'Pipelines'
            -Resource 'pipelinePermissions' `
            -Id "$ResourceType/$ResourceId" `
            -Body $permPipeJsonBody `
            -Version $(_getApiVersion Core)

            Write-Output $resp
      }
   }
}
