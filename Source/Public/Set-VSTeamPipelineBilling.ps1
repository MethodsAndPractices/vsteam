function Set-VSTeamPipelineBilling {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High",
      HelpUri = 'https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Set-VSTeamPipelineBilling')]
   param(
      [Parameter(Mandatory = $true)]
      [ValidateSet('HostedPipeline', 'PrivatePipeline')]
      [string] $Type,
      [Parameter(Mandatory = $false)]
      [string] $OrganizationId,
      [Parameter(Mandatory = $true)]
      [ValidateRange(0,200)]
      [int] $Quantity,
      [switch] $Force
   )

   process {

      if ($force -or $pscmdlet.ShouldProcess($Quantity, "Quantity")) {

         $billingToken = _getBillingToken -NamedTokenId 'AzCommDeploymentProfile'

         if ([string]::IsNullOrEmpty($OrganizationId)) {
            $userProfile = Get-VSTeamUserProfile -MyProfile
            $currentOrg = Get-VSTeamAccounts -MemberId  $userProfile.id | Where-Object {
               $instanceUrl = _getInstance
               return $instanceUrl.EndsWith($_.accountName)
            }

            $OrganizationId = $currentOrg.accountId
         }

         $body = @{ }

         if ($Type -eq "HostedPipeline") {
            $body = @{
               meterId = "4bad9897-8d87-43bb-80be-5e6e8fefa3de"
               purchaseQuantity   = $Quantity
            }
         }

         if ($Type -eq "PrivatePipeline") {
            $body = @{
               meterId = "f44a67f2-53ae-4044-bd58-1c8aca386b98"
               #internally the minimum is one. One concurrent private job is always there (for free).
               #strangely this is not handled by the backend internally. Buying one means zero paid private jobs.
               purchaseQuantity   = $Quantity + 1
            }
         }

         Write-Verbose $body

         try {
            # Call the REST API
            #Full URL needs to be used, since the organization ID is accepted only
            _callAPI `
               -NoProject `
               -Method PATCH `
               -Url "https://azdevopscommerce.dev.azure.com/$OrganizationId/_apis/AzComm/MeterResource?api-version=5.1-preview.1" `
               -body ($body | ConvertTo-Json -Depth 50 -Compress) `
               -AdditionalHeaders @{ Authorization = "Bearer $($billingToken.token)" } | Out-Null
         }
         catch {
            _handleException $_
         }
      }
   }
}
