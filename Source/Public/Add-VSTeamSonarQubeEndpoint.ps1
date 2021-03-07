# Create a service endpoint.
#
# Get-VSTeamOption 'distributedtask' 'serviceendpoints'
# id              : dca61d2f-3444-410a-b5ec-db2fc4efb4c5
# area            : distributedtask
# resourceName    : serviceendpoints
# routeTemplate   : {project}/_apis/{area}/{resource}/{endpointId}
# https://bit.ly/Add-VSTeamServiceEndpoint

function Add-VSTeamSonarQubeEndpoint {
   [CmdletBinding(DefaultParameterSetName = 'Secure',
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Add-VSTeamSonarQubeEndpoint')]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $endpointName,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $sonarqubeUrl,

      [parameter(ParameterSetName = 'Plain', Mandatory = $true, Position = 2, HelpMessage = 'Personal Access Token')]
      [string] $personalAccessToken,

      [parameter(ParameterSetName = 'Secure', Mandatory = $true, HelpMessage = 'Personal Access Token')]
      [securestring] $securePersonalAccessToken,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )
   process {
      if ($personalAccessToken) {
         $token = $personalAccessToken
      }
      else {
         $credential = New-Object System.Management.Automation.PSCredential "nologin", $securePersonalAccessToken
         $token = $credential.GetNetworkCredential().Password
      }

      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters['ProjectName']

      $obj = @{
         authorization = @{
            parameters = @{
               username = $token;
               password = ''
            };
            scheme     = 'UsernamePassword'
         };
         data          = @{ };
         url           = $sonarqubeUrl
      }

      try {
         return Add-VSTeamServiceEndpoint -ProjectName $ProjectName `
            -endpointName $endpointName `
            -endpointType sonarqube `
            -object $obj
      }
      catch [System.Net.WebException] {
         if ($_.Exception.status -eq 'ProtocolError') {
            $errorDetails = ConvertFrom-Json $_.ErrorDetails
            $message = $errorDetails.message

            # The error message is different on TFS and VSTS
            if ($message.StartsWith("Endpoint type couldn't be recognized 'sonarqube'") -or
               $message.StartsWith("Unable to find service endpoint type 'sonarqube'")) {
               Write-Error -Message 'The Sonarqube extension not installed. Please install from https://marketplace.visualstudio.com/items?itemName=SonarSource.sonarqube'
               return
            }
         }

         throw
      }
   }
}