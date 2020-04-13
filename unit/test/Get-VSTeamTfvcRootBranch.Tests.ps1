Set-StrictMode -Version Latest

#region include
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Private/applyTypes.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/Set-VSTeamAPIVersion.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe 'VSTeamTfvcRootBranch'  -Tag 'unit', 'tfvc', 'get' {
   $singleResult = [PSCustomObject]@{
      path        = "$/TfvcProject/Master";
      description = 'desc';
      children    = @();
   }

   $multipleResults = [PSCustomObject]@{
      value = @(
         [PSCustomObject]@{
            path        = '$/TfvcProject/Master';
            description = 'desc';
            children    = @();
         },
         [PSCustomObject]@{
            path        = '$/AnotherProject/Master';
            description = 'desc';
            children    = @();
         }
      )
   }

   Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Tfvc' }

   Context 'Get-VSTeamTfvcRootBranch' {
      Context 'Services' {
         # Mock the call to Get-Projects by the dynamic parameter for ProjectName
         Mock Invoke-RestMethod { return @() } -ParameterFilter { $Uri -like "*_apis/projects*" }

         Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable

         Context 'Get-VSTeamTfvcRootBranch with no parameters and single result' {
            Mock Invoke-RestMethod {
               # If this test fails uncomment the line below to see how the mock was called.
               # Write-Host $args

               return $singleResult 
            } -Verifiable

            $res = Get-VSTeamTfvcRootBranch

            It 'should get 1 branch' {
               $res.path | Should -Be $singleResult.path
            }

            It 'should call the REST endpoint with correct parameters' {
               Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
                  $Uri -eq "https://dev.azure.com/test/_apis/tfvc/branches?api-version=$(_getApiVersion Tfvc)"
               }
            }
         }

         Context 'Get-VSTeamTfvcRootBranch with no parameters and multiple results' {
            Mock Invoke-RestMethod { return $multipleResults } -Verifiable

            $res = Get-VSTeamTfvcRootBranch

            It 'should get 2 branches' {
               $res.Count | Should -Be 2
               $multipleResults.value[0] | Should -BeIn $res
               $multipleResults.value[1] | Should -BeIn $res
            }

            It 'should call the REST endpoint with correct parameters' {
               Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
                  $Uri -eq "https://dev.azure.com/test/_apis/tfvc/branches?api-version=$(_getApiVersion Tfvc)"
               }
            }
         }

         Context 'Get-VSTeamTfvcRootBranch with IncludeChildren' {
            Mock Invoke-RestMethod { return $singleResult } -Verifiable

            Get-VSTeamTfvcRootBranch -IncludeChildren

            It 'should call the REST endpoint with correct parameters' {
               Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
                  $Uri -eq "https://dev.azure.com/test/_apis/tfvc/branches?api-version=$(_getApiVersion Tfvc)&includeChildren=True"
               }
            }
         }

         Context 'Get-VSTeamTfvcRootBranch with IncludeDeleted' {
            Mock Invoke-RestMethod { return $singleResult } -Verifiable

            Get-VSTeamTfvcRootBranch -IncludeDeleted

            It 'should call the REST endpoint with correct parameters' {
               Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
                  $Uri -eq "https://dev.azure.com/test/_apis/tfvc/branches?api-version=$(_getApiVersion Tfvc)&includeDeleted=True"
               }
            }
         }

         Context 'Get-VSTeamTfvcRootBranch with all switches' {
            Mock Invoke-RestMethod { return $singleResult } -Verifiable

            Get-VSTeamTfvcRootBranch -IncludeChildren -IncludeDeleted

            It 'should call the REST endpoint with correct parameters' {
               Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
                  $Uri -eq "https://dev.azure.com/test/_apis/tfvc/branches?api-version=$(_getApiVersion Tfvc)&includeChildren=True&includeDeleted=True"
               }
            }
         }
      }

      Context 'Server' {
         # Mock the call to Get-Projects by the dynamic parameter for ProjectName
         Mock Invoke-RestMethod { return @() } -ParameterFilter {
            $Uri -like "*_apis/projects*"
         }

         Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' }
         Mock _useWindowsAuthenticationOnPremise { return $true }

         Context 'Get-VSTeamTfvcRootBranch with no parameters and single result' {
            Mock Invoke-RestMethod { return $singleResult } -Verifiable

            $res = Get-VSTeamTfvcRootBranch

            It 'should get 1 branch' {
               $res.path | Should -Be $singleResult.path
            }

            It 'should call the REST endpoint with correct parameters' {
               Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
                  $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/tfvc/branches?api-version=$(_getApiVersion Tfvc)"
               }
            }
         }

         Context 'Get-VSTeamTfvcRootBranch with no parameters and multiple results' {
            Mock Invoke-RestMethod { return $multipleResults } -Verifiable

            $res = Get-VSTeamTfvcRootBranch

            It 'should get 2 branches' {
               $res.Count | Should -Be 2
               $multipleResults.value[0] | Should -BeIn $res
               $multipleResults.value[1] | Should -BeIn $res
            }

            It 'should call the REST endpoint with correct parameters' {
               Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
                  $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/tfvc/branches?api-version=$(_getApiVersion Tfvc)"
               }
            }
         }

         Context 'Get-VSTeamTfvcRootBranch with IncludeChildren' {
            Mock Invoke-RestMethod { return $singleResult } -Verifiable

            Get-VSTeamTfvcRootBranch -IncludeChildren

            It 'should call the REST endpoint with correct parameters' {
               Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
                  $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/tfvc/branches?api-version=$(_getApiVersion Tfvc)&includeChildren=True"
               }
            }
         }

         Context 'Get-VSTeamTfvcRootBranch with IncludeDeleted' {
            Mock Invoke-RestMethod { return $singleResult } -Verifiable

            Get-VSTeamTfvcRootBranch -IncludeDeleted

            It 'should call the REST endpoint with correct parameters' {
               Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
                  $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/tfvc/branches?api-version=$(_getApiVersion Tfvc)&includeDeleted=True"
               }
            }
         }

         Context 'Get-VSTeamTfvcRootBranch with all switches' {
            Mock Invoke-RestMethod { return $singleResult } -Verifiable

            Get-VSTeamTfvcRootBranch -IncludeChildren -IncludeDeleted

            It 'should call the REST endpoint with correct parameters' {
               Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
                  $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/tfvc/branches?api-version=$(_getApiVersion Tfvc)&includeChildren=True&includeDeleted=True"
               }
            }
         }
      }
   }
}