function Get-VSTeamPolicy {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [int[]] $Id,
        [Parameter(Mandatory=$true, Position = 0 )]
        [ValidateProjectAttribute()]
        [ArgumentCompleter([ProjectCompleter])]
        $ProjectName
    )
    process {
                if ($id) {
            foreach ($item in $id) {
               try {
                  $resp = _callAPI -ProjectName $ProjectName -Id $item -Area policy -Resource configurations -Version $(_getApiVersion Git)
                  $resp.PSObject.TypeNames.Insert(0, 'Team.Policy')
                  Write-Output $resp
               }
               catch {
                  throw $_
               }
            }
        }
        else {
            try {
               $resp = _callAPI -ProjectName $ProjectName -Area policy -Resource configurations -Version $(_getApiVersion Git)
               # Apply a Type Name so we can use custom format view and custom type extensions
               foreach ($item in $resp.value) {
                  $item.PSObject.TypeNames.Insert(0, 'Team.Policy')
               }
               Write-Output $resp.value
            }
            catch {
                throw $_
            }
        }
    }
}
