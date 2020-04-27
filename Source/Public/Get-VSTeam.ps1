function Get-VSTeam {
   [CmdletBinding(DefaultParameterSetName = 'List')]
   param (
      [Parameter(ParameterSetName = 'List')]
      [int] $Top,

      [Parameter(ParameterSetName = 'List')]
      [int] $Skip,

      [Parameter(ParameterSetName = 'ByID')]
      [Alias('TeamId')]
      [string[]] $Id,

      [Parameter(ParameterSetName = 'ByName')]
      [Alias('TeamName')]
      [string[]] $Name,

      [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
      [ProjectValidateAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      [string] $ProjectName
   )

   process {
      if ($Id) {
         foreach ($item in $Id) {
            # Call the REST API
            $resp = _callAPI -Area 'projects' -Resource "$ProjectName/teams" -id $item `
               -Version $(_getApiVersion Core)

            $team = [VSTeamTeam]::new($resp, $ProjectName)

            Write-Output $team
         }
      }
      elseif ($Name) {
         foreach ($item in $Name) {
            # Call the REST API
            $resp = _callAPI -Area 'projects' -Resource "$ProjectName/teams" -id $item `
               -Version $(_getApiVersion Core)

            $team = [VSTeamTeam]::new($resp, $ProjectName)

            Write-Output $team
         }
      }
      else {
         # Call the REST API
         $resp = _callAPI -Area 'projects' -Resource "$ProjectName/teams" `
            -Version $(_getApiVersion Core) `
            -QueryString @{
            '$top'  = $top
            '$skip' = $skip
         }

         $obj = @()

         # Create an instance for each one
         foreach ($item in $resp.value) {
            $obj += [VSTeamTeam]::new($item, $ProjectName)
         }

         Write-Output $obj
      }
   }
}