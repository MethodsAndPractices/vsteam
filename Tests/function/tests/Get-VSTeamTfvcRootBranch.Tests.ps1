Set-StrictMode -Version Latest

Describe 'VSTeamTfvcRootBranch'  -Tag 'unit', 'tfvc', 'get' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      $multipleResults = Open-SampleFile 'Get-VSTeamTfvcBranch-ProjectName.json'
      $singleResult = Open-SampleFile 'Get-VSTeamTfvcBranch-ProjectName.json' -Index 0

      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Tfvc' }
   }

   Context 'Get-VSTeamTfvcRootBranch' {
      Context 'Services' {
         BeforeAll {
            Mock _getInstance { return 'https://dev.azure.com/test' }
         }

         Context 'Get-VSTeamTfvcRootBranch with no parameters and single result' {
            BeforeAll {
               Mock Invoke-RestMethod {
                  # If this test fails uncomment the line below to see how the mock was called.
                  # Write-Host $args

                  return $singleResult
               }

               $res = Get-VSTeamTfvcRootBranch
            }

            It 'should get 1 branch' {
               $res.path | Should -Be $singleResult.path
            }

            It 'should call the REST endpoint with correct parameters' {
               Should -Invoke Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
                  $Uri -eq "https://dev.azure.com/test/_apis/tfvc/branches?api-version=$(_getApiVersion Tfvc)"
               }
            }
         }

         Context 'Get-VSTeamTfvcRootBranch with no parameters and multiple results' {
            BeforeAll {
               Mock Invoke-RestMethod { return $multipleResults }

               $res = Get-VSTeamTfvcRootBranch
            }

            It 'should get 2 branches' {
               $res.Count | Should -Be 2
               $multipleResults.value[0] | Should -BeIn $res
               $multipleResults.value[1] | Should -BeIn $res
            }

            It 'should call the REST endpoint with correct parameters' {
               Should -Invoke Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
                  $Uri -eq "https://dev.azure.com/test/_apis/tfvc/branches?api-version=$(_getApiVersion Tfvc)"
               }
            }
         }

         Context 'Get-VSTeamTfvcRootBranch' {
            BeforeAll {
               Mock Invoke-RestMethod { return $singleResult }
            }
            
            It 'should call the REST endpoint with IncludeChildren' {
               Get-VSTeamTfvcRootBranch -IncludeChildren
               Should -Invoke Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
                  $Uri -eq "https://dev.azure.com/test/_apis/tfvc/branches?api-version=$(_getApiVersion Tfvc)&includeChildren=True"
               }
            }
            
            It 'should call the REST endpoint with IncludeDeleted' {
               Get-VSTeamTfvcRootBranch -IncludeDeleted
               Should -Invoke Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
                  $Uri -eq "https://dev.azure.com/test/_apis/tfvc/branches?api-version=$(_getApiVersion Tfvc)&includeDeleted=True"
               }
            }
            
            It 'should call the REST endpoint with all switches' {
               Get-VSTeamTfvcRootBranch -IncludeChildren -IncludeDeleted
               Should -Invoke Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
                  $Uri -eq "https://dev.azure.com/test/_apis/tfvc/branches?api-version=$(_getApiVersion Tfvc)&includeChildren=True&includeDeleted=True"
               }
            }
         }
      }
   }
}