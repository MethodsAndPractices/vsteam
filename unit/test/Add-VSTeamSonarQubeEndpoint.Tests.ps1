Set-StrictMode -Version Latest

#region include
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Classes/ProjectCompleter.ps1"
. "$here/../../Source/Classes/ProjectValidateAttribute.ps1"
. "$here/../../Source/Private/applyTypes.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/Add-VSTeamServiceEndpoint.ps1"
. "$here/../../Source/Public/Get-VSTeamServiceEndpoint.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe 'VSTeamSonarQubeEndpoint' {
   Context 'Add-VSTeamSonarQubeEndpoint' {
      Mock _hasProjectCacheExpired { return $false }

      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'ServiceFabricEndpoint' }
         
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

      It 'should not create SonarQube Serviceendpoint' {
         Add-VSTeamSonarQubeEndpoint -projectName 'project' -endpointName 'PM_DonovanBrown' -sonarqubeUrl 'http://mysonarserver.local' -personalAccessToken '00000000-0000-0000-0000-000000000000'

         ## Verify that Write-Error was called
         Assert-VerifiableMock
      }
   }
}