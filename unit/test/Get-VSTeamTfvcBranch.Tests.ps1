Set-StrictMode -Version Latest

Describe 'VSTeamTfvcBranch'  -Tag 'unit', 'tfvc' {
   BeforeAll {
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/Set-VSTeamAPIVersion.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"

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
   }

   Describe 'Get-VSTeamTfvcBranch' {
      BeforeAll {
         # Mock the call to Get-Projects by the dynamic parameter for ProjectName
         Mock Invoke-RestMethod { return @() } -ParameterFilter {
            $Uri -like "*_apis/projects*"
         }

         Mock Invoke-RestMethod {
            # If this test fails uncomment the line below to see how the mock was called.
            # Write-Host $args

            return $singleResult
         } -Verifiable
      }

      $testCases = @(
         @{ a = 'https://dev.azure.com/test'; t = 'vsts' }
         @{ a = 'http://localhost:8080/tfs/defaultcollection'; t = 'tfs' }
      )
      It 'should call the REST endpoint with correct parameters for <t>' -TestCases $testCases {
         BeforeAll {
            param ($a)

            Mock _getInstance { return $a }

            Get-VSTeamTfvcBranch -Path $/TfvcProject/Master

            Should -Invoke Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "$a/_apis/tfvc/branches/$/TfvcProject/Master?api-version=$(_getApiVersion Tfvc)"
            }
         }
      }
   }

   Describe 'Get-VSTeamTfvcBranch VSTS' {
      BeforeAll {
         # Mock the call to Get-Projects by the dynamic parameter for ProjectName
         Mock Invoke-RestMethod { return @() } -ParameterFilter {
            $Uri -like "*_apis/projects*"
         }

         Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable
      }

      Context 'Get-VSTeamTfvcBranch with one path' {
         BeforeAll {
            Mock Invoke-RestMethod { return $singleResult } -Verifiable

            Get-VSTeamTfvcBranch -Path $/TfvcProject/Master
         }

         It 'should call the REST endpoint with correct parameters' {
            Should -Invoke Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/_apis/tfvc/branches/$/TfvcProject/Master?api-version=$(_getApiVersion Tfvc)"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with one path from pipeline' {
         BeforeAll {
            Mock Invoke-RestMethod { return $singleResult } -Verifiable

            '$/TfvcProject/Master' | Get-VSTeamTfvcBranch
         }

         It 'should call the REST endpoint with correct parameters' {
            Should -Invoke Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/_apis/tfvc/branches/$/TfvcProject/Master?api-version=$(_getApiVersion Tfvc)"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with two paths' {
         BeforeAll {
            Mock Invoke-RestMethod { return $multipleResults } -Verifiable

            Get-VSTeamTfvcBranch -Path $/TfvcProject/Master, $/TfvcProject/Feature
         }

         It 'should call the REST endpoint with correct parameters' {
            Should -Invoke Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/_apis/tfvc/branches/$/TfvcProject/Master?api-version=$(_getApiVersion Tfvc)"
            }
            Should -Invoke Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/_apis/tfvc/branches/$/TfvcProject/Feature?api-version=$(_getApiVersion Tfvc)"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with IncludeChildren' {
         BeforeAll {
            Mock Invoke-RestMethod { return $singleResult } -Verifiable

            Get-VSTeamTfvcBranch -Path $/TfvcProject/Master -IncludeChildren
         }

         It 'should call the REST endpoint with correct parameters' {
            Should -Invoke Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/_apis/tfvc/branches/$/TfvcProject/Master?api-version=$(_getApiVersion Tfvc)&includeChildren=True"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with IncludeParent' {
         BeforeAll {
            Mock Invoke-RestMethod { return $singleResult } -Verifiable

            Get-VSTeamTfvcBranch -Path $/TfvcProject/Master -IncludeParent
         }

         It 'should call the REST endpoint with correct parameters' {
            Should -Invoke Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/_apis/tfvc/branches/$/TfvcProject/Master?api-version=$(_getApiVersion Tfvc)&includeParent=True"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with IncludeDeleted' {
         BeforeAll {
            Mock Invoke-RestMethod { return $singleResult } -Verifiable

            Get-VSTeamTfvcBranch -Path $/TfvcProject/Master -IncludeDeleted
         }

         It 'should call the REST endpoint with correct parameters' {
            Should -Invoke Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/_apis/tfvc/branches/$/TfvcProject/Master?api-version=$(_getApiVersion Tfvc)&includeDeleted=True"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with all switches' {
         BeforeAll {
            Mock Invoke-RestMethod { return $singleResult } -Verifiable

            Get-VSTeamTfvcBranch -Path $/TfvcProject/Master -IncludeChildren -IncludeParent -IncludeDeleted
         }

         It 'should call the REST endpoint with correct parameters' {
            Should -Invoke Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/_apis/tfvc/branches/$/TfvcProject/Master?api-version=$(_getApiVersion Tfvc)&includeChildren=True&includeParent=True&includeDeleted=True"
            }
         }
      }
   }

   Describe 'Get-VSTeamTfvcBranch TFS' {
      BeforeAll {
         # Mock the call to Get-Projects by the dynamic parameter for ProjectName
         Mock Invoke-RestMethod { return @() } -ParameterFilter {
            $Uri -like "*_apis/projects*"
         }

         Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' } -Verifiable
         Mock _useWindowsAuthenticationOnPremise { return $true }
      }

      Context 'Get-VSTeamTfvcBranch with one path' {
         BeforeAll {
            Mock Invoke-RestMethod { return $singleResult } -Verifiable

            Get-VSTeamTfvcBranch -Path $/TfvcProject/Master
         }

         It 'should call the REST endpoint with correct parameters' {
            Should -Invoke Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/tfvc/branches/$/TfvcProject/Master?api-version=$(_getApiVersion Tfvc)"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with one path from pipeline' {
         BeforeAll {
            Mock Invoke-RestMethod { return $singleResult } -Verifiable

            '$/TfvcProject/Master' | Get-VSTeamTfvcBranch
         }

         It 'should call the REST endpoint with correct parameters' {
            Should -Invoke Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/tfvc/branches/$/TfvcProject/Master?api-version=$(_getApiVersion Tfvc)"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with two paths' {
         BeforeAll {
            Mock Invoke-RestMethod { return $multipleResults } -Verifiable

            Get-VSTeamTfvcBranch -Path $/TfvcProject/Master, $/TfvcProject/Feature
         }

         It 'should call the REST endpoint with correct parameters' {
            Should -Invoke Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/tfvc/branches/$/TfvcProject/Master?api-version=$(_getApiVersion Tfvc)"
            }
            Should -Invoke Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/tfvc/branches/$/TfvcProject/Feature?api-version=$(_getApiVersion Tfvc)"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with IncludeChildren' {
         BeforeAll {
            Mock Invoke-RestMethod { return $singleResult } -Verifiable

            Get-VSTeamTfvcBranch -Path $/TfvcProject/Master -IncludeChildren
         }

         It 'should call the REST endpoint with correct parameters' {
            Should -Invoke Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/tfvc/branches/$/TfvcProject/Master?api-version=$(_getApiVersion Tfvc)&includeChildren=True"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with IncludeParent' {
         BeforeAll {
            Mock Invoke-RestMethod { return $singleResult } -Verifiable

            Get-VSTeamTfvcBranch -Path $/TfvcProject/Master -IncludeParent
         }

         It 'should call the REST endpoint with correct parameters' {
            Should -Invoke Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/tfvc/branches/$/TfvcProject/Master?api-version=$(_getApiVersion Tfvc)&includeParent=True"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with IncludeDeleted' {
         BeforeAll {
            Mock Invoke-RestMethod { return $singleResult } -Verifiable

            Get-VSTeamTfvcBranch -Path $/TfvcProject/Master -IncludeDeleted
         }

         It 'should call the REST endpoint with correct parameters' {
            Should -Invoke Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/tfvc/branches/$/TfvcProject/Master?api-version=$(_getApiVersion Tfvc)&includeDeleted=True"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with all switches' {
         BeforeAll {
            Mock Invoke-RestMethod { return $singleResult } -Verifiable

            Get-VSTeamTfvcBranch -Path $/TfvcProject/Master -IncludeChildren -IncludeParent -IncludeDeleted
         }

         It 'should call the REST endpoint with correct parameters' {
            Should -Invoke Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/tfvc/branches/$/TfvcProject/Master?api-version=$(_getApiVersion Tfvc)&includeChildren=True&includeParent=True&includeDeleted=True"
            }
         }
      }
   }
}