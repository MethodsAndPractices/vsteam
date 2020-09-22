function Get-VSTeamPolicy {
   [CmdletBinding(HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Get-VSTeamPolicy')]
   param (
      [Parameter(ValueFromPipeline = $true)]
      [int[]] $Id,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )
   process {
      if ($id) {
         foreach ($item in $id) {
            try {
               $resp = _callAPI -ProjectName $ProjectName `
                  -Area policy `
                  -Resource configurations `
                  -Id $item `
                  -Version $(_getApiVersion Policy)

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
            $resp = _callAPI -ProjectName $ProjectName `
               -Area policy `
               -Resource configurations `
               -Version $(_getApiVersion Policy)

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