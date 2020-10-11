function Get-VSTeamBillingToken
{
   [CmdletBinding(HelpUri = 'https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Get-VSTeamBillingToken')]
   param ()

   $sessionToken = @{
      appId=00000000-0000-0000-0000-000000000000
      force=false
      tokenType=0
      namedTokenId ="CommerceDeploymentProfile"
   }

   $billingToken = _callAPI `
      -NoProject `
      -method POST `
      -ContentType "application/json" `
      -area "WebPlatformAuth" `
      -resource "SessionToken" `
      -version '3.2-preview.1' `
      -body ($sessionToken | ConvertTo-Json -Depth 50 -Compress)

   Write-Output $billingToken
}