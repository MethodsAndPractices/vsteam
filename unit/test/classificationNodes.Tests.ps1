Set-StrictMode -Version Latest

InModuleScope VSTeam {

   # Set the account to use for testing. A normal user would do this
   # using the Set-VSTeamAccount function.
   [VSTeamVersions]::Account = 'https://dev.azure.com/test'

   $classificationNodeResult = 
@"
{
   "id": 16,
   "identifier": "dfa90792-403a-4119-a52b-bd142c08291b",
   "name": "Demo Public",
   "structureType": "iteration",
   "hasChildren": true,
   "children": [
     {
       "id": 18,
       "identifier": "3d98fd5b-fd0a-4ee0-b7b2-cfdf467014d0",
       "name": "Sprint 1",
       "structureType": "iteration",
       "hasChildren": false,
       "path": "\\Demo Public\\Iteration\\Sprint 1",
       "url": "https://dev.azure.com/test/53e2997d-3723-4c1c-aa62-a0194cb65a29/_apis/wit/classificationNodes/Iterations/Sprint%201"
     },
     {
       "id": 19,
       "identifier": "eee04655-55c2-4712-afa1-9c800c1f1345",
       "name": "Sprint 2",
       "structureType": "iteration",
       "hasChildren": false,
       "path": "\\Demo Public\\Iteration\\Sprint 2",
       "url": "https://dev.azure.com/test/53e2997d-3723-4c1c-aa62-a0194cb65a29/_apis/wit/classificationNodes/Iterations/Sprint%202"
     },
     {
       "id": 20,
       "identifier": "18e7998d-d0c5-4c01-b547-d7d4eb4c97c5",
       "name": "Sprint 3",
       "structureType": "iteration",
       "hasChildren": false,
       "path": "\\Demo Public\\Iteration\\Sprint 3",
       "url": "https://dev.azure.com/test/53e2997d-3723-4c1c-aa62-a0194cb65a29/_apis/wit/classificationNodes/Iterations/Sprint%203"
     },
     {
       "id": 21,
       "identifier": "4e07ee24-8653-4af6-9df2-2aadc0a1a3d3",
       "name": "Sprint 4",
       "structureType": "iteration",
       "hasChildren": false,
       "path": "\\Demo Public\\Iteration\\Sprint 4",
       "url": "https://dev.azure.com/test/53e2997d-3723-4c1c-aa62-a0194cb65a29/_apis/wit/classificationNodes/Iterations/Sprint%204"
     },
     {
       "id": 22,
       "identifier": "b4be112e-8b7d-4def-a37d-7c1e1dea01e1",
       "name": "Sprint 5",
       "structureType": "iteration",
       "hasChildren": false,
       "path": "\\Demo Public\\Iteration\\Sprint 5",
       "url": "https://dev.azure.com/test/53e2997d-3723-4c1c-aa62-a0194cb65a29/_apis/wit/classificationNodes/Iterations/Sprint%205"
     },
     {
       "id": 23,
       "identifier": "7ee87b38-6c81-4fdf-8fbd-dc996f040823",
       "name": "Sprint 6",
       "structureType": "iteration",
       "hasChildren": false,
       "path": "\\Demo Public\\Iteration\\Sprint 6",
       "url": "https://dev.azure.com/test/53e2997d-3723-4c1c-aa62-a0194cb65a29/_apis/wit/classificationNodes/Iterations/Sprint%206"
     }
   ],
   "path": "\\Demo Public\\Iteration",
   "_links": {
     "self": {
       "href": "https://dev.azure.com/test/53e2997d-3723-4c1c-aa62-a0194cb65a29/_apis/wit/classificationNodes/Iterations"
     }
   },
   "url": "https://dev.azure.com/test/53e2997d-3723-4c1c-aa62-a0194cb65a29/_apis/wit/classificationNodes/Iterations"
 }
"@ | ConvertFrom-Json
  
   Describe 'ClassificationNodes VSTS' {
      # You have to set the version or the api-version will not be added when
      # [VSTeamVersions]::Core = ''
      [VSTeamVersions]::Core = '5.0'

      Context 'Get-VSTeamClassificationNode' {
         Mock Invoke-RestMethod {
            # If this test fails uncomment the line below to see how the mock was called.
            # Write-Host $args

            return $classificationNodeResult
         } -Verifiable

         Get-VSTeamClassificationNode -ProjectName "Public Demo" -StructureGroup "Iterations"

         It 'Should return Nodes' {
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -like "https://dev.azure.com/test/Public Demo/_apis/wit/classificationnodes/Iterations*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Core)*"
            }
         }
      }

      Context 'Get-VSTeamClassificationNode with Depth' {
         Mock Invoke-RestMethod { return $classificationNodeResult } -Verifiable

         Get-VSTeamClassificationNode -ProjectName "Public Demo" -StructureGroup "Iterations" -Depth 10

         It 'Should return Nodes' {
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -like "https://dev.azure.com/test/Public Demo/_apis/wit/classificationnodes/Iterations*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
               $Uri -like "*`$Depth=10*"
            }
         }
      }

      Context 'Get-VSTeamClassificationNode by Path' {
         Mock Invoke-RestMethod { return $classificationNodeResult } -Verifiable

         Get-VSTeamClassificationNode -ProjectName "Public Demo" -StructureGroup "Iterations" -Path "test/test/test"

         It 'Should return Nodes' {
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -like "https://dev.azure.com/test/Public Demo/_apis/wit/classificationnodes/Iterations/test/test/test*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Core)*"
            }
         }
      }

      Context 'Get-VSTeamClassificationNode by Ids' {
         Mock Invoke-RestMethod { return $classificationNodeResult } -Verifiable

         Get-VSTeamClassificationNode -ProjectName "Public Demo" -StructureGroup "Iterations" -Ids @(1,2,3,4)

         It 'Should return Nodes' {
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -like "https://dev.azure.com/test/Public Demo/_apis/wit/classificationnodes/Iterations*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
               $Uri -like "*Ids=1,2,3,4*"
            }
         }
      }

      Context 'Get-VSTeamClassificationNode throws' {
         Mock Invoke-RestMethod { throw 'Error' }

         It 'Should throw' {
            { Get-VSTeamClassificationNode -ProjectName "test" -StructureGroup "Areas" } | Should Throw
         }
      }

      Context 'Get-VSTeamClassificationNode with Depth throws' {
         Mock Invoke-RestMethod { throw 'Error' }

         It 'Should throw' {
            { Get-VSTeamClassificationNode -ProjectName "test" -StructureGroup "Areas" -Depth 12 } | Should Throw
         }
      }
   }
}