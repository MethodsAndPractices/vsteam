function Add-VSTeamBuild {
    [CmdletBinding(DefaultParameterSetName = 'ByName')]
    param(
        [Parameter(ParameterSetName = 'ByID', ValueFromPipelineByPropertyName = $true)]
        [Int32] $BuildDefinitionId,
        [Parameter(Mandatory = $false)]
        [string] $SourceBranch,
        [Parameter(Mandatory = $false)]
        [hashtable] $BuildParameters,
        [Parameter(Mandatory=$true, Position = 0 )]
        [ValidateProjectAttribute()]
        [ArgumentCompleter([ProjectCompleter])]
        $ProjectName,
        [ArgumentCompleter([TeamQueueCompleter])]
        $QueueName,
        [ArgumentCompleter([BuildDefinitionCompleter])]
        $BuildDefinitionName
    )
begin {
    if     ($BuildDefinitionId)   {         
        $body = @{
            definition = @{id = $BuildDefinitionId};
        } 
    }
    elseif ($BuildDefinitionName) {
        # Find the BuildDefinition id from the name
        $id = (Get-VSTeamBuildDefinition  -Filter $BuildDefinitionName  -Type All).id
        if (-not $id) {
            throw "'$BuildDefinitionName' is not a valid build definition. Use Get-VSTeamBuildDefinition to get a list of build names"  ; return
        }
        $body = @{
            definition = @{id = $id};
        } 
    }
    else {  throw "'No build definition was given. Use Get-VSTeamBuildDefinition to get a list of builds"  ; return}
    if ($QueueName) {
        $queueId = (Get-VSTeamQueue -ProjectName "$ProjectName" -queueName "$QueueName").id
        if (-not ($env:Testing -or $queueId)) {
            throw "'$QueueName' is not a valid Queue. Use Get-VSTeamQueue to get a list of queues"  ; return
        }
        else {$body["queue"] =  @{id = $queueId }}
    }
}

    process {
        if ($SourceBranch) {
            $body.Add('sourceBranch', $SourceBranch)
        }
        if ($BuildParameters) {
            $body.Add('parameters', ($BuildParameters | ConvertTo-Json -Compress))
        }
        # Call the REST API
        $resp = _callAPI -ProjectName $ProjectName -Area 'build' -Resource 'builds' `
            -Method Post -ContentType 'application/json' -Body ($body | ConvertTo-Json) `
            -Version $([VSTeamVersions]::Build)
        _applyTypesToBuild -item $resp
        return $resp
    }
}
