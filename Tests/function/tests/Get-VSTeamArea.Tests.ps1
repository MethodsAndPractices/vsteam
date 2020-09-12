Set-StrictMode -Version Latest

Describe 'VSTeamArea' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$baseFolder/Source/Public/Get-VSTeamClassificationNode"
      
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '5.0-unitTests' } -ParameterFilter { $Service -eq 'Core' }
      Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamClassificationNode.json' -Index 0 }
   }

   Context 'Get-VSTeamArea' {
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
         Get-VSTeamArea -ProjectName "Public Demo" -Id @(1, 2, 3, 4) -Depth 5

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