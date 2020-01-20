function Get-VSTeamServiceEndpoint {
    [CmdletBinding(DefaultParameterSetName = 'List')]
    param(
        [Parameter(ParameterSetName = 'ByID', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string] $id,
        [Parameter(Mandatory=$true, Position = 0 )]
        [ValidateProject()]
        [ArgumentCompleter([ProjectCompleter])]
        $ProjectName
    )
    process {
                if ($id) {
            # Call the REST API
            $resp = _callAPI -Area 'distributedtask' -Resource 'serviceendpoints' -Id $id  `
                -Version $([VSTeamVersions]::DistributedTask) -ProjectName $ProjectName
            _applyTypesToServiceEndpoint -item $resp
            Write-Output $resp
        }
        else {
            # Call the REST API
            $resp = _callAPI -ProjectName $ProjectName -Area 'distributedtask' -Resource 'serviceendpoints'  `
                -Version $([VSTeamVersions]::DistributedTask)
            # Apply a Type Name so we can use custom format view and custom type extensions
            foreach ($item in $resp.value) {
                _applyTypesToServiceEndpoint -item $item
            }
            return $resp.value
        }
    }
}
