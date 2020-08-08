Set-StrictMode -Version Latest

Describe 'VSTeamClassificationNode' {
   BeforeAll {
      Import-Module SHiPS
      Add-Type -Path "$PSScriptRoot/../../dist/bin/vsteam-lib.dll"
   
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")
   
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamLeaf.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamClassificationNode.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"
   
      # Prime the project cache with an empty list. This will make sure
      # any project name used will pass validation and Get-VSTeamProject 
      # will not need to be called.
      [vsteam_lib.ProjectCache]::Update([string[]]@())

      ## Arrange
      $withoutChildNode = Get-Content "$PSScriptRoot\sampleFiles\withoutChildNode.json" -Raw | ConvertFrom-Json
      $classificationNodeResult = Get-Content "$PSScriptRoot\sampleFiles\classificationNodeResult.json" -Raw | ConvertFrom-Json

      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' }

      Mock _getApiVersion { return '5.0-unitTests' } -ParameterFilter { $Service -eq 'Core' }
   }

   Context 'Get-VSTeamClassificationNode' {
      BeforeAll {
         Mock Invoke-RestMethod { return $classificationNodeResult }
         Mock Invoke-RestMethod { return $withoutChildNode } -ParameterFilter { $Uri -like "*Ids=43,44*" }
      }

      It 'with StructureGroup should return Nodes' {
         ## Act
         Get-VSTeamClassificationNode -ProjectName "Public Demo" -StructureGroup "Iterations"

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/Public Demo/_apis/wit/classificationnodes/Iterations*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*"
         }
      }

      It 'with depth should return Nodes' {
         ## Act
         Get-VSTeamClassificationNode -ProjectName "Public Demo" -StructureGroup "Iterations" -Depth 10

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/Public Demo/_apis/wit/classificationnodes/Iterations*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Uri -like "*`$Depth=10*"
         }
      }

      It 'by Path should return Nodes' {
         ## Act
         Get-VSTeamClassificationNode -ProjectName "Public Demo" -StructureGroup "Iterations" -Path "test/test/test"

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/Public Demo/_apis/wit/classificationnodes/Iterations/test/test/test*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*"
         }
      }

      It 'by ids should return Nodes' {
         ## Act
         Get-VSTeamClassificationNode -ProjectName "Public Demo" -Ids @(1, 2, 3, 4)

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/Public Demo/_apis/wit/classificationnodes*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Uri -like "*Ids=1,2,3,4*"
         }
      }

      It 'should handle when there is no child nodes' {
         ## Act
         Get-VSTeamClassificationNode -ProjectName "Public Demo" -Ids @(43, 44)

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly 1 -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/Public Demo/_apis/wit/classificationnodes*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Uri -like "*Ids=43,44*"
         }
      }
   }
}