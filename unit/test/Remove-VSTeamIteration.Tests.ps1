Set-StrictMode -Version Latest

Describe 'VSTeamIteration' {
   BeforeAll {
      Import-Module SHiPS

      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamLeaf.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamClassificationNode.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/Remove-VSTeamClassificationNode.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"


      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '5.0-unitTests' } -ParameterFilter { $Service -eq 'Core' }
   }

   Context 'Remove-VSTeamIteration' {
      BeforeAll {
         Mock Invoke-RestMethod {
            #Write-Host $args
            return $null
         }
      }

      It 'should delete iteration' -TestCases @(
      ) {
         ## Act
         Remove-VSTeamIteration -ProjectName "Public Demo" -Force

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Method -eq "Delete" -and
            $Uri -like "https://dev.azure.com/test/Public Demo/_apis/wit/classificationnodes/iterations*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*"
         }
      }

      It 'should delete iteration with reclassification id <ReClassifyId>' -TestCases @(
         @{ReClassifyId = 4 }
      ) {
         param ($ReClassifyId)
         ## Act
         Remove-VSTeamIteration -ProjectName "Public Demo" -ReClassifyId $ReClassifyId -Force

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Method -eq "Delete" -and
            $Uri -like "https://dev.azure.com/test/Public Demo/_apis/wit/classificationnodes/iterations*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*"
         }
      }

      It 'with Path "<Path>" should delete iteration' -TestCases @(
         @{Path = "SubPath" }
         @{Path = "Path/SubPath" }
      ) {
         param ($Path)
         ## Act
         Remove-VSTeamIteration -ProjectName "Public Demo" -Path $Path -Force

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Method -eq "Delete" -and
            $Uri -like "https://dev.azure.com/test/Public Demo/_apis/wit/classificationnodes/iterations/$Path*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*"
         }
      }

      It 'with empty Path "<Path>" should delete iteration' -TestCases @(
         @{Path = "" }
         @{Path = $null }
      ) {
         param ($Path)
         ## Act
         Remove-VSTeamIteration -ProjectName "Public Demo" -Path $Path -Force

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Method -eq "Delete" -and
            $Uri -like "https://dev.azure.com/test/Public Demo/_apis/wit/classificationnodes/iterations?*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*"
         }
      }
   }
}