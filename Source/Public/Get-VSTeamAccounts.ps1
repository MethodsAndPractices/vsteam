function Get-VSTeamAccounts {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High",
      HelpUri = 'https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Get-VSTeamAccounts')]
   param(
      [Parameter(Mandatory = $true, ParameterSetName = "MemberId")]
      [string] $MemberId,
      [Parameter(Mandatory = $true, ParameterSetName = "OwnerId")]
      [string] $OwnerId
   )

   process {

      $queryString = @{}
      if ($PsCmdlet.ParameterSetName -eq "MemberId") {
         $queryString = @{
            memberId = $MemberId
         }
      }

      if ($PsCmdlet.ParameterSetName -eq "OwnerId") {
         $queryString = @{
            ownerId = $OwnerId
         }
      }

      try {
         # Call the REST API
         $resp = _callAPI `
            -Method GET `
            -Url "https://vssps.dev.azure.com/_apis/accounts?api-version=$(_getApiVersion Core)" `
            -QueryString $queryString

         Write-Output $resp.value
      }
      catch {
         _handleException $_
      }


   }
}
