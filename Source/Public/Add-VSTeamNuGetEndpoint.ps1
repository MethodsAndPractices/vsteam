function Add-VSTeamNuGetEndpoint {
   [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingPlainTextForPassword", "")]
   [CmdletBinding(DefaultParameterSetName = 'SecureApiKey')]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $EndpointName,
      
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $NuGetUrl,
      
      [Parameter(ParameterSetName = 'ClearToken', Mandatory = $true, HelpMessage = 'Personal Access Token')]
      [string] $PersonalAccessToken,
      
      [Parameter(ParameterSetName = 'ClearApiKey', Mandatory = $true, HelpMessage = 'ApiKey')]
      [string] $ApiKey,
      
      [Parameter(ParameterSetName = 'SecurePassword', Mandatory = $true, HelpMessage = 'Username')]
      [string] $Username,
      
      [Parameter(ParameterSetName = 'SecureToken', Mandatory = $true, HelpMessage = 'Personal Access Token')]
      [securestring] $SecurePersonalAccessToken,
      
      [Parameter(ParameterSetName = 'SecureApiKey', Mandatory = $true, HelpMessage = 'ApiKey')]
      [securestring] $SecureApiKey,
      
      [Parameter(ParameterSetName = 'SecurePassword', Mandatory = $true, HelpMessage = 'Password')]
      [securestring] $SecurePassword,
        
      [ProjectValidateAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
      [string] $ProjectName
   )
   
   process {
      if ($PersonalAccessToken) {
         $Authentication = 'Token'
         $token = $PersonalAccessToken
      }
      elseif ($ApiKey) {
         $Authentication = 'ApiKey'
         $token = $ApiKey
      }
      elseif ($SecureApiKey) {
         $Authentication = 'ApiKey'
         $credential = New-Object System.Management.Automation.PSCredential "ApiKey", $SecureApiKey
         $token = $credential.GetNetworkCredential().Password
      }
      elseif ($SecurePassword) {
         $Authentication = 'UsernamePassword'
         $credential = New-Object System.Management.Automation.PSCredential "Password", $SecurePassword
         $token = $credential.GetNetworkCredential().Password
      }
      else {
         $Authentication = 'Token'
         $credential = New-Object System.Management.Automation.PSCredential "token", $securePersonalAccessToken
         $token = $credential.GetNetworkCredential().Password
      }

      $obj = @{
         data = @{ }
         url  = $NuGetUrl
      }

      if ($Authentication -eq 'ApiKey') {
         $obj['authorization'] = @{
            parameters = @{
               nugetkey = $token
            }
            scheme     = 'None'
         }
      }
      elseif ($Authentication -eq 'Token') {
         $obj['authorization'] = @{
            parameters = @{
               apitoken = $token
            }
            scheme     = 'Token'
         }
      }
      else {
         $obj['authorization'] = @{
            parameters = @{
               username = $Username
               password = $token
            }
            scheme     = 'UsernamePassword'
         }
      }

      return Add-VSTeamServiceEndpoint `
         -ProjectName $ProjectName `
         -endpointName $endpointName `
         -endpointType 'externalnugetfeed' `
         -object $obj
   }
}
