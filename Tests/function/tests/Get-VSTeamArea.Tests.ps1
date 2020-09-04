Set-StrictMode -Version Latest

Describe 'Get-VSTeamArea' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      . "$baseFolder/Source/Public/Get-VSTeamClassificationNode"
      . "$baseFolder/Source/Public/Get-VSTeamProject.ps1"
      
      $classificationNodeResult = Get-Content "$sampleFiles\classificationNodeResult.json" -Raw | ConvertFrom-Json

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