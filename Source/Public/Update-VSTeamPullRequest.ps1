function Update-VSTeamPullRequest {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
   param(
      [Parameter(ParameterSetName = "Draft", ValueFromPipelineByPropertyName = $true, Mandatory = $true, Position = 0)]
      [Parameter(ParameterSetName = "Publish", ValueFromPipelineByPropertyName = $true, Mandatory = $true, Position = 0)]
      [Parameter(ParameterSetName = "Status", ValueFromPipelineByPropertyName = $true, Mandatory = $true, Position = 0)]
      [Parameter(ParameterSetName = "EnableAutoComplete", ValueFromPipelineByPropertyName = $true, Mandatory = $true, Position = 0)]
      [Parameter(ParameterSetName = "DisableAutoComplete", ValueFromPipelineByPropertyName = $true, Mandatory = $true, Position = 0)]
      [Alias('Id')]
      [Guid] $RepositoryId,
      [Parameter(ParameterSetName = "Draft", Mandatory = $true)]
      [Parameter(ParameterSetName = "Publish", Mandatory = $true)]
      [Parameter(ParameterSetName = "Status", Mandatory = $true)]
      [Parameter(ParameterSetName = "EnableAutoComplete", Mandatory = $true)]
      [Parameter(ParameterSetName = "DisableAutoComplete", Mandatory = $true)]
      [int] $PullRequestId,
      [Parameter(ParameterSetName = "Status", Mandatory = $true)]
      [ValidateSet("abandoned","active","completed","notSet")]
      [string] $Status,
      [Parameter(ParameterSetName = "EnableAutoComplete", Mandatory = $true)]
      [Switch] $EnableAutoComplete,
      [Parameter(ParameterSetName = "EnableAutoComplete", Mandatory = $true)]
      [VSTeamUser] $AutoCompleteIdentity,
      [Parameter(ParameterSetName = "DisableAutoComplete", Mandatory = $true)]
      [Switch] $DisableAutoComplete,
      [Parameter(ParameterSetName = "Draft", Mandatory = $true)]
      [switch] $Draft,
      [Parameter(ParameterSetName = "Publish", Mandatory = $true)]
      [switch] $Publish,
      [Parameter(ParameterSetName = "Draft")]
      [Parameter(ParameterSetName = "Publish")]
      [Parameter(ParameterSetName = "Status")]
      [Parameter(ParameterSetName = "EnableAutoComplete")]
      [Parameter(ParameterSetName = "DisableAutoComplete")]
      [switch] $Force
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      if ($Force -or $pscmdlet.ShouldProcess($PullRequestId, "Update Pull Request ID")) {
         if ($Draft.IsPresent)
         {
            $body = '{"isDraft": true }'
         }

         if ($Publish.IsPresent)
         {
            $body = '{"isDraft": false }'
         }

         if ($EnableAutoComplete.IsPresent)
         {
            $body = '{"autoCompleteSetBy": "' + $AutoCompleteIdentity.Descriptor + '"}'
         }

         if ($DisableAutoComplete.IsPresent)
         {
            $body = '{"autoCompleteSetBy": null}'
         }
               
         if ($Status)
         {
            $body = '{"status": "' + $Status + '"}'
         }

         # Call the REST API
         $resp = _callAPI -Area git -Resource repositories -iD "$RepositoryId/pullrequests/$PullRequestId" `
            -Method Patch -ContentType 'application/json' -body $body -Version $([VSTeamVersions]::Git)

         _applyTypesToPullRequests -item $resp
         Write-Output $resp
      }
   }
}