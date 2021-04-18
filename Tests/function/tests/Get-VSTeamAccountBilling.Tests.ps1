Set-StrictMode -Version Latest

Describe 'VSTeamAccountBilling' -Tag 'unit', 'billing' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$baseFolder/Source/Public/Get-VSTeamUserProfile.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamAccounts.ps1"

      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com' }

      $accounts = Open-SampleFile 'Get-VSTeamAccounts.json'
      $accountBillingWithSubscription = Open-SampleFile 'Get-VSTeamAccountBillingWithSubscription.json'

      Mock Invoke-RestMethod {
         return $accountBillingWithSubscription
      } -ParameterFilter { $Uri -like "*AzComm/BillingSetup*" }

      Mock _getInstance { return "https://dev.azure.com/TestOrg01" }
      Mock Get-VSTeamUserProfile { Open-SampleFile 'Get-VSTeamUserProfile.json' }
      Mock Get-VSTeamAccounts { return $accounts }
   }

   Context 'Get-VSTeamAccountBilling' {
      It 'should set hosted pipeline' {
         $accountBilling = Get-VSTeamAccountBilling

         $accountBilling | Should -not -Be $null

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 `
            -ParameterFilter {
            $Uri -like "https://azdevopscommerce.dev.azure.com/81d6e09f-266a-4dd2-886c-b3d62341681e/_apis/AzComm/BillingSetup*" -and
            $Uri -like "*api-version=5.1-preview.1*"
         }
      }
   }
}
