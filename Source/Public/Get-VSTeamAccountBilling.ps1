function Get-VSTeamAccountBilling {
   [CmdletBinding(
      HelpUri = 'https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Get-VSTeamAccountBilling')]
   param( )

   process {

      $userProfileId = (Get-VSTeamUserProfile -MyProfile).id
      $currentAccount = (Get-VSTeamAccounts -MemberId $userProfileId) | Where-Object { (_getInstance).EndsWith($_.accountName) }

      try {
         # need to use the url, since this specific api needs to have
         # the account guide instead of the clear name in the url
         # _callAPI does not support this, hence full URL is used
         _callAPI `
            -Url "https://azdevopscommerce.dev.azure.com/$($currentAccount.accountId)/_apis/AzComm/BillingSetup?api-version=5.1-preview.1"
      }
      catch {
         _handleException $_
      }
   }
}
