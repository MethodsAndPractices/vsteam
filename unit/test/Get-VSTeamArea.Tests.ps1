Set-StrictMode -Version Latest

BeforeAll {
   Import-Module SHiPS

   $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

   . "$PSScriptRoot/../../Source/Classes/VSTeamLeaf.ps1"
   . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
   . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
   . "$PSScriptRoot/../../Source/Classes/ProjectCompleter.ps1"
   . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
   . "$PSScriptRoot/../../Source/Classes/VSTeamClassificationNode.ps1"
   . "$PSScriptRoot/../../Source/Public/Get-VSTeamClassificationNode"
   . "$PSScriptRoot/../../Source/Private/common.ps1"
   . "$PSScriptRoot/../../Source/Public/$sut"
}

Describe 'Get-VSTeamArea' {
   BeforeAll {
      $classificationNodeResult = Get-Content "$PSScriptRoot\sampleFiles\classificationNodeResult.json" -Raw | ConvertFrom-Json

      # Make sure the project name is valid. By returning an empty array
      # all project names are valid. Otherwise, you name you pass for the
      # project in your commands must appear in the list.
      Mock _getProjects { return @() }
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '5.0-unitTests' } -ParameterFilter { $Service -eq 'Core' }
   }

   Context 'simplest call' {
      BeforeAll {
         Mock Invoke-RestMethod { return $classificationNodeResult }
      }

      It 'by path and depth should return areas' {
         ## Act
         Get-VSTeamArea -ProjectName "Public Demo" -Depth 5 -Path "test/test/test"

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/Public Demo/_apis/wit/classificationnodes/areas/test/test/test*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Uri -like "*`$Depth=5*"
         }
      }

      It 'by Ids and depth should return areas' {
         ## Act
         Get-VSTeamArea -ProjectName "Public Demo" -Ids @(1, 2, 3, 4) -Depth 5

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/Public Demo/_apis/wit/classificationnodes*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Uri -like "*Ids=1,2,3,4*" -and
            $Uri -like "*`$Depth=5*"
         }
      }
   }
}