# Create a team in a team project.
#
# Get-VSTeamOption 'core' 'teams'
# id              : d30a3dd1-f8ba-442a-b86a-bd0c0c383e59
# area            : core
# resourceName    : teams
# routeTemplate   : _apis/projects/{projectId}/{resource}/{*teamId}
# https://bit.ly/Add-VSTeam

function Add-VSTeam {
   [CmdletBinding(HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Add-VSTeam')]
   param(
      [Parameter(Mandatory = $true, Position = 0)]
      [Alias('TeamName')]
      [string] $Name,

      [Parameter(Position = 1)]
      [string] $Description = '',

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )
   process {
      $body = '{ "name": "' + $Name + '", "description": "' + $Description + '" }'

      $resp = _callAPI -Method POST -NoProject `
         -Resource "projects/$ProjectName/teams" `
         -Body $body `
         -Version $(_getApiVersion Core)

      $team = [vsteam_lib.Team]::new($resp, $ProjectName)

      Write-Output $team
   }
}
