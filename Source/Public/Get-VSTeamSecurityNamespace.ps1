function Get-VSTeamSecurityNamespace {
   [CmdletBinding(DefaultParameterSetName = 'List',
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Get-VSTeamSecurityNamespace')]
   param(
      [Parameter(ParameterSetName = 'ByNamespaceName', Mandatory = $true)]
      [string] $Name,

      [Parameter(ParameterSetName = 'ByNamespaceId', Mandatory = $true)]
      [guid] $Id,

      [Parameter(ParameterSetName = 'List', Mandatory = $false)]
      [switch] $LocalOnly
   )

   process {
      _supportsSecurityNamespace

      $commonArgs = @{
         Resource  = 'securitynamespaces'
         NoProject = $true
         Version   = $(_getApiVersion Core)
      }

      if ($Id) {
         # Call the REST API
         $resp = _callAPI @commonArgs -id $Id
      }
      else {
         $queryString = @{ }
         if ($LocalOnly.IsPresent) {
            $queryString.localOnly = $true
         }

         $resp = _callAPI @commonArgs -QueryString $queryString
      }

      Write-Verbose $resp | Select-Object -ExpandProperty value

      if ($resp.count -le 0) {
         Write-Output $null
      }

      if ($resp.count -gt 1) {
         # If we only need to find one specific by name
         if ($Name) {
            $selected = $resp.value | Where-Object { $_.name -eq $Name }
            if ($selected) {
               Write-Output [vsteam_lib.SecurityNamespace]::new($selected)
            }
            else {
               Write-Output $null
            }
         }

         try {
            $objs = @()
            foreach ($item in $resp.value) {
               $objs += [vsteam_lib.SecurityNamespace]::new($item)
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
      else {
         # Storing the object before you return it cleaned up the pipeline.
         # When I just write the object from the constructor each property
         # seemed to be written
         $acl = [vsteam_lib.SecurityNamespace]::new($resp.value[0])

         Write-Output $acl
      }
   }
}