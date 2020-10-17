Set-StrictMode -Version Latest

Describe 'VSTeamBilling' -Tag 'unit', 'billing' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' }

      Mock Invoke-RestMethod { Write-Host $args; Open-SampleFile 'Get-VSTeamBillingToken.json' }
   }

   Context 'Get-VSTeamBillingToken' {
      It 'should set hosted pipeline' {
         $token = Get-VSTeamBillingToken

         $token.tokenType | Should -Be 'session' -Because 'tokenType should be set'
         $token.namedTokenId | Should -Be 'CommerceDeploymentProfile' -Because 'namedTokenId should be set'


         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 `
            -ParameterFilter {
            $Method -eq 'Post' -and
            $Body -like '*"namedTokenId":"CommerceDeploymentProfile"*' -and
            $Body -like '*"tokenType":0*' -and
            $Uri -eq "https://dev.azure.com/test/_apis/WebPlatformAuth/SessionToken?api-version=3.2-preview.1"
         }
      }
   }
}
