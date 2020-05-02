function Add-VSTeam {
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $true, Position = 1)]
      [Alias('TeamName')]
      [string] $Name,

      [string] $Description = '',
      
      [ProjectValidateAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
      [string] $ProjectName
   )
   process {
      $body = '{ "name": "' + $Name + '", "description": "' + $Description + '" }'

      # Call the REST API
      $resp = _callAPI -Area 'projects' -Resource "$ProjectName/teams" -NoProject `
         -Method Post -ContentType 'application/json' -Body $body -Version $(_getApiVersion Core)

      $team = [VSTeamTeam]::new($resp, $ProjectName)

      Write-Output $team
   }
}
