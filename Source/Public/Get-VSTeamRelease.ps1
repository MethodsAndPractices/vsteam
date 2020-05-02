function Get-VSTeamRelease {
   [CmdletBinding(DefaultParameterSetName = 'List')]
   param(
      [Parameter(Position = 0, Mandatory = $true, ParameterSetName = 'ByIdRaw')]
      [Parameter(Position = 0, Mandatory = $true, ParameterSetName = 'ByIdJson')]
      [Parameter(Position = 0, Mandatory = $true, ParameterSetName = 'ByID', ValueFromPipelineByPropertyName = $true)]
      [Alias('ReleaseID')]
      [int[]] $id,

      [Parameter(ParameterSetName = 'List')]
      [string] $searchText,

      [Parameter(ParameterSetName = 'List')]
      [ValidateSet('Draft', 'Active', 'Abandoned')]
      [string] $statusFilter,

      [ValidateSet('environments', 'artifacts', 'approvals', 'none')]
      [string] $expand,

      [Parameter(ParameterSetName = 'List')]
      [int] $definitionId,

      [Parameter(ParameterSetName = 'List')]
      [int] $top,

      [Parameter(ParameterSetName = 'List')]
      [string] $createdBy,

      [Parameter(ParameterSetName = 'List')]
      [DateTime] $minCreatedTime,

      [Parameter(ParameterSetName = 'List')]
      [DateTime] $maxCreatedTime,

      [Parameter(ParameterSetName = 'List')]
      [ValidateSet('ascending', 'descending')]

      [string] $queryOrder,
      [Parameter(ParameterSetName = 'List')]

      [string] $continuationToken,
      [Parameter(Mandatory = $true, ParameterSetName = 'ByIdJson')]

      [switch] $JSON,
      [Parameter(Mandatory = $true, ParameterSetName = 'ByIdRaw')]

      [switch] $raw,

      [Parameter(Position = 1, ValueFromPipelineByPropertyName = $true)]
      [ProjectValidateAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      [string] $ProjectName
   )

   process {
      if ($id) {
         foreach ($item in $id) {
            $resp = _callAPI -SubDomain vsrm -ProjectName $ProjectName -Area release -id $item -Resource releases -Version $(_getApiVersion Release)

            if ($JSON.IsPresent) {
               $resp | ConvertTo-Json -Depth 99
            }
            else {
               if (-not $raw.IsPresent) {
                  # Apply a Type Name so we can use custom format view and custom type extensions
                  _applyTypesToRelease -item $resp
               }

               Write-Output $resp
            }
         }
      }
      else {
         if ($ProjectName) {
            $listurl = _buildRequestURI -SubDomain vsrm -ProjectName $ProjectName -Area release -Resource releases -Version $(_getApiVersion Release)
         }
         else {
            $listurl = _buildRequestURI -SubDomain vsrm -Area release -Resource releases -Version $(_getApiVersion Release)
         }

         $QueryString = @{
            '$top'              = $top
            '$expand'           = $expand
            'createdBy'         = $createdBy
            'queryOrder'        = $queryOrder
            'searchText'        = $searchText
            'statusFilter'      = $statusFilter
            'definitionId'      = $definitionId
            'minCreatedTime'    = $minCreatedTime
            'maxCreatedTime'    = $maxCreatedTime
            'continuationToken' = $continuationToken

         }

         # Call the REST API
         $resp = _callAPI -url $listurl -QueryString $QueryString
         
         # Apply a Type Name so we can use custom format view and custom type extensions
         foreach ($item in $resp.value) {
            _applyTypesToRelease -item $item
         }
         
         Write-Output $resp.value
      }
   }
}
