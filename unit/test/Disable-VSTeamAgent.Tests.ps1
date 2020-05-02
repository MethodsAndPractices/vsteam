Set-StrictMode -Version Latest

#region include
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Classes/ProjectValidateAttribute.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe 'VSTeamAgent' {
   Context 'Disable-VSTeamAgent' {
      ## Arrange
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'DistributedTask' }

      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod -ParameterFilter { $Uri -like "*950*" }
      Mock Invoke-RestMethod { throw 'boom' } -ParameterFilter { $Uri -like "*101*" }

      It 'should throw' {
         ## Act / Assert
         { Disable-VSTeamAgent -Pool 36 -Id 101 } | Should Throw
      }

      It 'by Id should disable the agent with passed in Id' {
         ## Act
         Disable-VSTeamAgent -Pool 36 -Id 950

         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            # The write-host below is great for seeing how many ways the mock is called.
            # Write-Host "Assert Mock $Uri"
            $Method -eq 'Patch' -and
            $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/pools/36/agents/950?api-version=$(_getApiVersion DistributedTask)"
         }
      }
   }
}