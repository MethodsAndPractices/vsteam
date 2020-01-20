function Add-VSTeamTaskGroup {
    [CmdletBinding()]
    param(
        [Parameter(ParameterSetName = 'ByFile', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string] $InFile,
        [Parameter(ParameterSetName = 'ByBody', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string] $Body,
        [Parameter(Mandatory=$true, Position = 0 )]
        [ValidateProject()]
        [ArgumentCompleter([ProjectCompleter])]
        $ProjectName
    )
    process {
                if ($InFile) {
            $resp = _callAPI -Method Post -ProjectName $ProjectName -Area distributedtask -Resource taskgroups -Version $([VSTeamVersions]::TaskGroups) -InFile $InFile -ContentType 'application/json'
        }
        else {
            $resp = _callAPI -Method Post -ProjectName $ProjectName -Area distributedtask -Resource taskgroups -Version $([VSTeamVersions]::TaskGroups) -ContentType 'application/json' -Body $Body
        }
        return $resp
    }
}
