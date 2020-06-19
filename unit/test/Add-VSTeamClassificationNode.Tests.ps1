Set-StrictMode -Version Latest

Describe 'VSTeamClassificationNode' {
   BeforeAll {
      Import-Module SHiPS

      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamLeaf.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamClassificationNode.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"

      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '5.0-unitTests' } -ParameterFilter { $Service -eq 'Core' }
   }

   Context 'Add-VSTeamClassificationNode' {
      ## Arrange
      BeforeAll {
         $classificationNodeResult = Get-Content "$PSScriptRoot\sampleFiles\classificationNodeResult.json" -Raw | ConvertFrom-Json

         Mock Invoke-RestMethod { return $classificationNodeResult }
      }

      It 'with StructureGroup "<StructureGroup>" should return Nodes' -TestCases @(
         @{StructureGroup = "areas" }
         @{StructureGroup = "iterations" }
      ) {
         param ($StructureGroup)
         ## Act
         Add-VSTeamClassificationNode -ProjectName "Public Demo" -StructureGroup $StructureGroup -Name "MyClassificationNodeName"

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/Public Demo/_apis/wit/classificationnodes/$StructureGroup*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like '*"name":*"MyClassificationNodeName"*'
         }
      }

      It 'with StructureGroup "<StructureGroup>" by Path "<Path>" should return Nodes' -TestCases @(
         @{StructureGroup = "areas"; Path = "SubPath" }
         @{StructureGroup = "areas"; Path = "Path/SubPath" }
         @{StructureGroup = "iterations"; Path = "SubPath" }
         @{StructureGroup = "iterations"; Path = "Path/SubPath" }
      ) {
         param ($StructureGroup, $Path)
         ## Act
         Add-VSTeamClassificationNode -ProjectName "Public Demo" -StructureGroup $StructureGroup -Name "MyClassificationNodeName" -Path $Path

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/Public Demo/_apis/wit/classificationnodes/$StructureGroup/$Path*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like '*"name":*"MyClassificationNodeName"*'
         }
      }

      It 'with StructureGroup "<StructureGroup>" by empty Path "<Path>" should return Nodes' -TestCases @(
         @{StructureGroup = "areas"; Path = "" }
         @{StructureGroup = "areas"; Path = $null }
         @{StructureGroup = "iterations"; Path = "" }
         @{StructureGroup = "iterations"; Path = $null }
      ) {
         param ($StructureGroup, $Path)
         ## Act
         Add-VSTeamClassificationNode -ProjectName "Public Demo" -StructureGroup $StructureGroup -Name "MyClassificationNodeName" -Path $Path

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/Public Demo/_apis/wit/classificationnodes/$StructureGroup?*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like '*"name":*"MyClassificationNodeName"*'
         }
      }
   }
}