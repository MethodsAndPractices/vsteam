# Removes specified ACEs in the ACL for the provided token. The request URI
# contains the namespace ID, the target token, and a single or list of
# descriptors that should be removed. Only supports removing AzD based
# users/groups.
#
# Get-VSTeamOption 'Security' 'AccessControlEntries'
# id              : ac08c8ff-4323-4b08-af90-bcd018d380ce
# area            : Security
# resourceName    : AccessControlEntries
# routeTemplate   : _apis/{resource}/{securityNamespaceId}
# https://bit.ly/Add-VSTeamAccessControlEntry

function Remove-VSTeamAccessControlEntry {
   [CmdletBinding(DefaultParameterSetName = 'byNamespace', SupportsShouldProcess = $true, ConfirmImpact = 'High',
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Remove-VSTeamAccessControlEntry')]
   [OutputType([System.String])]
   param(
      [Parameter(ParameterSetName = 'byNamespace', Mandatory = $true, ValueFromPipeline = $true)]
      [vsteam_lib.SecurityNamespace] $securityNamespace,

      [Parameter(ParameterSetName = 'byNamespaceId', Mandatory = $true)]
      [guid] $securityNamespaceId,

      [string] $token,

      [System.Array] $descriptor,

      [switch] $force
   )

   process {
      if ($securityNamespace) {
         $securityNamespaceId = ($securityNamespace | Select-Object -ExpandProperty id)
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

      if ($Force -or $pscmdlet.ShouldProcess($token, "Remove ACE from ACL")) {
         # Call the REST API
         $resp = _callAPI -Method DELETE `
            -Resource "accesscontrolentries" `
            -id $securityNamespaceId `
            -QueryString @{ token = $token; descriptors = $descriptor } `
            -Version $(_getApiVersion Core)
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
