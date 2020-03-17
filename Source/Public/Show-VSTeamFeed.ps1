function Show-VSTeamFeed {
   [CmdletBinding()]
   param(
      [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
      [Alias('ID')]
      [string] $Name
   )

   process {
      _hasAccount

      Show-Browser "$(_getInstance)/_packaging?feed=$Name&_a=feed"
   }
}