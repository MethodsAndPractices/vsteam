function Get-VSTeamAccessControlList {
   [CmdletBinding(DefaultParameterSetName = 'ByNamespace')]
   param(
      [Parameter(ParameterSetName = 'ByNamespace', Mandatory = $true, ValueFromPipeline = $true)]
      [VSTeamSecurityNamespace] $SecurityNamespace,

      [Parameter(ParameterSetName = 'ByNamespaceId', Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
      [Alias('ID')]
      [guid] $SecurityNamespaceId,

      [Parameter(ParameterSetName = 'ByNamespace', Mandatory = $false)]
      [Parameter(ParameterSetName = 'ByNamespaceId', Mandatory = $false)]
      [string] $Token,

      [Parameter(ParameterSetName = 'ByNamespace', Mandatory = $false)]
      [Parameter(ParameterSetName = 'ByNamespaceId', Mandatory = $false)]
      [string[]] $Descriptors,

      [Parameter(ParameterSetName = 'ByNamespace', Mandatory = $false)]
      [Parameter(ParameterSetName = 'ByNamespaceId', Mandatory = $false)]
      [switch] $IncludeExtendedInfo,

      [Parameter(ParameterSetName = 'ByNamespace', Mandatory = $false)]
      [Parameter(ParameterSetName = 'ByNamespaceId', Mandatory = $false)]
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
      $resp = _callAPI -Area 'accesscontrollists' -id $SecurityNamespaceId -method GET `
         -Version $(_getApiVersion Core) -NoProject `
         -QueryString $queryString

      try {
         $objs = @()

         foreach ($item in $resp.value) {
            $objs += [VSTeamAccessControlList]::new($item)
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