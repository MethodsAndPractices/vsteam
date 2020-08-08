function Add-VSTeamReleaseDefinition {
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $inFile,

      [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )

   process {
      $resp = _callAPI -Method POST -ProjectName $ProjectName -subDomain vsrm `
         -Area release `
         -Resource definitions `
         -inFile $inFile `
         -Version $(_getApiVersion Release)

      Write-Output $resp
   }
}
