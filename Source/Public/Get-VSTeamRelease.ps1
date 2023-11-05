function Get-VSTeamRelease {
   [CmdletBinding(DefaultParameterSetName = 'List',
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Get-VSTeamRelease')]
   param(
      [Parameter(Position = 0, Mandatory = $true, ParameterSetName = 'ByIdRaw')]
      [Parameter(Position = 0, Mandatory = $true, ParameterSetName = 'ByID', ValueFromPipelineByPropertyName = $true)]
      [Alias('ReleaseID')]
      [int[]] $Id,

      [Parameter(ParameterSetName = 'List')]
      [string] $SearchText,

      [Parameter(ParameterSetName = 'List')]
      [ValidateSet('Draft', 'Active', 'Abandoned')]
      [string] $StatusFilter,

      [ValidateSet('environments', 'artifacts', 'approvals', 'none')]
      [string] $Expand,

      [Parameter(ParameterSetName = 'List')]
      [int] $DefinitionId,

      [Parameter(ParameterSetName = 'List')]
      [string] $ArtifactVersionId,

      [Parameter(ParameterSetName = 'List')]
      [int] $Top,

      [Parameter(ParameterSetName = 'List')]
      [string] $CreatedBy,

      [Parameter(ParameterSetName = 'List')]
      [DateTime] $MinCreatedTime,

      [Parameter(ParameterSetName = 'List')]
      [DateTime] $MaxCreatedTime,

      [Parameter(ParameterSetName = 'List')]
      [ValidateSet('ascending', 'descending')]
      [string] $QueryOrder,

      [Parameter(ParameterSetName = 'List')]
      [string] $ContinuationToken,

      [switch] $JSON,

      [Parameter(Mandatory = $true, ParameterSetName = 'ByIdRaw')]
      [switch] $Raw,

      [Parameter(Position = 1, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )

   process {
      $commonArgs = @{
         subDomain = 'vsrm'
         area      = 'release'
         resource  = 'releases'
         version   = $(_getApiVersion Release)
      }

      if ($Id) {
         foreach ($item in $Id) {
            $resp = _callAPI @commonArgs -ProjectName $ProjectName -id $item

            if ($JSON.IsPresent) {
               $resp | ConvertTo-Json -Depth 99
            }
            else {
               if (-not $raw.IsPresent) {
                  Write-Output $([vsteam_lib.Release]::new($resp, $ProjectName))
               }
               else {
                  Write-Output $resp
               }
            }
         }
      }
      else {
         if ($ProjectName) {
            $listurl = _buildRequestURI @commonArgs -ProjectName $ProjectName
         }
         else {
            $listurl = _buildRequestURI @commonArgs
         }

         $queryString = @{
            '$top'              = $Top
            '$expand'           = $Expand
            'createdBy'         = $CreatedBy
            'queryOrder'        = $QueryOrder
            'searchText'        = $SearchText
            'statusFilter'      = $StatusFilter
            'definitionId'      = $DefinitionId
            'minCreatedTime'    = $MinCreatedTime
            'maxCreatedTime'    = $MaxCreatedTime
            'continuationToken' = $ContinuationToken
            'artifactVersionId' = $ArtifactVersionId
         }

         # Call the REST API
         $resp = _callAPI -url $listurl -QueryString $queryString

         if ($JSON.IsPresent) {
            $resp | ConvertTo-Json -Depth 99
         }
         else {
            $objs = @()

            foreach ($item in $resp.value) {
               $objs += [vsteam_lib.Release]::new($item, $ProjectName)
            }

            Write-Output $objs
         }
      }
   }
}
