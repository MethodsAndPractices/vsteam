function Get-VSTeamPackage {
   [CmdletBinding(DefaultParameterSetName = 'List',
      HelpUri = 'https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Get-VSTeamPackage')]
   param(
      [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline, ValueFromPipelineByPropertyName)]
      [Alias("feedName")]
      [string] $feedId,

      [Parameter(Position = 1, Mandatory= $true, ParameterSetName = 'ById')]
      [Alias("id")]
      [guid] $packageId,

      [switch] $includeAllVersions,

      [switch] $includeDeleted,

      [switch] $includeDescription,

      [switch] $hideUrls,

      [Parameter(ParameterSetName = 'List')]
      [string] $protocolType,

      [Parameter(ParameterSetName = 'List')]
      [string] $packageNameQuery,

      [Parameter(ParameterSetName = 'List')]
      [int] $Top,

      [Parameter(ParameterSetName = 'List')]
      [int] $Skip,

      [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )
   process {
      # Build query string
      $qs = @{}

      $qs['$top'] = $top
      $qs['$skip'] = $skip
      $qs.protocolType = $protocolType
      $qs.packageNameQuery = $packageNameQuery
      $qs.includeDeleted = $includeDeleted.IsPresent
      $qs.includeDescription = $includeDescription.IsPresent
      $qs.includeAllVersions = $includeAllVersions.IsPresent

      # Values of empty string, false or 0 are not added to the
      # query string. So in a case like this where we need
      # includeUrls=false on the query string we have to set false
      # as a string and not $false
      if ($hideUrls.IsPresent) {
         $qs.includeUrls = 'false'
      }

      $commonArgs = @{
         subDomain = 'feeds'
         area      = 'packaging'
         resource  = 'feeds'
         Id = "$feedId/Packages/$packageId"
         QueryString = $qs
         version   = $(_getApiVersion Packaging)
      }

      if ($ProjectName) {
         $commonArgs.ProjectName = $ProjectName
      }else{
         $commonArgs.NoProject = $true
      }

      # Call the REST API
      $resp = _callAPI @commonArgs

      if ($null -ne $packageId) {
         return [vsteam_lib.Package]::new($resp, $feedId)
      }

      $objs = @()

      foreach ($item in $resp.value) {
         $objs += [vsteam_lib.Package]::new($item, $feedId)
      }

      Write-Output $objs
   }
}