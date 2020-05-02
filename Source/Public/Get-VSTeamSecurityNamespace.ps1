function Get-VSTeamSecurityNamespace {
   [CmdletBinding(DefaultParameterSetName = 'List')]
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

      if ($Id) {
         # Call the REST API
         $resp = _callAPI -Area 'securitynamespaces' -id $Id `
            -Version $(_getApiVersion Core) -NoProject `
      
      }
      else {
         $queryString = @{ }
         if ($LocalOnly.IsPresent) {
            $queryString.localOnly = $true
         }

         $resp = _callAPI -Area 'securitynamespaces' `
            -Version $(_getApiVersion Core) -NoProject `
            -QueryString $queryString
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
               return [VSTeamSecurityNamespace]::new($selected)
            }
            else {
               return $null
            }
         }

         try {
            $objs = @()
            foreach ($item in $resp.value) {
               $objs += [VSTeamSecurityNamespace]::new($item)
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
         $acl = [VSTeamSecurityNamespace]::new($resp.value)

         Write-Output $acl
      }
   }
}