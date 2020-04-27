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

Describe 'Add-VSTeamClassificationNode' {

   $classificationNodeResult = Get-Content "$PSScriptRoot\sampleFiles\classificationNodeResult.json" -Raw | ConvertFrom-Json


   Mock _getInstance { return 'https://dev.azure.com/test' }
   Mock _getApiVersion { return '5.0-unitTests' } -ParameterFilter { $Service -eq 'Core' }

   Context 'simplest call' {
      Mock Invoke-RestMethod {
         #Write-Host $args
         return $classificationNodeResult 
      }      

      It 'with StructureGroup "<StructureGroup>" should return Nodes' -TestCases @(
         @{StructureGroup = "areas" }
         @{StructureGroup = "iterations" }
     ) {
         param ($StructureGroup)      
         ## Act
         Add-VSTeamClassificationNode -ProjectName "Public Demo" -StructureGroup $StructureGroup -Name "MyClassificationNodeName"
         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
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
         Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
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
         Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/Public Demo/_apis/wit/classificationnodes/$StructureGroup?*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like '*"name":*"MyClassificationNodeName"*'
         }
      }
   }
}