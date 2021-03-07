Set-StrictMode -Version Latest

Describe 'VSTeamSonarQubeEndpoint' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$baseFolder/Source/Public/Add-VSTeamServiceEndpoint.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamServiceEndpoint.ps1"
   }
   
   Context 'Add-VSTeamSonarQubeEndpoint' {
      BeforeAll {
         Mock _getInstance { return 'https://dev.azure.com/test' }
         Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'ServiceEndpoints' }

         Mock Write-Warning
         Mock Write-Error -Verifiable
         Mock Invoke-RestMethod {
            $e = [System.Management.Automation.ErrorRecord]::new(
               [System.Net.WebException]::new("Endpoint type couldn't be recognized 'sonarqube'", [System.Net.WebExceptionStatus]::ProtocolError),
               "Endpoint type couldn't be recognized 'sonarqube'",
               [System.Management.Automation.ErrorCategory]::ProtocolError,
               $null)

            # The error message is different on TFS and VSTS
            $msg = ConvertTo-Json @{
               '$id'   = 1
               message = "Unable to find service endpoint type 'sonarqube' using authentication scheme 'UsernamePassword'."
            }

            $e.ErrorDetails = [System.Management.Automation.ErrorDetails]::new($msg)

            $PSCmdlet.ThrowTerminatingError($e)
         }
      }

      It 'should not create SonarQube Serviceendpoint' {
         Add-VSTeamSonarQubeEndpoint -projectName 'project' `
            -endpointName 'PM_DonovanBrown' `
            -sonarqubeUrl 'http://mysonarserver.local' `
            -personalAccessToken '00000000-0000-0000-0000-000000000000'

         ## Verify that Write-Error was called
         Should -InvokeVerifiable
      }
   }
}