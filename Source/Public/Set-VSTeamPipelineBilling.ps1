function Set-VSTeamPipelineBilling
{
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High",
      HelpUri = 'https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Set-VSTeamPipelineBilling')]
   param(
      [Parameter(Mandatory = $true)]
      [ValidateSet('HostedPipeline', 'PrivatePipeline')]
      [string] $Type,
      [Parameter(Mandatory = $true)]
      [string] $OrganizationId,

      [Parameter(Mandatory = $true)]
      [string] $SubscriptionId,

      [Parameter(Mandatory = $true)]
      [int] $Quantity,

      [switch] $Force
   )

   process
   {

      $billingToken = _getBillingToken


      $body = @{
         azureSubscriptionId = $SubscriptionId
         committedQuantity   = $Quantity
         offerMeter          = @{
            galleryId = $null
         }
         renewalGroup        = $null
      }

      if ($Type -eq "HostedPipeline")
      {
         $body.offerMeter.galleryId = "ms.build-release-hosted-pipelines"
      }

      if ($Type -eq "PrivatePipeline")
      {
         $body.offerMeter.galleryId = "ms.build-release-private-pipelines"
      }

      $queryString = @{
         billingTarget              = $OrganizationId
         skipSubscriptionValidation = $true
      }

      Write-Verbose $body

      if ($force -or $pscmdlet.ShouldProcess($Quantity, "Quantity"))
      {
         try
         {
            # Call the REST API
            _callAPI `
               -NoProject `
               -Method POST `
               -Url 'https://commerceprodwus21.vscommerce.visualstudio.com/_apis/OfferSubscription/OfferSubscription?api-version=5.1-preview.1' `
               -QueryString $queryString `
               -body ($body| ConvertTo-Json -Depth 50 -Compress) `
               -AdditionalHeaders @{ Authorization = "Bearer $($billingToken.token)"} | Out-Null
         } catch
         {
            _handleException $_
         }
      }

   }
}
