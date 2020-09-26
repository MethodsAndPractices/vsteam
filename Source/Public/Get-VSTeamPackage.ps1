function Get-VSTeamPackage {
   [CmdletBinding(HelpUri = 'https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Get-VSTeamPackage')]
   param(
      [Parameter(Position = 0, Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
      [guid] $feedId,

      [Parameter(Position = 1)]
      [Alias("id")]
      [guid] $packageId,

      [switch] $includeAllVersions
   )
   process {
      # Build query string
      $qs = @{}

      $qs.includeAllVersions = $includeAllVersions.IsPresent

      # Call the REST API
      $resp = _callAPI -Subdomain 'feeds' `
         -Area 'Packaging' `
         -Resource 'Feeds' `
         -Id "$feedId/Packages/$packageId" `
         -QueryString $qs

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