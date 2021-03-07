function Update-VSTeamNuGetPackageVersion {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium",
      HelpUri = 'https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Update-VSTeamNuGetPackageVersion')]
   param (
      [parameter(Mandatory)]
      [Alias("feedName")]
      [string] $FeedId,

      [parameter(Mandatory)]
      [string] $PackageName,

      [parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
      [Alias("Version")]
      [string[]] $PackageVersion,

      [parameter(Mandatory = $true)]
      [bool] $isListed,

      [switch] $Force
   )
   process {
      foreach ($item in $PackageVersion) {
         if ($Force -or $pscmdlet.ShouldProcess($item, "update version")) {

            $obj = @{
               listed = $isListed
            }

            $body = $obj | ConvertTo-Json -Compress

            _callAPI -Method PATCH -SubDomain pkgs `
               -Area "packaging/feeds/$FeedId/nuget" `
               -Resource "packages/$PackageName/versions" `
               -Id $item `
               -Body $body `
               -Version $(_getApiVersion Packaging) | Out-Null
         }
      }
   }
}