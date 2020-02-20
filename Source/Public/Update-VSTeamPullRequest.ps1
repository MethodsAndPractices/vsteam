function Update-VSTeamPullRequest {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
   param(
      [Parameter(ParameterSetName = "Draft", ValueFromPipelineByPropertyName = $true, Mandatory = $true, Position = 0)]
      [Parameter(ParameterSetName = "Publish", ValueFromPipelineByPropertyName = $true, Mandatory = $true, Position = 0)]
      [Parameter(ParameterSetName = "Status", ValueFromPipelineByPropertyName = $true, Mandatory = $true, Position = 0)]
      [Parameter(ParameterSetName = "AutoComplete", ValueFromPipelineByPropertyName = $true, Mandatory = $true, Position = 0)]
      [Alias('Id')]
      [Guid] $RepositoryId,
      [Parameter(ParameterSetName = "Draft", Mandatory = $true)]
      [Parameter(ParameterSetName = "Publish", Mandatory = $true)]
      [Parameter(ParameterSetName = "Status", Mandatory = $true)]
      [Parameter(ParameterSetName = "AutoComplete", Mandatory = $true)]
      [int] $PullRequestId,
      [Parameter(ParameterSetName = "Status", Mandatory = $true)]
      [ValidateSet("abandoned","active","completed","notSet")]
      [string] $Status,
      [Parameter(ParameterSetName = "AutoComplete", Mandatory = $true)]
      [Nullable[bool]] $AutoComplete,
      [Parameter(ParameterSetName = "AutoComplete")]
      [VSTeamDescriptor] $AutoCompleteIdentity,
      [Parameter(ParameterSetName = "Draft", Mandatory = $true)]
      [switch] $Draft,
      [Parameter(ParameterSetName = "Publish", Mandatory = $true)]
      [switch] $Publish,
      [Parameter(ParameterSetName = "Draft")]
      [Parameter(ParameterSetName = "Publish")]
      [Parameter(ParameterSetName = "Status")]
      [Parameter(ParameterSetName = "AutoComplete")]
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
            $msg = "Setting Pull Request to Draft"
            $body = '{"isDraft": true }'
         }

         if ($Publish.IsPresent)
         {
            $msg = "Setting Pull Request to Published"
            $body = '{"isDraft": false }'
         }

         if(-not [string]::IsNullOrEmpty($AutoComplete) )
         {
            if ($AutoComplete -eq $true)
            {
               if (!$AutoCompleteIdentity -or $AutoCompleteIdentity.Descriptor -eq $null)
               {
                  throw "-AutoCompleteIdentity needs to be set when enabling AutoComplete"
               }
            }

            $msg = "Setting AutoComplete to $AutoComplete"
            $body = '{"autoCompleteSetBy": "' + $AutoCompleteIdentity.Descriptor + '"}'
         }

         if ($Status)
         {
            $msg  = "Setting Status to $Status"
            $body = '{"status": "' + $Status + '"}'
         }

         # Call the REST API
         $resp = _callAPI -Area git -Resource repositories -iD "$RepositoryId/pullrequests/$PullRequestId" `
            -Method Patch -ContentType 'application/json;charset=utf-8' -body $body -Version $([VSTeamVersions]::Git)

         #_trackProjectProgress -resp $resp -title 'Updating pull request' -msg $msg

         _applyTypesToPullRequests -item $resp
         Write-Output $resp
      }
   }
}