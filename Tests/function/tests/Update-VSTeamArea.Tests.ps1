Set-StrictMode -Version Latest

Describe 'VSTeamArea' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$baseFolder/Source/Public/Update-VSTeamClassificationNode"

      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock Invoke-RestMethod { Open-SampleFile 'classificationNodeResult.json' }
      Mock _getApiVersion { return '5.0-unitTests' } -ParameterFilter { $Service -eq 'Core' }      
   }

   Context 'Update-VSTeamArea' -Tag "Add" {
      It 'area should update Nodes' {
         ## Act
         Update-VSTeamArea -ProjectName "Public Demo" `
            -Name "MyClassificationNodeName" `
            -Path "SubPath" `
            -Force

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/Public Demo/_apis/wit/classificationnodes/areas*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like '*"name":*"MyClassificationNodeName"*'
         }
      }

      It 'with Path "<Path>" should update Nodes' -TestCases @(
         @{ Path = "SubPath" }
         @{ Path = "Path/SubPath" }
      ) {
         param ($Path)
         ## Act
         Update-VSTeamArea -ProjectName "Public Demo" `
            -Name "MyClassificationNodeName" `
            -Path $Path `
            -Force

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/Public Demo/_apis/wit/classificationnodes/areas/$Path*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like '*"name":*"MyClassificationNodeName"*'
         }
      }
   }
}