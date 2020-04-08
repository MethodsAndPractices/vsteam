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

Describe 'VSTeamTfvcBranch'  -Tag 'unit', 'tfvc' {

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

   Describe 'Get-VSTeamTfvcBranch' {
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
            $Uri -eq "$a/_apis/tfvc/branches/$/TfvcProject/Master?api-version=$(_getApiVersion Tfvc)"
         }
      }
   }

   Describe 'Get-VSTeamTfvcBranch VSTS' {
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
               $Uri -eq "https://dev.azure.com/test/_apis/tfvc/branches/$/TfvcProject/Master?api-version=$(_getApiVersion Tfvc)"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with one path from pipeline' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         '$/TfvcProject/Master' | Get-VSTeamTfvcBranch

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/_apis/tfvc/branches/$/TfvcProject/Master?api-version=$(_getApiVersion Tfvc)"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with two paths' {
         Mock Invoke-RestMethod { return $multipleResults } -Verifiable

         Get-VSTeamTfvcBranch -Path $/TfvcProject/Master, $/TfvcProject/Feature

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/_apis/tfvc/branches/$/TfvcProject/Master?api-version=$(_getApiVersion Tfvc)"
            }
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/_apis/tfvc/branches/$/TfvcProject/Feature?api-version=$(_getApiVersion Tfvc)"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with IncludeChildren' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         Get-VSTeamTfvcBranch -Path $/TfvcProject/Master -IncludeChildren

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/_apis/tfvc/branches/$/TfvcProject/Master?api-version=$(_getApiVersion Tfvc)&includeChildren=True"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with IncludeParent' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         Get-VSTeamTfvcBranch -Path $/TfvcProject/Master -IncludeParent

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/_apis/tfvc/branches/$/TfvcProject/Master?api-version=$(_getApiVersion Tfvc)&includeParent=True"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with IncludeDeleted' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         Get-VSTeamTfvcBranch -Path $/TfvcProject/Master -IncludeDeleted

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/_apis/tfvc/branches/$/TfvcProject/Master?api-version=$(_getApiVersion Tfvc)&includeDeleted=True"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with all switches' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         Get-VSTeamTfvcBranch -Path $/TfvcProject/Master -IncludeChildren -IncludeParent -IncludeDeleted

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/_apis/tfvc/branches/$/TfvcProject/Master?api-version=$(_getApiVersion Tfvc)&includeChildren=True&includeParent=True&includeDeleted=True"
            }
         }
      }
   }

   Describe 'Get-VSTeamTfvcBranch TFS' {
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
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/tfvc/branches/$/TfvcProject/Master?api-version=$(_getApiVersion Tfvc)"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with one path from pipeline' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         '$/TfvcProject/Master' | Get-VSTeamTfvcBranch

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/tfvc/branches/$/TfvcProject/Master?api-version=$(_getApiVersion Tfvc)"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with two paths' {
         Mock Invoke-RestMethod { return $multipleResults } -Verifiable

         Get-VSTeamTfvcBranch -Path $/TfvcProject/Master, $/TfvcProject/Feature

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/tfvc/branches/$/TfvcProject/Master?api-version=$(_getApiVersion Tfvc)"
            }
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/tfvc/branches/$/TfvcProject/Feature?api-version=$(_getApiVersion Tfvc)"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with IncludeChildren' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         Get-VSTeamTfvcBranch -Path $/TfvcProject/Master -IncludeChildren

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/tfvc/branches/$/TfvcProject/Master?api-version=$(_getApiVersion Tfvc)&includeChildren=True"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with IncludeParent' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         Get-VSTeamTfvcBranch -Path $/TfvcProject/Master -IncludeParent

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/tfvc/branches/$/TfvcProject/Master?api-version=$(_getApiVersion Tfvc)&includeParent=True"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with IncludeDeleted' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         Get-VSTeamTfvcBranch -Path $/TfvcProject/Master -IncludeDeleted

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/tfvc/branches/$/TfvcProject/Master?api-version=$(_getApiVersion Tfvc)&includeDeleted=True"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with all switches' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         Get-VSTeamTfvcBranch -Path $/TfvcProject/Master -IncludeChildren -IncludeParent -IncludeDeleted

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/tfvc/branches/$/TfvcProject/Master?api-version=$(_getApiVersion Tfvc)&includeChildren=True&includeParent=True&includeDeleted=True"
            }
         }
      }
   }
}