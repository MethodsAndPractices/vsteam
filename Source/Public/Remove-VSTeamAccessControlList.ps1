function Remove-VSTeamAccessControlList {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High", DefaultParameterSetName = 'ByNamespace')]
   param(
      [Parameter(ParameterSetName = 'ByNamespace', Mandatory = $true, ValueFromPipeline = $true)]
      [VSTeamSecurityNamespace] $SecurityNamespace,

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
         $resp = _callAPI -Area 'accesscontrollists' -id $SecurityNamespaceId -method DELETE `
            -Version $(_getApiVersion Core) `
            -QueryString $queryString

         Write-Output $resp
      }
   }
}