Set-StrictMode -Version Latest

Describe 'Add-VSTeamAzureRMServiceEndpoint' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$baseFolder/Source/Public/Add-VSTeamServiceEndpoint.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamServiceEndpoint.ps1"
   }

   Context 'Add-VSTeamAzureRMServiceEndpoint' {
      BeforeAll {
         Mock _getInstance { return 'https://dev.azure.com/test' }
         Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'ServiceEndpoints' }

         Mock Write-Progress
         Mock Invoke-RestMethod { _trackProcess }
         Mock Invoke-RestMethod { return @{id = '23233-2342' } } -ParameterFilter { $Method -eq 'Post' }
      }

      It 'should create a new Azure RM Serviceendpoint' {
         Add-VSTeamAzureRMServiceEndpoint -projectName $projectName `
            -SubscriptionName 'SubscriptionName' `
            -SubscriptionId 'SubscriptionId' `
            -SubscriptionTenantId '00000000-0000-0000-0000-000000000000' `
            -ServicePrincipalId '00000000-0000-0000-0000-000000000000' `
            -ServicePrincipalKey 'clientsecret' `
            -EndpointName 'AzureRMTest' `
            -Description 'description here'

         # On PowerShell 5 the JSON has two spaces but on PowerShell 6 it only has one so
         # test for both.
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Post' }
      }
   }
}
