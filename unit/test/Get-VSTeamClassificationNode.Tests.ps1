Set-StrictMode -Version Latest

#region include
Import-Module SHiPS

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamLeaf.ps1"
. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Classes/VSTeamClassificationNode.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe 'Get-VSTeamClassificationNode' {
   # You have to set the version or the api-version will not be added when versions = ''
   [VSTeamVersions]::Core = '5.0'

   $withoutChildNode = Get-Content "$PSScriptRoot\sampleFiles\withoutChildNode.json" -Raw | ConvertFrom-Json
   $classificationNodeResult = Get-Content "$PSScriptRoot\sampleFiles\classificationNodeResult.json" -Raw | ConvertFrom-Json

   # Set the account to use for testing. A normal user would do this
   # using the Set-VSTeamAccount function.
   Mock _getInstance { return 'https://dev.azure.com/test' }
   
   # Mock the call to Get-Projects by the dynamic parameter for ProjectName
   Mock Invoke-RestMethod { return @() } -ParameterFilter { $Uri -like "*_apis/projects*" }

   Context 'simplest call' {
      Mock Invoke-RestMethod { return $classificationNodeResult }
      Mock Invoke-RestMethod { return $withoutChildNode } -ParameterFilter { $Uri -like "*Ids=43,44*" }

      It 'with StructureGroup should return Nodes' {
         ## Act
         Get-VSTeamClassificationNode -ProjectName "Public Demo" -StructureGroup "Iterations"

         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/Public Demo/_apis/wit/classificationnodes/Iterations*" -and
            $Uri -like "*api-version=$([VSTeamVersions]::Core)*"
         }
      }

      It 'with depth should return Nodes' {
         ## Act
         Get-VSTeamClassificationNode -ProjectName "Public Demo" -StructureGroup "Iterations" -Depth 10

         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/Public Demo/_apis/wit/classificationnodes/Iterations*" -and
            $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
            $Uri -like "*`$Depth=10*"
         }
      }

      It 'by Path should return Nodes' {
         ## Act
         Get-VSTeamClassificationNode -ProjectName "Public Demo" -StructureGroup "Iterations" -Path "test/test/test"

         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/Public Demo/_apis/wit/classificationnodes/Iterations/test/test/test*" -and
            $Uri -like "*api-version=$([VSTeamVersions]::Core)*"
         }
      }

      It 'by ids should return Nodes' {
         ## Act
         Get-VSTeamClassificationNode -ProjectName "Public Demo" -Ids @(1, 2, 3, 4)

         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/Public Demo/_apis/wit/classificationnodes*" -and
            $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
            $Uri -like "*Ids=1,2,3,4*"
         }
      }

      It 'should handle when there is no child nodes' {
         ## Act
         Get-VSTeamClassificationNode -ProjectName "Public Demo" -Ids @(43, 44)

         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/Public Demo/_apis/wit/classificationnodes*" -and
            $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
            $Uri -like "*Ids=43,44*"
         }
      }
   }
}