Set-StrictMode -Version Latest

Describe 'VSTeamIteration' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath      
      . "$baseFolder/Source/Public/Update-VSTeamClassificationNode"

      ## Arrange
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock Invoke-RestMethod { Open-SampleFile 'classificationNodeResult.json' }
      Mock _getApiVersion { return '5.0-unitTests' } -ParameterFilter { $Service -eq 'Core' }
   }

   Context 'Update-VSTeamIteration' {
      It 'iteration should return Nodes' {
         ## Act
         Update-VSTeamIteration -ProjectName "Public Demo" `
            -Name "MyClassificationNodeName" `
            -Path "SubPath"
            -Force

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/Public Demo/_apis/wit/classificationnodes/iterations*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like '*"name":*"MyClassificationNodeName"*'
         }
      }

      It 'with Path "<Path>" should return Nodes' -TestCases @(
         @{ Path = 'SubPath' }
         @{ Path = 'Path/SubPath'; StartDate = '2014-10-27T00:00:00Z'; FinishDate = '2014-10-31T00:00:00Z' }
      ) {
         param ($Path)
         ## Act
         Update-VSTeamIteration -ProjectName "Public Demo" `
            -Name "MyClassificationNodeName" `
            -Path $Path
            -Force

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/Public Demo/_apis/wit/classificationnodes/iterations/$Path*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like '*"name":*"MyClassificationNodeName"*'
         }
      }
   }
}
