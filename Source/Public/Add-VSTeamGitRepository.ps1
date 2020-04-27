function Add-VSTeamGitRepository {
   [CmdletBinding()]
   param(
      [parameter(Mandatory = $true)]
      [string] $Name,

      [ProjectValidateAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
      [string] $ProjectName
   )
   process {
      $body = '{"name": "' + $Name + '"}'

      try {
         # Call the REST API
         $resp = _callAPI -ProjectName $ProjectName -Area 'git' -Resource 'repositories' `
            -Method Post -ContentType 'application/json' -Body $body -Version $(_getApiVersion Git)

         # Storing the object before you return it cleaned up the pipeline.
         # When I just write the object from the constructor each property
         # seemed to be written
         $repo = [VSTeamGitRepository]::new($resp, $ProjectName)

         Write-Output $repo
      }
      catch {
         _handleException $_
      }
   }
}
