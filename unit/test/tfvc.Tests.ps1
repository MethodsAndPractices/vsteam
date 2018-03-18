Set-StrictMode -Version Latest

Get-Module VSTeam | Remove-Module -Force
Get-Module Team | Remove-Module -Force
Get-Module Tfvc | Remove-Module -Force

Import-Module $PSScriptRoot\..\..\src\team.psm1 -Force
Import-Module $PSScriptRoot\..\..\src\tfvc.psm1 -Force

InModuleScope tfvc {
   
   $singleResult = [PSCustomObject]@{
      path = "$/MyProject/Master";
      description = 'desc';
      children = @();
   }

   $multipleResults = [PSCustomObject]@{
      value = @(
         [PSCustomObject]@{
            path = '$/MyProject/Master';
            description = 'desc';
            children = @();
         },
         [PSCustomObject]@{
            path = '$/MyProject/Feature';
            description = 'desc';
            children = @();
         }
      )
   }

   Describe "Get-VSTeamTfvcRootBranches VSTS" {

      $VSTeamVersionTable.Account = 'https://test.visualstudio.com'

      Context 'Get-VSTeamTfvcRootBranches with no parameters and single result' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         $res = Get-VSTeamTfvcRootBranches

         It 'should get 1 branch' {
            $res.path | Should -Be $singleResult.path
         }

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "$($VSTeamVersionTable.Account)/_apis/tfvc/branches/?api-version=$($VSTeamVersionTable.Tfvc)"
            }
         }
      }

      Context 'Get-VSTeamTfvcRootBranches with no parameters and multiple results' {
         Mock Invoke-RestMethod { return $multipleResults } -Verifiable

         $res = Get-VSTeamTfvcRootBranches

         It 'should get 2 branches' {
            $res.Count | Should -Be 2
            $multipleResults.value[0] | Should -BeIn $res
            $multipleResults.value[1] | Should -BeIn $res
         }

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "$($VSTeamVersionTable.Account)/_apis/tfvc/branches/?api-version=$($VSTeamVersionTable.Tfvc)"
            }
         }
      }

      Context 'Get-VSTeamTfvcRootBranches with IncludeChildren' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         Get-VSTeamTfvcRootBranches -IncludeChildren

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "$($VSTeamVersionTable.Account)/_apis/tfvc/branches/?api-version=$($VSTeamVersionTable.Tfvc)&includeChildren=True"
            }
         }
      }

      Context 'Get-VSTeamTfvcRootBranches with IncludeDeleted' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         Get-VSTeamTfvcRootBranches -IncludeDeleted

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "$($VSTeamVersionTable.Account)/_apis/tfvc/branches/?api-version=$($VSTeamVersionTable.Tfvc)&includeDeleted=True"
            }
         }
      }

      Context 'Get-VSTeamTfvcRootBranches with all switches' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         Get-VSTeamTfvcRootBranches -IncludeChildren -IncludeDeleted

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "$($VSTeamVersionTable.Account)/_apis/tfvc/branches/?api-version=$($VSTeamVersionTable.Tfvc)&includeChildren=True&includeDeleted=True"
            }
         }
      }
   }

   Describe "Get-VSTeamTfvcRootBranches TFS" {

      $VSTeamVersionTable.Account = 'http://localhost:8080/tfs/defaultcollection'
      Mock _useWindowsAuthenticationOnPremise { return $true }
      
      Context 'Get-VSTeamTfvcRootBranches with no parameters and single result' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         $res = Get-VSTeamTfvcRootBranches

         It 'should get 1 branch' {
            $res.path | Should -Be $singleResult.path
         }

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "$($VSTeamVersionTable.Account)/_apis/tfvc/branches/?api-version=$($VSTeamVersionTable.Tfvc)"
            }
         }
      }

      Context 'Get-VSTeamTfvcRootBranches with no parameters and multiple results' {
         Mock Invoke-RestMethod { return $multipleResults } -Verifiable

         $res = Get-VSTeamTfvcRootBranches

         It 'should get 2 branches' {
            $res.Count | Should -Be 2
            $multipleResults.value[0] | Should -BeIn $res
            $multipleResults.value[1] | Should -BeIn $res
         }

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "$($VSTeamVersionTable.Account)/_apis/tfvc/branches/?api-version=$($VSTeamVersionTable.Tfvc)"
            }
         }
      }

      Context 'Get-VSTeamTfvcRootBranches with IncludeChildren' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         Get-VSTeamTfvcRootBranches -IncludeChildren

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "$($VSTeamVersionTable.Account)/_apis/tfvc/branches/?api-version=$($VSTeamVersionTable.Tfvc)&includeChildren=True"
            }
         }
      }

      Context 'Get-VSTeamTfvcRootBranches with IncludeDeleted' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         Get-VSTeamTfvcRootBranches -IncludeDeleted

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "$($VSTeamVersionTable.Account)/_apis/tfvc/branches/?api-version=$($VSTeamVersionTable.Tfvc)&includeDeleted=True"
            }
         }
      }

      Context 'Get-VSTeamTfvcRootBranches with all switches' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         Get-VSTeamTfvcRootBranches -IncludeChildren -IncludeDeleted

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "$($VSTeamVersionTable.Account)/_apis/tfvc/branches/?api-version=$($VSTeamVersionTable.Tfvc)&includeChildren=True&includeDeleted=True"
            }
         }
      }
   }
  
   Describe "Get-VSTeamTfvcBranch VSTS" {

      $VSTeamVersionTable.Account = 'https://test.visualstudio.com'
      
      Context 'Get-VSTeamTfvcBranch with one path' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         Get-VSTeamTfvcBranch -Path $/MyProject/Master

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "$($VSTeamVersionTable.Account)/_apis/tfvc/branches/$/MyProject/Master?api-version=$($VSTeamVersionTable.Tfvc)"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with one path from pipeline' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         '$/MyProject/Master' | Get-VSTeamTfvcBranch

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "$($VSTeamVersionTable.Account)/_apis/tfvc/branches/$/MyProject/Master?api-version=$($VSTeamVersionTable.Tfvc)"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with two paths' {
         Mock Invoke-RestMethod { return $multipleResults } -Verifiable

         Get-VSTeamTfvcBranch -Path $/MyProject/Master,$/MyProject/Feature

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "$($VSTeamVersionTable.Account)/_apis/tfvc/branches/$/MyProject/Master?api-version=$($VSTeamVersionTable.Tfvc)"
            }
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "$($VSTeamVersionTable.Account)/_apis/tfvc/branches/$/MyProject/Feature?api-version=$($VSTeamVersionTable.Tfvc)"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with IncludeChildren' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         Get-VSTeamTfvcBranch -Path $/MyProject/Master -IncludeChildren

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "$($VSTeamVersionTable.Account)/_apis/tfvc/branches/$/MyProject/Master?api-version=$($VSTeamVersionTable.Tfvc)&includeChildren=True"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with IncludeParent' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         Get-VSTeamTfvcBranch -Path $/MyProject/Master -IncludeParent

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "$($VSTeamVersionTable.Account)/_apis/tfvc/branches/$/MyProject/Master?api-version=$($VSTeamVersionTable.Tfvc)&includeParent=True"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with IncludeDeleted' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         Get-VSTeamTfvcBranch -Path $/MyProject/Master -IncludeDeleted

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "$($VSTeamVersionTable.Account)/_apis/tfvc/branches/$/MyProject/Master?api-version=$($VSTeamVersionTable.Tfvc)&includeDeleted=True"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with all switches' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         Get-VSTeamTfvcBranch -Path $/MyProject/Master -IncludeChildren -IncludeParent -IncludeDeleted

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "$($VSTeamVersionTable.Account)/_apis/tfvc/branches/$/MyProject/Master?api-version=$($VSTeamVersionTable.Tfvc)&includeChildren=True&includeParent=True&includeDeleted=True"
            }
         }
      }
   }

   Describe "Get-VSTeamTfvcBranch TFS" {

      $VSTeamVersionTable.Account = 'http://localhost:8080/tfs/defaultcollection'
      Mock _useWindowsAuthenticationOnPremise { return $true }
      
      Context 'Get-VSTeamTfvcBranch with one path' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         Get-VSTeamTfvcBranch -Path $/MyProject/Master

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "$($VSTeamVersionTable.Account)/_apis/tfvc/branches/$/MyProject/Master?api-version=$($VSTeamVersionTable.Tfvc)"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with one path from pipeline' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         '$/MyProject/Master' | Get-VSTeamTfvcBranch

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "$($VSTeamVersionTable.Account)/_apis/tfvc/branches/$/MyProject/Master?api-version=$($VSTeamVersionTable.Tfvc)"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with two paths' {
         Mock Invoke-RestMethod { return $multipleResults } -Verifiable

         Get-VSTeamTfvcBranch -Path $/MyProject/Master,$/MyProject/Feature

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "$($VSTeamVersionTable.Account)/_apis/tfvc/branches/$/MyProject/Master?api-version=$($VSTeamVersionTable.Tfvc)"
            }
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "$($VSTeamVersionTable.Account)/_apis/tfvc/branches/$/MyProject/Feature?api-version=$($VSTeamVersionTable.Tfvc)"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with IncludeChildren' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         Get-VSTeamTfvcBranch -Path $/MyProject/Master -IncludeChildren

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "$($VSTeamVersionTable.Account)/_apis/tfvc/branches/$/MyProject/Master?api-version=$($VSTeamVersionTable.Tfvc)&includeChildren=True"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with IncludeParent' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         Get-VSTeamTfvcBranch -Path $/MyProject/Master -IncludeParent

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "$($VSTeamVersionTable.Account)/_apis/tfvc/branches/$/MyProject/Master?api-version=$($VSTeamVersionTable.Tfvc)&includeParent=True"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with IncludeDeleted' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         Get-VSTeamTfvcBranch -Path $/MyProject/Master -IncludeDeleted

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "$($VSTeamVersionTable.Account)/_apis/tfvc/branches/$/MyProject/Master?api-version=$($VSTeamVersionTable.Tfvc)&includeDeleted=True"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with all switches' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         Get-VSTeamTfvcBranch -Path $/MyProject/Master -IncludeChildren -IncludeParent -IncludeDeleted

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "$($VSTeamVersionTable.Account)/_apis/tfvc/branches/$/MyProject/Master?api-version=$($VSTeamVersionTable.Tfvc)&includeChildren=True&includeParent=True&includeDeleted=True"
            }
         }
      }
   }
}