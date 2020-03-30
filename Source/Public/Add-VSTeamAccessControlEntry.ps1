function Add-VSTeamAccessControlEntry {
   [CmdletBinding(DefaultParameterSetName = 'ByNamespace')]
   param(
      [Parameter(ParameterSetName = 'ByNamespace', Mandatory = $true, ValueFromPipeline = $true)]
      [VSTeamSecurityNamespace] $SecurityNamespace,

      [Parameter(ParameterSetName = 'ByNamespaceId', Mandatory = $true)]
      [guid] $SecurityNamespaceId,

      [Parameter(ParameterSetName = 'ByNamespace', Mandatory = $true)]
      [Parameter(ParameterSetName = 'ByNamespaceId', Mandatory = $true)]
      [string] $Token,

      [Parameter(ParameterSetName = 'ByNamespace', Mandatory = $true)]
      [Parameter(ParameterSetName = 'ByNamespaceId', Mandatory = $true)]
      [string] $Descriptor,

      [Parameter(ParameterSetName = 'ByNamespace', Mandatory = $true)]
      [Parameter(ParameterSetName = 'ByNamespaceId', Mandatory = $true)]
      [ValidateRange(0, [int]::MaxValue)]
      [int] $AllowMask,

      [Parameter(ParameterSetName = 'ByNamespace', Mandatory = $true)]
      [Parameter(ParameterSetName = 'ByNamespaceId', Mandatory = $true)]
      [ValidateRange(0, [int]::MaxValue)]
      [int] $DenyMask
   )

   process {
      if ($SecurityNamespace) {
         $SecurityNamespaceId = $SecurityNamespace.ID
      }

      $body =
      @"
   {
      "token": "$Token",
      "merge": true,
      "accessControlEntries": [
         {
            "descriptor": "$Descriptor",
            "allow": $AllowMask,
            "deny": $DenyMask,
            "extendedinfo": {}
         }
      ]
   }
"@
      # Call the REST API
      $resp = _callAPI -Area 'accesscontrolentries' -id $SecurityNamespaceId -method POST -body $body `
         -Version $(_getApiVersion Core) -NoProject `
         -ContentType "application/json"

      if ($resp.count -ne 1) {
         throw "Expected 1 result, but got $($rep.count)"
      }

      # Storing the object before you return it cleaned up the pipeline.
      # When I just write the object from the constructor each property
      # seemed to be written
      $acl = [VSTeamAccessControlEntry]::new($resp.value)

      Write-Output $acl
   }
}