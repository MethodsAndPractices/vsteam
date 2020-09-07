Set-StrictMode -Version Latest

Describe 'VSTeamClassificationNode' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '5.0-unitTests' } -ParameterFilter { $Service -eq 'Core' }
   }

   Context 'Add-VSTeamClassificationNode' {
      ## Arrange
      BeforeAll {
         Mock Invoke-RestMethod { Open-SampleFile 'classificationNodeResult.json' }
      }

      It 'should return Nodes with StructureGroup "<StructureGroup>"' -TestCases @(
         @{ StructureGroup = "areas" }
         @{ StructureGroup = "iterations" }
      ) {
         param ($StructureGroup)
         ## Act
         Add-VSTeamClassificationNode -ProjectName "Public Demo" `
            -StructureGroup $StructureGroup `
            -Name "MyClassificationNodeName"

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/Public Demo/_apis/wit/classificationnodes/$StructureGroup*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like '*"name":*"MyClassificationNodeName"*'
         }
      }

      It 'should return Nodes with StructureGroup "<StructureGroup>" by Path "<Path>"' -TestCases @(
         @{ StructureGroup = "areas"; Path = "SubPath" }
         @{ StructureGroup = "areas"; Path = "Path/SubPath" }
         @{ StructureGroup = "iterations"; Path = "SubPath" }
         @{ StructureGroup = "iterations"; Path = "Path/SubPath" }
      ) {
         param ($StructureGroup, $Path)
         ## Act
         Add-VSTeamClassificationNode -ProjectName "Public Demo" `
            -StructureGroup $StructureGroup `
            -Name "MyClassificationNodeName" `
            -Path $Path

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/Public Demo/_apis/wit/classificationnodes/$StructureGroup/$Path*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like '*"name":*"MyClassificationNodeName"*'
         }
      }

      It 'should return Nodes with StructureGroup "<StructureGroup>" by empty Path "<Path>"' -TestCases @(
         @{ StructureGroup = "areas"; Path = "" }
         @{ StructureGroup = "areas"; Path = $null }
         @{ StructureGroup = "iterations"; Path = "" }
         @{ StructureGroup = "iterations"; Path = $null }
      ) {
         param ($StructureGroup, $Path)
         ## Act
         Add-VSTeamClassificationNode -ProjectName "Public Demo" `
            -StructureGroup $StructureGroup `
            -Name "MyClassificationNodeName" `
            -Path $Path

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/Public Demo/_apis/wit/classificationnodes/$StructureGroup?*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like '*"name":*"MyClassificationNodeName"*'
         }
      }
   }
}