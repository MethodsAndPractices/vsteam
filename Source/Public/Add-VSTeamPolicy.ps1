# Adds a new policy to the specified project.
#
# Get-VSTeamOption 'policy' 'configurations'
# id              : dad91cbe-d183-45f8-9c6e-9c1164472121
# area            : policy
# resourceName    : configurations
# routeTemplate   : {project}/_apis/{area}/{resource}/{configurationId}
# http://bit.ly/Add-VSTeamPolicy

function Add-VSTeamPolicy {
   [CmdletBinding(HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Add-VSTeamPolicy')]
   param(
      [Parameter(Mandatory = $true)]
      [guid] $type,

      [switch] $enabled,

      [switch] $blocking,

      [Parameter(Mandatory = $true)]
      [hashtable] $settings,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )
   process {
      $body = @{
         isEnabled  = $enabled.IsPresent;
         isBlocking = $blocking.IsPresent;
         type       = @{
            id = $type
         };
         settings   = $settings
      } | ConvertTo-Json -Depth 10 -Compress

      try {
         # Call the REST API
         $resp = _callAPI -Method POST -ProjectName $ProjectName `
            -Area "policy" `
            -Resource "configurations" `
            -Body $body `
            -Version $(_getApiVersion Policy)

         Write-Output $resp
      }
      catch {
         _handleException $_
      }
   }
}
