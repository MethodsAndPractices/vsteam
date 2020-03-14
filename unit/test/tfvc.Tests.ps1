Set-StrictMode -Version Latest

InModuleScope VSTeam {

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

   Describe 'Get-VSTeamTfvcRootBranch VSTS' -Tag 'unit', 'tfvc', 'vsts' {
      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter {
         $Uri -like "*_apis/projects*"
      }

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
               $Uri -eq "https://dev.azure.com/test/_apis/tfvc/branches?api-version=$([VSTeamVersions]::Tfvc)"
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
               $Uri -eq "https://dev.azure.com/test/_apis/tfvc/branches?api-version=$([VSTeamVersions]::Tfvc)"
            }
         }
      }

      Context 'Get-VSTeamTfvcRootBranch with IncludeChildren' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         Get-VSTeamTfvcRootBranch -IncludeChildren

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/_apis/tfvc/branches?api-version=$([VSTeamVersions]::Tfvc)&includeChildren=True"
            }
         }
      }

      Context 'Get-VSTeamTfvcRootBranch with IncludeDeleted' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         Get-VSTeamTfvcRootBranch -IncludeDeleted

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/_apis/tfvc/branches?api-version=$([VSTeamVersions]::Tfvc)&includeDeleted=True"
            }
         }
      }

      Context 'Get-VSTeamTfvcRootBranch with all switches' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         Get-VSTeamTfvcRootBranch -IncludeChildren -IncludeDeleted

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/_apis/tfvc/branches?api-version=$([VSTeamVersions]::Tfvc)&includeChildren=True&includeDeleted=True"
            }
         }
      }
   }

   Describe 'Get-VSTeamTfvcRootBranch TFS' -Tag 'unit', 'tfvc', 'tfs' {
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
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/tfvc/branches?api-version=$([VSTeamVersions]::Tfvc)"
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
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/tfvc/branches?api-version=$([VSTeamVersions]::Tfvc)"
            }
         }
      }

      Context 'Get-VSTeamTfvcRootBranch with IncludeChildren' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         Get-VSTeamTfvcRootBranch -IncludeChildren

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/tfvc/branches?api-version=$([VSTeamVersions]::Tfvc)&includeChildren=True"
            }
         }
      }

      Context 'Get-VSTeamTfvcRootBranch with IncludeDeleted' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         Get-VSTeamTfvcRootBranch -IncludeDeleted

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/tfvc/branches?api-version=$([VSTeamVersions]::Tfvc)&includeDeleted=True"
            }
         }
      }

      Context 'Get-VSTeamTfvcRootBranch with all switches' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         Get-VSTeamTfvcRootBranch -IncludeChildren -IncludeDeleted

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/tfvc/branches?api-version=$([VSTeamVersions]::Tfvc)&includeChildren=True&includeDeleted=True"
            }
         }
      }
   }

   Describe 'Get-VSTeamTfvcBranch' -Tag 'unit', 'multi' {
      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter {
         $Uri -like "*_apis/projects*"
      }

      $testCases = @(
         @{ a = 'https://dev.azure.com/test'; t = 'vsts' }
         @{ a = 'http://localhost:8080/tfs/defaultcollection'; t = 'tfs' }
      )

      Mock Invoke-RestMethod {
         # If this test fails uncomment the line below to see how the mock was called.
         # Write-Host $args
         
         return $singleResult 
      } -Verifiable

      It 'should call the REST endpoint with correct parameters for <t>' -TestCases $testCases {
         param ($a)

         Mock _getInstance { return $a }

         Get-VSTeamTfvcBranch -Path $/TfvcProject/Master

         Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
            $Uri -eq "$a/_apis/tfvc/branches/$/TfvcProject/Master?api-version=$([VSTeamVersions]::Tfvc)"
         }
      }
   }

   Describe 'Get-VSTeamTfvcBranch VSTS' -Tag 'unit', 'tfvc', 'vsts' {
      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter {
         $Uri -like "*_apis/projects*"
      }

      Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable

      Context 'Get-VSTeamTfvcBranch with one path' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         Get-VSTeamTfvcBranch -Path $/TfvcProject/Master

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/_apis/tfvc/branches/$/TfvcProject/Master?api-version=$([VSTeamVersions]::Tfvc)"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with one path from pipeline' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         '$/TfvcProject/Master' | Get-VSTeamTfvcBranch

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/_apis/tfvc/branches/$/TfvcProject/Master?api-version=$([VSTeamVersions]::Tfvc)"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with two paths' {
         Mock Invoke-RestMethod { return $multipleResults } -Verifiable

         Get-VSTeamTfvcBranch -Path $/TfvcProject/Master, $/TfvcProject/Feature

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/_apis/tfvc/branches/$/TfvcProject/Master?api-version=$([VSTeamVersions]::Tfvc)"
            }
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/_apis/tfvc/branches/$/TfvcProject/Feature?api-version=$([VSTeamVersions]::Tfvc)"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with IncludeChildren' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         Get-VSTeamTfvcBranch -Path $/TfvcProject/Master -IncludeChildren

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/_apis/tfvc/branches/$/TfvcProject/Master?api-version=$([VSTeamVersions]::Tfvc)&includeChildren=True"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with IncludeParent' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         Get-VSTeamTfvcBranch -Path $/TfvcProject/Master -IncludeParent

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/_apis/tfvc/branches/$/TfvcProject/Master?api-version=$([VSTeamVersions]::Tfvc)&includeParent=True"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with IncludeDeleted' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         Get-VSTeamTfvcBranch -Path $/TfvcProject/Master -IncludeDeleted

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/_apis/tfvc/branches/$/TfvcProject/Master?api-version=$([VSTeamVersions]::Tfvc)&includeDeleted=True"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with all switches' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         Get-VSTeamTfvcBranch -Path $/TfvcProject/Master -IncludeChildren -IncludeParent -IncludeDeleted

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/_apis/tfvc/branches/$/TfvcProject/Master?api-version=$([VSTeamVersions]::Tfvc)&includeChildren=True&includeParent=True&includeDeleted=True"
            }
         }
      }
   }

   Describe 'Get-VSTeamTfvcBranch TFS' -Tag 'unit', 'tfvc', 'tfs' {
      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter {
         $Uri -like "*_apis/projects*"
      }

      Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' } -Verifiable
      Mock _useWindowsAuthenticationOnPremise { return $true }

      Context 'Get-VSTeamTfvcBranch with one path' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         Get-VSTeamTfvcBranch -Path $/TfvcProject/Master

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/tfvc/branches/$/TfvcProject/Master?api-version=$([VSTeamVersions]::Tfvc)"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with one path from pipeline' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         '$/TfvcProject/Master' | Get-VSTeamTfvcBranch

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/tfvc/branches/$/TfvcProject/Master?api-version=$([VSTeamVersions]::Tfvc)"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with two paths' {
         Mock Invoke-RestMethod { return $multipleResults } -Verifiable

         Get-VSTeamTfvcBranch -Path $/TfvcProject/Master, $/TfvcProject/Feature

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/tfvc/branches/$/TfvcProject/Master?api-version=$([VSTeamVersions]::Tfvc)"
            }
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/tfvc/branches/$/TfvcProject/Feature?api-version=$([VSTeamVersions]::Tfvc)"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with IncludeChildren' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         Get-VSTeamTfvcBranch -Path $/TfvcProject/Master -IncludeChildren

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/tfvc/branches/$/TfvcProject/Master?api-version=$([VSTeamVersions]::Tfvc)&includeChildren=True"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with IncludeParent' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         Get-VSTeamTfvcBranch -Path $/TfvcProject/Master -IncludeParent

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/tfvc/branches/$/TfvcProject/Master?api-version=$([VSTeamVersions]::Tfvc)&includeParent=True"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with IncludeDeleted' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         Get-VSTeamTfvcBranch -Path $/TfvcProject/Master -IncludeDeleted

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/tfvc/branches/$/TfvcProject/Master?api-version=$([VSTeamVersions]::Tfvc)&includeDeleted=True"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with all switches' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         Get-VSTeamTfvcBranch -Path $/TfvcProject/Master -IncludeChildren -IncludeParent -IncludeDeleted

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/tfvc/branches/$/TfvcProject/Master?api-version=$([VSTeamVersions]::Tfvc)&includeChildren=True&includeParent=True&includeDeleted=True"
            }
         }
      }
   }
}