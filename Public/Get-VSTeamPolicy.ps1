function Get-VSTeamPolicy {
   [CmdletBinding()]
   param (
      [Parameter(ValueFromPipeline = $true)]
      [int[]] $Id
   )

   DynamicParam {
      _buildProjectNameDynamicParam -mandatory $true
   }

   process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]
      if ($id) {
         foreach ($item in $id) {
            try {
               $resp = _callAPI -ProjectName $ProjectName -Id $item -Area policy -Resource configurations -Version $([VSTeamVersions]::Git)
   
               _applyTypesToPolicy -item $resp
   
               Write-Output $resp   
            }
            catch {
               throw $_
            }
         }
      }
      else {
         try {
            $resp = _callAPI -ProjectName $ProjectName -Area policy -Resource configurations -Version $([VSTeamVersions]::Git)

            # Apply a Type Name so we can use custom format view and custom type extensions
            foreach ($item in $resp.value) {
               _applyTypesToPolicy -item $item
            }

            Write-Output $resp.value
         }
         catch {
            throw $_
         }
      }
   }
}