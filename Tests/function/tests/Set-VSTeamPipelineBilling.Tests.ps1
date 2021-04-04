Set-StrictMode -Version Latest

Describe 'VSTeamPipelineBilling' -Tag 'unit', 'billing' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$baseFolder/Source/Public/Get-VSTeamUserProfile.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamAccounts.ps1"


      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com' }

      Mock Invoke-RestMethod {
         return $null
      }

      $accounts = Open-SampleFile 'Get-VSTeamAccounts.json'

      Mock _getBillingToken { Open-SampleFile 'getBillingToken.json' }
      Mock _getInstance { return "https://dev.azure.com/TestOrg01" }
      Mock Get-VSTeamUserProfile { Open-SampleFile 'Get-VSTeamUserProfile.json' }
      Mock Get-VSTeamAccounts { return $accounts }
   }

   Context 'Set-VSTeamPipelineBilling' {
      It 'should set hosted pipeline' {
         Set-VSTeamPipelineBilling `
            -Type "HostedPipeline" `
            -OrganizationId "68c631ce-4886-4825-a471-94a74fb6ecda" `
            -Quantity 2 `
            -Force

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 `
            -ParameterFilter {
            $Method -eq 'Post' -and
            $Body -like '*"purchaseQuantity":2*' -and
            $Body -like '*"meterId":"4bad9897-8d87-43bb-80be-5e6e8fefa3de"*' -and
            $Uri -like "https://azdevopscommerce.dev.azure.com/68c631ce-4886-4825-a471-94a74fb6ecda/_apis/AzComm/MeterResource?api-version=5.1-preview.1*"
         }
      }

      It 'should set hosted pipeline for default connected Org' {
         Set-VSTeamPipelineBilling `
            -Type "HostedPipeline" `
            -Quantity 2 `
            -Force

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 `
            -ParameterFilter {
            $Method -eq 'Post' -and
            $Body -like '*"purchaseQuantity":2*' -and
            $Body -like '*"meterId":"4bad9897-8d87-43bb-80be-5e6e8fefa3de"*' -and
            $Uri -like "https://azdevopscommerce.dev.azure.com/81d6e09f-266a-4dd2-886c-b3d62341681e/_apis/AzComm/MeterResource?api-version=5.1-preview.1*"

         }
      }

      It 'should set private pipeline' {
         Set-VSTeamPipelineBilling `
            -Type "PrivatePipeline" `
            -OrganizationId "68c631ce-4886-4825-a471-94a74fb6ecda" `
            -Quantity 2 `
            -Force

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 `
            -ParameterFilter {
            $Method -eq 'Post' -and
            $Body -like '*"purchaseQuantity":2*' -and
            $Body -like '*"meterId":"f44a67f2-53ae-4044-bd58-1c8aca386b98"*' -and
            $Uri -like "https://azdevopscommerce.dev.azure.com/68c631ce-4886-4825-a471-94a74fb6ecda/_apis/AzComm/MeterResource?api-version=5.1-preview.1*"
         }
      }
   }
}
