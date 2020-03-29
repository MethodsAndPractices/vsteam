Set-StrictMode -Version Latest

#region include
Import-Module SHiPS

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamLeaf.ps1"
. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Classes/VSTeamDescriptor.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Private/applyTypes.ps1"
. "$here/../../Source/Public/$sut"
. "$here/../../Source/Public/Set-VSTeamAPIVersion.ps1"
#endregion

Describe "VSTeamDescriptor" {
   ## Arrange
   $result = Get-Content "$PSScriptRoot\sampleFiles\descriptor.scope.TestProject.json" -Raw | ConvertFrom-Json

   # Mock the call to Get-Projects by the dynamic parameter for ProjectName
   Mock Invoke-RestMethod { return @() } -ParameterFilter { $Uri -like "*_apis/projects*" }


   Context 'Get-VSTeamDescriptor' {
      Context 'Services' {
         ## Arrange
         # You have to set the version or the api-version will not be added when versions = ''
         Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Graph' }

         # Set the account to use for testing. A normal user would do this
         # using the Set-VSTeamAccount function.
         Mock _getInstance { return 'https://dev.azure.com/test' }
         Mock _supportsGraph

         Mock Invoke-RestMethod { return $result }

         It 'by StorageKey Should return groups' {
            ## Act
            Get-VSTeamDescriptor -StorageKey '010d06f0-00d5-472a-bb47-58947c230876'

            ## Assert
            Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -eq "https://vssps.dev.azure.com/test/_apis/graph/descriptors/010d06f0-00d5-472a-bb47-58947c230876?api-version=$(_getApiVersion Graph)"
            }
         }
      }

      Context 'Server' {
         ## Arrange
         # TFS 2017 does not support this feature
         Mock _callAPI { throw 'Should not be called' } -Verifiable

         # It is not supported on 2017
         Mock _getApiVersion { return 'TFS2017' }
         Mock _getApiVersion { return '' } -ParameterFilter { $Service -eq 'Graph' }
         It 'Should throw' {
            ## Act / Assert
            { Get-VSTeamDescriptor -StorageKey '010d06f0-00d5-472a-bb47-58947c230876' } | Should Throw
         }

         It '_callAPI should not be called' {
            Assert-MockCalled _callAPI -Exactly 0
         }
      }
   }
}