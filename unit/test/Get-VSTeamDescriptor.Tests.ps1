Set-StrictMode -Version Latest

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

$result = Get-Content "$PSScriptRoot\sampleFiles\descriptor.scope.TestProject.json" -Raw | ConvertFrom-Json

Describe "Get-VSTeamDescriptor" {
   Context 'throws' {
      Mock _callAPI { throw 'Should not be called' } -Verifiable

      It 'Should throw' {
         Set-VSTeamAPIVersion TFS2017

         { Get-VSTeamDescriptor -StorageKey '010d06f0-00d5-472a-bb47-58947c230876' } | Should Throw
      }

      It '_callAPI should not be called' {
         Assert-MockCalled _callAPI -Exactly 0
      }
   }
}

Describe 'Get-VSTeamDescriptor' {
   # Set the account to use for testing. A normal user would do this
   # using the Set-VSTeamAccount function.
   Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable

   # You have to set the version or the api-version will not be added when
   [VSTeamVersions]::Graph = '5.0'

   Context 'by StorageKey' {
      Mock Invoke-RestMethod {
         # If this test fails uncomment the line below to see how the mock was called.
         # Write-Host $args

         return $result
      } -Verifiable

      Get-VSTeamDescriptor -StorageKey '010d06f0-00d5-472a-bb47-58947c230876'

      It 'Should return groups' {
         Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
            $Uri -eq "https://vssps.dev.azure.com/test/_apis/graph/descriptors/010d06f0-00d5-472a-bb47-58947c230876?api-version=$([VSTeamVersions]::Graph)"
         }
      }
   }

   Context 'by StorageKey throws' {
      Mock Invoke-RestMethod { throw 'Error' }

      It 'Should throw' {
         { Get-VSTeamDescriptor -StorageKey Demo } | Should Throw
      }
   }
}