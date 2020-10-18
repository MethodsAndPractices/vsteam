Set-StrictMode -Version Latest

Describe 'VSTeamBilling' -Tag 'unit', 'billing' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com' }

      Mock Invoke-RestMethod {
         Write-Host $args
         return $null
      }

      Mock Get-VSTeamBillingToken { Open-SampleFile 'Get-VSTeamBillingToken.json' }
   }

   Context 'Set-VSTeamBilling' {
      It 'should set hosted pipeline' {
         Set-VSTeamBilling `
            -Type "HostedPipeline" `
            -OrganizationId "68c631ce-4886-4825-a471-94a74fb6ecda" `
            -SubscriptionId "fbafed90-9c59-4889-8187-8e74e2cf06e7" `
            -Quantity 2 `
            -Force

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 `
            -ParameterFilter {
            $Method -eq 'Post' -and
            $Body -like '*"azureSubscriptionId":"fbafed90-9c59-4889-8187-8e74e2cf06e7"*' -and
            $Body -like '*"committedQuantity":2*' -and
            $Body -like '*"galleryId":"ms.build-release-hosted-pipelines"*' -and
            $Uri -like "https://commerceprodwus21.vscommerce.visualstudio.com/_apis/OfferSubscription/OfferSubscription?api-version=5.1-preview.1*" -and
            $Uri -like "*billingTarget=68c631ce-4886-4825-a471-94a74fb6ecda*" -and
            $Uri -like "*skipSubscriptionValidation=True*"

         }
      }

      It 'should set private pipeline' {
         Set-VSTeamBilling `
            -Type "PrivatePipeline" `
            -OrganizationId "68c631ce-4886-4825-a471-94a74fb6ecda" `
            -SubscriptionId "fbafed90-9c59-4889-8187-8e74e2cf06e7" `
            -Quantity 2 `
            -Force

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 `
            -ParameterFilter {
            $Method -eq 'Post' -and
            $Body -like '*"azureSubscriptionId":"fbafed90-9c59-4889-8187-8e74e2cf06e7"*' -and
            $Body -like '*"committedQuantity":2*' -and
            $Body -like '*"galleryId":"ms.build-release-private-pipelines"*' -and
            $Uri -like "https://commerceprodwus21.vscommerce.visualstudio.com/_apis/OfferSubscription/OfferSubscription?api-version=5.1-preview.1*" -and
            $Uri -like "*billingTarget=68c631ce-4886-4825-a471-94a74fb6ecda*" -and
            $Uri -like "*skipSubscriptionValidation=True*"
         }
      }
   }

   Context 'Set-VSTeamBilling handles exception' {
      BeforeAll {
         Mock _handleException
         Mock Invoke-RestMethod { throw 'testing error handling' }
      }

   }
}
