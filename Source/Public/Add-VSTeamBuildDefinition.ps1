function Add-VSTeamBuildDefinition {
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $InFile,

      [ProjectValidateAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
      [string] $ProjectName
   )

   process {
      return _callAPI -Method POST -ProjectName $ProjectName `
         -Area build `
         -Resource definitions `
         -infile $InFile `
         -Version $(_getApiVersion Build)
   }
}
