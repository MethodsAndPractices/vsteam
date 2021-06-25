function Get-VSTeamAccounts {
   [CmdletBinding(HelpUri = 'https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Get-VSTeamAccounts')]
   param(
      [Parameter(Mandatory = $true, ParameterSetName = "MemberId")]
      [string] $MemberId,

      [Parameter(Mandatory = $true, ParameterSetName = "OwnerId")]
      [string] $OwnerId
   )

   process {
      $queryString = @{ }

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
         $resp = _callAPI -NoAccount `
            -NoProject `
            -area 'accounts' `
            -subDomain 'vssps' `
            -QueryString $queryString `
            -version $(_getApiVersion Core)

         Write-Output $resp.value
      }
      catch {
         _handleException $_
      }
   }
}
