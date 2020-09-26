function Get-VSTeamPackage {
   [CmdletBinding(HelpUri = 'https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Get-VSTeamPackage')]
   param(
      [Parameter(Position = 0, Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
      [guid] $feedId,

      [Parameter(Position = 1)]
      [Alias("id")]
      [guid] $packageId
   )
   process {
      # Call the REST API
      $resp = _callAPI -Subdomain 'feeds' -NoProject `
         -Area 'Packaging' `
         -Resource 'Feeds' `
         -Id "$feedId/Packages/$packageId" `
         -Version $(_getApiVersion packaging)

      if ($null -ne $packageId) {
         return [vsteam_lib.Package]::new($resp)
      }

      $objs = @()

      foreach ($item in $resp.value) {
         $objs += [vsteam_lib.Package]::new($item, $ProjectName)
      }

      Write-Output $objs
   }
}