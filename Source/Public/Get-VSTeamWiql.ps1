function Get-VSTeamWiql {
    [CmdletBinding(DefaultParameterSetName = 'ByID')]
    param(
        [QueryTransformToID()]
        [ArgumentCompleter([QueryCompleter])]
        [Parameter(ParameterSetName = 'ByID', Mandatory = $true, Position = 0)]
        [string] $Id,
        [Parameter(ParameterSetName = 'ByQuery', Mandatory = $true)]
        [string] $Query,
        [Parameter(Position=1)]
        [ValidateProjectAttribute()]
        [ArgumentCompleter([ProjectCompleter])]
        $ProjectName,
        [string] $Team,
        [int] $Top = 100,
        [Switch] $TimePrecision,
        [Switch] $Expand
    )
    Process {
        $params      =  @{ 
            ProjectName = $ProjectName 
            Area        = 'wit'
            Resource    = 'wiql' 
            Version     =  [VSTeamVersions]::Core
            QueryString = @{
                '$top'        = $Top
                timePrecision = $TimePrecision
            }
        }
        if ($Team) {
            $params['Team']=  $Team 
        }
        if ($Query) {
            $params['body']   = @{query = $Query} | ConvertTo-Json
            $params['method'] = 'POST'
            $params['ContentType'] = 'application/json'
        }
        else {
            $params['id']= $Id
        }
        Write-Progress -Activity "Querying Data" -CurrentOperation "Getting list of items"
        $resp = _callAPI  @params
        if ($Expand) {
            if ($resp.queryResultType -eq 'workItemLink') {
                Add-Member -InputObject $resp -MemberType NoteProperty -Name Workitems -Value @()
                $Ids = $resp.workItemRelations.Target.id
            }
            else {  $Ids = $resp.workItems.id }
            #splitting id array by 200, since a maximum of 200 ids are allowed per call
            $countIds = $Ids.Count
            $resp.workItems = for ($beginRange = 0; $beginRange -lt $countIds; $beginRange += 200) {
                #strict mode is on so pick lesser of  0..199 and 0..count-1 
                $endRange = [math]::Min(($beginRange + 199),($countIds - 1))
                Write-Progress -Activity "Querying Data" -CurrentOperation "Expanding items $beginRange to $EndRange of $countIDs"
                if ($Query -match "\*") {
                    Get-VSTeamWorkItem -Id $Ids[$beginRange..$endRange] 
                }
                else {
                    Get-VSTeamWorkItem  -Id $Ids[$beginRange..$endRange] -Fields $resp.columns.referenceName 
                }
            }
        }
        Write-Progress -Activity "Querying Data" -Completed
        $resp
    }
}
