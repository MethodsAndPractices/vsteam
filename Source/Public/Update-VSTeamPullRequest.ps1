function Update-VSTeamPullRequest {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High", DefaultParameterSetName = 'Draft')]
   param(
      [Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true, Position = 0)]
      [Alias('Id')]
      [Guid] $RepositoryId,

      [Parameter(Mandatory = $true)]
      [int] $PullRequestId,

      [Parameter(ParameterSetName = "Status", Mandatory = $true)]
      [ValidateSet("abandoned", "active", "completed", "notSet")]
      [string] $Status,

      [Parameter(ParameterSetName = "EnableAutoComplete", Mandatory = $true)]
      [Switch] $EnableAutoComplete,

      [Parameter(ParameterSetName = "EnableAutoComplete", Mandatory = $true)]
      [VSTeamUser] $AutoCompleteIdentity,

      [Parameter(ParameterSetName = "DisableAutoComplete", Mandatory = $true)]
      [Switch] $DisableAutoComplete,

      [Parameter(ParameterSetName = "Draft", Mandatory = $false)]
      [switch] $Draft,

      [switch] $Force
   )

   process {
      if ($Force -or $pscmdlet.ShouldProcess($PullRequestId, "Update Pull Request ID")) {
         if ($Draft.IsPresent) {
            $body = '{"isDraft": true }'
         }
         else {
            $body = '{"isDraft": false }'
         }

         if ($EnableAutoComplete.IsPresent) {
            $body = '{"autoCompleteSetBy": "' + $AutoCompleteIdentity.Descriptor + '"}'
         }

         if ($DisableAutoComplete.IsPresent) {
            $body = '{"autoCompleteSetBy": null}'
         }

         if ($Status) {
            $body = '{"status": "' + $Status + '"}'
         }

         # Call the REST API
         $resp = _callAPI -Area git -Resource repositories -iD "$RepositoryId/pullrequests/$PullRequestId" `
            -Method Patch -ContentType 'application/json' -body $body -Version $(_getApiVersion Git)

         _applyTypesToPullRequests -item $resp

         Write-Output $resp
      }
   }
}