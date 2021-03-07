Set-StrictMode -Version Latest

Describe 'VSTeamIteration' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath   
      . "$baseFolder/Source/Public/Get-VSTeamClassificationNode"
      
      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '5.0-unitTests' } -ParameterFilter { 
         $Service -eq 'Core' 
      }
   }

   Context 'Get-VSTeamIteration' {
      BeforeAll {
         Mock Invoke-RestMethod { Open-SampleFile 'classificationNodeResult.json' }
         Mock Invoke-RestMethod { Open-SampleFile 'withoutChildNode.json' } -ParameterFilter { 
            $Uri -like "*Ids=43,44*" 
         }
      }

      It 'should return iterations by path and depth' {
         ## Act
         Get-VSTeamIteration -ProjectName "Public Demo" -Depth 5 -Path "test/test/test"

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/Public Demo/_apis/wit/classificationnodes/Iterations/test/test/test*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Uri -like "*`$Depth=5*"
         }
      }

      It 'should return iterations by ids and depth' {
         ## Act
         Get-VSTeamIteration -ProjectName "Public Demo" -Id @(1, 2, 3, 4) -Depth 5

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