Set-StrictMode -Version Latest

Import-Module SHiPS

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamLeaf.ps1"
. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Classes/VSTeamClassificationNode.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/$sut"

$withoutChildNode = Get-Content "$PSScriptRoot\sampleFiles\withoutChildNode.json" -Raw | ConvertFrom-Json
$classificationNodeResult = Get-Content "$PSScriptRoot\sampleFiles\classificationNodeResult.json" -Raw | ConvertFrom-Json
  
Describe 'Get-VSTeamClassificationNode' {
   # Set the account to use for testing. A normal user would do this
   # using the Set-VSTeamAccount function.
   Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable

   # Mock the call to Get-Projects by the dynamic parameter for ProjectName
   Mock Invoke-RestMethod { return @() } -ParameterFilter {
      $Uri -like "*_apis/projects*"
   }
   
   # You have to set the version or the api-version will not be added when
   # [VSTeamVersions]::Core = ''
   [VSTeamVersions]::Core = '5.0'

   Context 'simplest call' {
      Mock Invoke-RestMethod {
         # If this test fails uncomment the line below to see how the mock was called.
         # Write-Host $args

         return $classificationNodeResult
      } -Verifiable

      Get-VSTeamClassificationNode -ProjectName "Public Demo" -StructureGroup "Iterations"

      It 'Should return Nodes' {
         Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/Public Demo/_apis/wit/classificationnodes/Iterations*" -and
            $Uri -like "*api-version=$([VSTeamVersions]::Core)*"
         }
      }
   }

   Context 'with Depth' {
      Mock Invoke-RestMethod { return $classificationNodeResult } -Verifiable

      Get-VSTeamClassificationNode -ProjectName "Public Demo" -StructureGroup "Iterations" -Depth 10

      It 'Should return Nodes' {
         Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/Public Demo/_apis/wit/classificationnodes/Iterations*" -and
            $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
            $Uri -like "*`$Depth=10*"
         }
      }
   }

   Context 'by Path' {
      Mock Invoke-RestMethod { return $classificationNodeResult } -Verifiable

      Get-VSTeamClassificationNode -ProjectName "Public Demo" -StructureGroup "Iterations" -Path "test/test/test"

      It 'Should return Nodes' {
         Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/Public Demo/_apis/wit/classificationnodes/Iterations/test/test/test*" -and
            $Uri -like "*api-version=$([VSTeamVersions]::Core)*"
         }
      }
   }

   Context 'by Ids' {
      Mock Invoke-RestMethod { return $classificationNodeResult } -Verifiable

      Get-VSTeamClassificationNode -ProjectName "Public Demo" -Ids @(1, 2, 3, 4)

      It 'Should return Nodes' {
         Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/Public Demo/_apis/wit/classificationnodes*" -and
            $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
            $Uri -like "*Ids=1,2,3,4*"
         }
      }
   }

   Context 'by Ids returns no child node' {
      Mock Invoke-RestMethod { return $withoutChildNode } -Verifiable

      Get-VSTeamClassificationNode -ProjectName "Public Demo" -Ids @(43, 44)

      It 'Should return Nodes' {
         Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/Public Demo/_apis/wit/classificationnodes*" -and
            $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
            $Uri -like "*Ids=43,44*"
         }
      }
   }

   Context 'throws' {
      Mock Invoke-RestMethod { throw 'Error' }

      It 'Should throw' {
         { Get-VSTeamClassificationNode -ProjectName "test" -StructureGroup "Areas" } | Should Throw
      }
   }

   Context 'with Depth throws' {
      Mock Invoke-RestMethod { throw 'Error' }

      It 'Should throw' {
         { Get-VSTeamClassificationNode -ProjectName "test" -StructureGroup "Areas" -Depth 12 } | Should Throw
      }
   }
}