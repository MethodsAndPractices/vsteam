function Get-VSTeamRelease {
   [CmdletBinding(DefaultParameterSetName = 'List')]
   param(
      [ValidateSet('environments', 'artifacts', 'approvals', 'none')]
      [string] $expand,

      [Parameter(ParameterSetName = 'List')]
      [ValidateSet('Draft', 'Active', 'Abandoned')]
      [string] $statusFilter,

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

      [Parameter(Position = 0, ParameterSetName = 'ByID', ValueFromPipelineByPropertyName = $true)]
      [Alias('ReleaseID')]
      [int[]] $id
   )

   DynamicParam {
      _buildProjectNameDynamicParam -Mandatory $false -Position 1
   }

   process {
      Write-Debug 'Get-VSTeamRelease Process'

      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      if ($id) {
         foreach ($item in $id) {
            $resp = _callAPI -SubDomain vsrm -ProjectName $ProjectName -Area release -id $item -Resource releases -Version $([VSTeamVersions]::Release)

            # Apply a Type Name so we can use custom format view and custom type extensions
            _applyTypesToRelease -item $resp

            Write-Output $resp
         }
      }
      else {
         if ($ProjectName) {
            $listurl = _buildRequestURI -SubDomain vsrm -ProjectName $ProjectName -Area release -Resource releases -Version $([VSTeamVersions]::Release)
         }
         else {
            $listurl = _buildRequestURI -SubDomain vsrm -Area release -Resource releases -Version $([VSTeamVersions]::Release)
         }

         $QueryString = @{
            '$top'              = $top
            '$expand'           = $expand
            'createdBy'         = $createdBy
            'queryOrder'        = $queryOrder
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