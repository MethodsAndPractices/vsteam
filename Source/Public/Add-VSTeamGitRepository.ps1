function Add-VSTeamGitRepository {
   [CmdletBinding()]
   param(
      [parameter(Mandatory = $true)]
      [string] $Name,

      [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )
   process {
      $body = '{"name": "' + $Name + '"}'

      try {
         # Call the REST API
         $resp = _callAPI -ProjectName $ProjectName -Area 'git' -Resource 'repositories' `
            -Method POST -ContentType 'application/json' -Body $body -Version $(_getApiVersion Git)

         # Storing the object before you return it cleaned up the pipeline.
         # When I just write the object from the constructor each property
         # seemed to be written
         $repo = [vsteam_lib.GitRepository]::new($resp, $ProjectName)

         Write-Output $repo
      }
      catch {
         _handleException $_
      }
   }
}
