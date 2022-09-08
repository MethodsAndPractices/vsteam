function Get-VSTeamPackageVersion {
   [CmdletBinding(HelpUri = 'https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Get-VSTeamPackageVersion')]
   param(
      [Parameter(Position = 0, Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
      [Alias("feedName")]
      [string] $feedId,

      [Parameter(Position = 1, Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
      [Alias("id")]
      [guid] $packageId,

      [switch] $hideUrls,

      [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )
   process {
      # Build query string
      $qs = @{}

      # Values of empty string, false or 0 are not added to the
      # query string. So in a case like this where we need
      # includeUrls=false on the query string we have to set false
      # as a string and not $false
      if ($hideUrls.IsPresent) {
         $qs.includeUrls = 'false'
      }

      $commonArgs = @{
         SubDomain = 'feeds'
         Area      = 'packaging'
         Resource  = 'feeds'
         Id = "$feedId/Packages/$packageId/versions"
         QueryString = $qs
         Version   = $(_getApiVersion Packaging)
      }

      if ($ProjectName) {
         $commonArgs.ProjectName = $ProjectName
      }else{
         $commonArgs.NoProject = $true
      }

      # Call the REST API
      $resp = _callAPI @commonArgs

      $objs = @()
      foreach ($item in $resp.value) {
         $objs += [vsteam_lib.PackageVersion]::new($item)
      }

      Write-Output $objs
   }
}