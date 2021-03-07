Set-StrictMode -Version Latest

Describe 'VSTeamClassificationNode' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      ## Arrange
      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '5.0-unitTests' } -ParameterFilter { $Service -eq 'Core' }
   }

   Context 'Get-VSTeamClassificationNode' {
      BeforeAll {
         Mock Invoke-RestMethod { Open-SampleFile 'classificationNodeResult.json' }
         Mock Invoke-RestMethod { Open-SampleFile 'withoutChildNode.json' } -ParameterFilter {
            $Uri -like "*Ids=43,44*" 
         }
      }

      It 'with StructureGroup should return Nodes' {
         ## Act
         Get-VSTeamClassificationNode -ProjectName "Public Demo" -StructureGroup "Iterations"

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/Public Demo/_apis/wit/classificationnodes/Iterations*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*"
         }
      }

      It 'with depth should return Nodes' {
         ## Act
         Get-VSTeamClassificationNode -ProjectName "Public Demo" -StructureGroup "Iterations" -Depth 10

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/Public Demo/_apis/wit/classificationnodes/Iterations*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Uri -like "*`$Depth=10*"
         }
      }

      It 'by Path should return Nodes' {
         ## Act
         Get-VSTeamClassificationNode -ProjectName "Public Demo" `
            -StructureGroup "Iterations" `
            -Path "test/test/test"

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/Public Demo/_apis/wit/classificationnodes/Iterations/test/test/test*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*"
         }
      }

      It 'by ids should return Nodes' {
         ## Act
         Get-VSTeamClassificationNode -ProjectName "Public Demo" -Id @(1, 2, 3, 4)

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/Public Demo/_apis/wit/classificationnodes*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Uri -like "*Ids=1,2,3,4*"
         }
      }

      It 'should handle when there is no child nodes' {
         ## Act
         Get-VSTeamClassificationNode -ProjectName "Public Demo" -Id @(43, 44)

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly 1 -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/Public Demo/_apis/wit/classificationnodes*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Uri -like "*Ids=43,44*"
         }
      }
   }
}