Set-StrictMode -Version Latest

Describe 'VSTeamIteration' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
   
      . "$baseFolder/Source/Public/Get-VSTeamClassificationNode"
      
      $withoutChildNode = Open-SampleFile 'withoutChildNode.json'
      $classificationNodeResult = Open-SampleFile 'classificationNodeResult.json'

      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' }

      Mock _getApiVersion { return '5.0-unitTests' } -ParameterFilter { $Service -eq 'Core' }
   }

   Context 'Get-VSTeamIteration' {
      BeforeAll {
         Mock Invoke-RestMethod { return $classificationNodeResult }
         Mock Invoke-RestMethod { return $withoutChildNode } -ParameterFilter { $Uri -like "*Ids=43,44*" }
      }

      It 'by path and depth should return iterations' {
         ## Act
         Get-VSTeamIteration -ProjectName "Public Demo" -Depth 5 -Path "test/test/test"

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/Public Demo/_apis/wit/classificationnodes/Iterations/test/test/test*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Uri -like "*`$Depth=5*"
         }
      }

      It 'by ids and depth should return iterations' {
         ## Act
         Get-VSTeamIteration -ProjectName "Public Demo" -Ids @(1, 2, 3, 4) -Depth 5

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