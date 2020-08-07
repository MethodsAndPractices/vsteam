function Stop-VSTeamBuild {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium")]
   param(
      [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
      [Alias('BuildID')]
      [Int] $Id,
 
      [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
      [ProjectValidateAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      [string] $ProjectName
   )
 
   process {
      if ($pscmdlet.ShouldProcess($Id, "Stop-VSTeamBuild")) {
       
         try {
 
            $body = @{
               "status" = "Cancelling"
            }
 
            $bodyAsJson = $body | ConvertTo-Json -Compress -Depth 50
 
            # Call the REST API
            _callAPI -Method PATCH -ProjectName $ProjectName `
               -Area build `
               -Resource builds `
               -Id $Id `
               -body $bodyAsJson `
               -Version $(_getApiVersion Build) | Out-Null
         }
 
         catch {
            _handleException $_
         }
      }
   }
}