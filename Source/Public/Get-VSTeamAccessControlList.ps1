function Get-VSTeamAccessControlList {
   [CmdletBinding(DefaultParameterSetName = 'ByNamespace',
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Get-VSTeamAccessControlList')]
   param(
      [Parameter(ParameterSetName = 'ByNamespace', Mandatory = $true, ValueFromPipeline = $true)]
      [vsteam_lib.SecurityNamespace] $SecurityNamespace,

      [Parameter(ParameterSetName = 'ByNamespaceId', Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
      [Alias('ID')]
      [guid] $SecurityNamespaceId,

      [string] $Token,

      [string[]] $Descriptors,

      [switch] $IncludeExtendedInfo,

      [switch] $Recurse
   )

   process {
      if ($SecurityNamespace) {
         $SecurityNamespaceId = $SecurityNamespace.ID
      }

      $queryString = @{ }

      if ($Token) {
         $queryString.token = $Token
      }

      if ($Descriptors -and $Descriptors.Length -gt 0) {
         $queryString.descriptors = $Descriptors -join ","
      }

      if ($IncludeExtendedInfo.IsPresent) {
         $queryString.includeExtendedInfo = $true
      }

      if ($Recurse.IsPresent) {
         $queryString.recurse = $true
      }

      # Call the REST API
      $resp = _callAPI -NoProject `
         -Resource accesscontrollists `
         -id $SecurityNamespaceId `
         -QueryString $queryString `
         -Version $(_getApiVersion Core)

      try {
         $objs = @()

         foreach ($item in $resp.value) {
            $objs += [vsteam_lib.AccessControlList]::new($item)
         }

         Write-Output $objs
      }
      catch {
         # I catch because using -ErrorAction Stop on the Invoke-RestMethod
         # was still running the foreach after and reporting useless errors.
         # This casuses the first error to terminate this execution.
         _handleException $_
      }
   }
}