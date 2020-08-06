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
      $resp = _callAPI -Method Post -ProjectName $ProjectName -subDomain vsrm `
         -Area release `
         -Resource definitions `
         -inFile $inFile `
         -Version $(_getApiVersion Release)

      Write-Output $resp
   }
}
