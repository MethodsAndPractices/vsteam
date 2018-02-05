Set-StrictMode -Version Latest

Get-Module VSTeam | Remove-Module -Force
Import-Module $PSScriptRoot\..\..\src\team.psm1 -Force
Import-Module $PSScriptRoot\..\..\src\serviceendpointTypes.psm1 -Force

InModuleScope serviceendpointTypes {
   $VSTeamVersionTable.Account = 'https://test.visualstudio.com'

   Describe 'serviceendpointTypes' {
      Context 'Get-VSTeamServiceEndpointTypes' {
         Mock Invoke-RestMethod {
            return @{
               value = @{
                  inputDescriptors      = ""
                  authenticationSchemes = ""
                  dataSources           = "                        "
                  name                  = "externaltfs"
                  displayName           = "Team Foundation Server/Team Services"
                  description           = "Service Endpoint type for all External TFS connections"
                  endpointUrl           = @{
                     displayName = " Connection Url"
                     helpText    = "Url of the VSTS account or the TFS Team Project Collection to connect to."
                  }
                  helpMarkDown          = '\u003ca href=\"https://msdn.microsoft.com/Library/vs/alm/Release/author-release-definition/understanding-tasks#serviceconnections\" target=_blank\u003e\u003cb\u003eLearn More\u003c/b\u003e\u003c/a\u003e'
                  iconUrl               = "https://loecda.visualstudio.com/_apis/public/Extensions/ms.vss-endpoint/16.127.0.1155724572/Assets/Microsoft.VisualStudio.Services.Icons.Default"
               }
            }}

         It 'Should return all service endpoints types' {
            Get-VSTeamServiceEndpointType

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/_apis/distributedtask/serviceendpointtypes/?api-version=$($VSTeamVersionTable.DistributedTask)"
            }
         }
      }
   }
}