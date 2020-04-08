function Add-VSTeamBuildDefinition {
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $InFile,

      [Parameter(Mandatory = $true, Position = 0)]
      [ValidateProjectAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      [string] $ProjectName
   )

   process {
      return _callAPI -Method Post -ProjectName $ProjectName -Area build -Resource definitions -Version $(_getApiVersion Build) -infile $InFile -ContentType 'application/json'
   }
}
