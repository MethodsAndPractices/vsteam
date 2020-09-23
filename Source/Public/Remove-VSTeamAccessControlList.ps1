function Remove-VSTeamAccessControlList {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High", DefaultParameterSetName = 'ByNamespace',
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Remove-VSTeamAccessControlList')]
   param(
      [Parameter(ParameterSetName = 'ByNamespace', Mandatory = $true, ValueFromPipeline = $true)]
      [vsteam_lib.SecurityNamespace] $SecurityNamespace,

      [Parameter(ParameterSetName = 'ByNamespaceId', Mandatory = $true)]
      [guid] $SecurityNamespaceId,

      [Parameter(ParameterSetName = 'ByNamespace', Mandatory = $true)]
      [Parameter(ParameterSetName = 'ByNamespaceId', Mandatory = $true)]
      [string[]] $Tokens,

      [Parameter(ParameterSetName = 'ByNamespace', Mandatory = $false)]
      [Parameter(ParameterSetName = 'ByNamespaceId', Mandatory = $false)]
      [switch] $Recurse,

      [switch] $Force
   )

   process {
      if ($SecurityNamespace) {
         $SecurityNamespaceId = $SecurityNamespace.ID
      }

      $queryString = @{ }

      if ($Tokens) {
         $queryString.tokens = $Tokens -join ","
      }

      if ($Recurse.IsPresent) {
         $queryString.recurse = $true
      }

      if ($Force -or $pscmdlet.ShouldProcess($queryString.tokens, "Delete ACL")) {
         # Call the REST API
         $resp = _callAPI -Method DELETE `
            -Resource accesscontrollists `
            -id $SecurityNamespaceId  `
            -QueryString $queryString `
            -Version $(_getApiVersion Core)

         Write-Output $resp
      }
   }
}