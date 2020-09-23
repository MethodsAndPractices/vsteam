function Get-VSTeam {
   [CmdletBinding(DefaultParameterSetName = 'List',
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Get-VSTeam')]
   param (
      [Parameter(ParameterSetName = 'List')]
      [int] $Top,

      [Parameter(ParameterSetName = 'List')]
      [int] $Skip,

      [Parameter(ParameterSetName = 'ByName', Position = 0)]
      [Alias('TeamName')]
      [string[]] $Name,

      [Parameter(ParameterSetName = 'ByID')]
      [Alias('TeamId')]
      [string[]] $Id,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )

   process {
      $commonArgs = @{
         Area     = 'projects'
         Resource = "$ProjectName/teams"
         Version  = $(_getApiVersion Core)
      }

      if ($Id) {
         foreach ($item in $Id) {
            # Call the REST API
            $resp = _callAPI @commonArgs -id $item

            $team = [vsteam_lib.Team]::new($resp, $ProjectName)

            Write-Output $team
         }
      }
      elseif ($Name) {
         foreach ($item in $Name) {
            # Call the REST API
            $resp = _callAPI @commonArgs -id $item

            $team = [vsteam_lib.Team]::new($resp, $ProjectName)

            Write-Output $team
         }
      }
      else {
         # Call the REST API
         $resp = _callAPI @commonArgs `
            -QueryString @{
            '$top'  = $top
            '$skip' = $skip
         }

         $obj = @()

         # Create an instance for each one
         foreach ($item in $resp.value) {
            $obj += [vsteam_lib.Team]::new($item, $ProjectName)
         }

         Write-Output $obj
      }
   }
}