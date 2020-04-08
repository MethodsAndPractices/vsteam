function Remove-VSTeamAccessControlEntry {
   [CmdletBinding(DefaultParameterSetName = 'byNamespace', SupportsShouldProcess = $true, ConfirmImpact = 'High')]
   [OutputType([System.String])]
   param(
      [Parameter(ParameterSetName = 'byNamespace', Mandatory = $true, ValueFromPipeline = $true)]
      [VSTeamSecurityNamespace] $securityNamespace,
 
      [Parameter(ParameterSetName = 'byNamespaceId', Mandatory = $true)]
      [guid] $securityNamespaceId,
 
      [Parameter(ParameterSetName = 'byNamespace', Mandatory = $true)]
      [Parameter(ParameterSetName = 'byNamespaceId', Mandatory = $true)]
      [string] $token,
 
      [Parameter(ParameterSetName = 'byNamespace', Mandatory = $true)]
      [Parameter(ParameterSetName = 'byNamespaceId', Mandatory = $true)]
      [System.Array] $descriptor
   )
 
   process {
      if ($securityNamespace) {
         $securityNamespaceId = ($securityNamespace | Select-Object -ExpandProperty id -ErrorAction SilentlyContinue)
      }

      if (($descriptor).count -gt 1) {
         $descriptor = @()

         foreach ($uniqueDescriptor in $descriptor) {
            $uniqueDescriptor = ($uniqueDescriptor).split(".")[1]
            try {
                    
               $uniqueDescriptor = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("$uniqueDescriptor"))
            }
            catch [FormatException] {
               Write-Error "Could not convert base64 string to string."
               continue
            }
            $uniqueDescriptor = "Microsoft.TeamFoundation.Identity;" + "$uniqueDescriptor"

            $descriptor += $uniqueDescriptor
         }
        
         if (($descriptor).count -eq 0) {
            Write-Error "No valid descriptors provided."
            return
         }
         else {
            $descriptor = $descriptor -join ","
         }
      }
      else {
         $descriptor = ($descriptor).split(".")[1]
         try {
            $descriptor = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($descriptor))
         }
         catch {
            trap [FormatException] { }
            Write-Error "Could not convert base64 string to string."
            return
         }
            
         $descriptor = "Microsoft.TeamFoundation.Identity;" + "$descriptor"
      }
        
      if ($PSCmdlet.ShouldProcess("$token")) {
         # Call the REST API
         $resp = _callAPI -method DELETE -Area "accesscontrolentries" -id $securityNamespaceId -ContentType "application/json" -Version $(_getApiVersion Core) -QueryString @{token = $token; descriptors = $descriptor } -ErrorAction SilentlyContinue
      }

      switch ($resp) {
         { ($resp -eq $true) } {
            return "Removal of ACE from ACL succeeded."
         }

         { ($resp -eq $false) } {
            Write-Error "Removal of ACE from ACL failed. Ensure descriptor and token are correct."
            return
         }
         { ($resp -ne $true) -and ($resp -ne $false) } {
            Write-Error "Unexpected response from REST API."
            return
         }
      }
   }
}
