function Add-VSTeamReleaseDefinition {
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $inFile,

      [ProjectValidateAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
      [string] $ProjectName
   )
   
   process {
      $resp = _callAPI -Method Post -subDomain vsrm -Area release -Resource definitions -ProjectName $ProjectName `
         -Version $(_getApiVersion Release) -inFile $inFile -ContentType 'application/json'

      Write-Output $resp
   }
}
