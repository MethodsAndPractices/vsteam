function Show-VSTeamFeed {
   [CmdletBinding()]
   param(
      [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
      [Alias('ID')]
      [string] $Name
   )

   process {
      _hasAccount

      Show-Browser "$([VSTeamVersions]::Account)/_packaging?feed=$Name&_a=feed"
   }
}