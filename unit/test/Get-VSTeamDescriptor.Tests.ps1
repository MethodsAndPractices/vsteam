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

   Context 'Get-VSTeamDescriptor' {
      Context 'Services' {
         ## Arrange
         # You have to set the version or the api-version will not be added when versions = ''
         [VSTeamVersions]::Graph = '5.0'
      
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
               $Uri -eq "https://vssps.dev.azure.com/test/_apis/graph/descriptors/010d06f0-00d5-472a-bb47-58947c230876?api-version=$([VSTeamVersions]::Graph)"
            }
         }
      }
      
      Context 'Server' {
         ## Arrange
         # TFS 2017 does not support this feature
         Mock _callAPI { throw 'Should not be called' } -Verifiable

         It 'Should throw' {
            ## Arrange
            Set-VSTeamAPIVersion TFS2017

            ## Act / Assert
            { Get-VSTeamDescriptor -StorageKey '010d06f0-00d5-472a-bb47-58947c230876' } | Should Throw
         }

         It '_callAPI should not be called' {
            Assert-MockCalled _callAPI -Exactly 0
         }
      }
   }
}