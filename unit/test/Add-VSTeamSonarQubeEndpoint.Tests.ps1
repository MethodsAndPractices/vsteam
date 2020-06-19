Set-StrictMode -Version Latest

Describe 'VSTeamSonarQubeEndpoint' {
   BeforeAll {
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/Add-VSTeamServiceEndpoint.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamServiceEndpoint.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"
   }
   Context 'Add-VSTeamSonarQubeEndpoint' {
      BeforeAll {
         Mock _hasProjectCacheExpired { return $false }

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
         Add-VSTeamSonarQubeEndpoint -projectName 'project' -endpointName 'PM_DonovanBrown' -sonarqubeUrl 'http://mysonarserver.local' -personalAccessToken '00000000-0000-0000-0000-000000000000'

         ## Verify that Write-Error was called
         Should -InvokeVerifiable
      }
   }
}