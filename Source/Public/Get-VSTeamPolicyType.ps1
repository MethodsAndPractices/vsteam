function Get-VSTeamPolicyType {
   [CmdletBinding()]
   param (
      [Parameter(ValueFromPipeline = $true)]
      [guid[]] $Id,

      [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
      [ProjectValidateAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      [string] $ProjectName
   )

   process {
      if ($id) {
         foreach ($item in $id) {
            try {
               $resp = _callAPI -ProjectName $ProjectName -Id $item -Area policy -Resource types -Version $(_getApiVersion Policy)

               _applyTypesToPolicyType -item $resp

               Write-Output $resp
            }
            catch {
               throw $_
            }
         }
      }
      else {
         try {
            $resp = _callAPI -ProjectName $ProjectName -Area policy -Resource types -Version $(_getApiVersion Policy)

            # Apply a Type Name so we can use custom format view and custom type extensions
            foreach ($item in $resp.value) {
               _applyTypesToPolicyType -item $item
            }

            Write-Output $resp.value
         }
         catch {
            throw $_
         }
      }
   }
}