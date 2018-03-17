Set-StrictMode -Version Latest

Get-Module VSTeam | Remove-Module -Force
Get-Module Team | Remove-Module -Force
Get-Module Tfvc | Remove-Module -Force

Import-Module $PSScriptRoot\..\..\src\team.psm1 -Force
Import-Module $PSScriptRoot\..\..\src\tfvc.psm1 -Force

InModuleScope tfvc {
   
   $results = [PSCustomObject]@{
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

   $singleResult = [PSCustomObject]@{
      path = "$/MyProject/Master";
      description = 'desc';
      children = @();
   }
  
   Describe "Get-VSTeamTfvcBranches VSTS" {

      $VSTeamVersionTable.Account = 'https://test.visualstudio.com'

      Context 'Get-VSTeamTfvcBranches with no parameters' {
         Mock Invoke-RestMethod { return $results } -Verifiable

         $res = Get-VSTeamTfvcBranches -ProjectName MyProject

         It 'should get 2 branches' {
            $res.Count | Should -Be 2
         }

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "$($VSTeamVersionTable.Account)/MyProject/_apis/tfvc/branches/?api-version=$($VSTeamVersionTable.Tfvc)"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranches with IncludeDeleted' {
         Mock Invoke-RestMethod { return $results } -Verifiable

         Get-VSTeamTfvcBranches -ProjectName MyProject -IncludeDeleted

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "$($VSTeamVersionTable.Account)/MyProject/_apis/tfvc/branches/?api-version=$($VSTeamVersionTable.Tfvc)&includeDeleted=True"
            }
         }
      }
   }

   Describe "Get-VSTeamTfvcBranches TFS" {

      $VSTeamVersionTable.Account = 'http://localhost:8080/tfs/defaultcollection'
      Mock _useWindowsAuthenticationOnPremise { return $true }
      
      Context 'Get-VSTeamTfvcBranches with no parameters' {
         Mock Invoke-RestMethod { return $results } -Verifiable

         $res = Get-VSTeamTfvcBranches -ProjectName MyProject

         It 'should get 2 branches' {
            $res.Count | Should -Be 2
         }

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "$($VSTeamVersionTable.Account)/MyProject/_apis/tfvc/branches/?api-version=$($VSTeamVersionTable.Tfvc)"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranches with IncludeDeleted' {
         Mock Invoke-RestMethod { return $results } -Verifiable

         Get-VSTeamTfvcBranches -ProjectName MyProject -IncludeDeleted

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "$($VSTeamVersionTable.Account)/MyProject/_apis/tfvc/branches/?api-version=$($VSTeamVersionTable.Tfvc)&includeDeleted=True"
            }
         }
      }
   }
  
   Describe "Get-VSTeamTfvcBranch VSTS" {

      $VSTeamVersionTable.Account = 'https://test.visualstudio.com'
      
      Context 'Get-VSTeamTfvcBranch with one path' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         Get-VSTeamTfvcBranch -ProjectName MyProject -Path $/MyProject/Master

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "$($VSTeamVersionTable.Account)/MyProject/_apis/tfvc/branches/?api-version=$($VSTeamVersionTable.Tfvc)&path=$/MyProject/Master"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with one path from pipeline' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         '$/MyProject/Master' | Get-VSTeamTfvcBranch -ProjectName MyProject

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "$($VSTeamVersionTable.Account)/MyProject/_apis/tfvc/branches/?api-version=$($VSTeamVersionTable.Tfvc)&path=$/MyProject/Master"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with two paths' {
         Mock Invoke-RestMethod { return $results } -Verifiable

         Get-VSTeamTfvcBranch -ProjectName MyProject -Path $/MyProject/Master,$/MyProject/Feature

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "$($VSTeamVersionTable.Account)/MyProject/_apis/tfvc/branches/?api-version=$($VSTeamVersionTable.Tfvc)&path=$/MyProject/Master"
            }
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "$($VSTeamVersionTable.Account)/MyProject/_apis/tfvc/branches/?api-version=$($VSTeamVersionTable.Tfvc)&path=$/MyProject/Feature"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with IncludeChildren' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         Get-VSTeamTfvcBranch -ProjectName MyProject -Path $/MyProject/Master -IncludeChildren

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "$($VSTeamVersionTable.Account)/MyProject/_apis/tfvc/branches/?api-version=$($VSTeamVersionTable.Tfvc)&path=$/MyProject/Master&includeChildren=True"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with IncludeParent' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         Get-VSTeamTfvcBranch -ProjectName MyProject -Path $/MyProject/Master -IncludeParent

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "$($VSTeamVersionTable.Account)/MyProject/_apis/tfvc/branches/?api-version=$($VSTeamVersionTable.Tfvc)&path=$/MyProject/Master&includeParent=True"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with IncludeDeleted' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         Get-VSTeamTfvcBranch -ProjectName MyProject -Path $/MyProject/Master -IncludeDeleted

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "$($VSTeamVersionTable.Account)/MyProject/_apis/tfvc/branches/?api-version=$($VSTeamVersionTable.Tfvc)&path=$/MyProject/Master&includeDeleted=True"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with all switches' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         Get-VSTeamTfvcBranch -ProjectName MyProject -Path $/MyProject/Master -IncludeChildren -IncludeParent -IncludeDeleted

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "$($VSTeamVersionTable.Account)/MyProject/_apis/tfvc/branches/?api-version=$($VSTeamVersionTable.Tfvc)&path=$/MyProject/Master&includeChildren=True&includeParent=True&includeDeleted=True"
            }
         }
      }
   }

   Describe "Get-VSTeamTfvcBranch TFS" {

      $VSTeamVersionTable.Account = 'http://localhost:8080/tfs/defaultcollection'
      Mock _useWindowsAuthenticationOnPremise { return $true }
      
      Context 'Get-VSTeamTfvcBranch with one path' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         Get-VSTeamTfvcBranch -ProjectName MyProject -Path $/MyProject/Master

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "$($VSTeamVersionTable.Account)/MyProject/_apis/tfvc/branches/?api-version=$($VSTeamVersionTable.Tfvc)&path=$/MyProject/Master"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with one path from pipeline' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         '$/MyProject/Master' | Get-VSTeamTfvcBranch -ProjectName MyProject

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "$($VSTeamVersionTable.Account)/MyProject/_apis/tfvc/branches/?api-version=$($VSTeamVersionTable.Tfvc)&path=$/MyProject/Master"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with two paths' {
         Mock Invoke-RestMethod { return $results } -Verifiable

         Get-VSTeamTfvcBranch -ProjectName MyProject -Path $/MyProject/Master,$/MyProject/Feature

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "$($VSTeamVersionTable.Account)/MyProject/_apis/tfvc/branches/?api-version=$($VSTeamVersionTable.Tfvc)&path=$/MyProject/Master"
            }
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "$($VSTeamVersionTable.Account)/MyProject/_apis/tfvc/branches/?api-version=$($VSTeamVersionTable.Tfvc)&path=$/MyProject/Feature"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with IncludeChildren' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         Get-VSTeamTfvcBranch -ProjectName MyProject -Path $/MyProject/Master -IncludeChildren

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "$($VSTeamVersionTable.Account)/MyProject/_apis/tfvc/branches/?api-version=$($VSTeamVersionTable.Tfvc)&path=$/MyProject/Master&includeChildren=True"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with IncludeParent' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         Get-VSTeamTfvcBranch -ProjectName MyProject -Path $/MyProject/Master -IncludeParent

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "$($VSTeamVersionTable.Account)/MyProject/_apis/tfvc/branches/?api-version=$($VSTeamVersionTable.Tfvc)&path=$/MyProject/Master&includeParent=True"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with IncludeDeleted' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         Get-VSTeamTfvcBranch -ProjectName MyProject -Path $/MyProject/Master -IncludeDeleted

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "$($VSTeamVersionTable.Account)/MyProject/_apis/tfvc/branches/?api-version=$($VSTeamVersionTable.Tfvc)&path=$/MyProject/Master&includeDeleted=True"
            }
         }
      }

      Context 'Get-VSTeamTfvcBranch with all switches' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         Get-VSTeamTfvcBranch -ProjectName MyProject -Path $/MyProject/Master -IncludeChildren -IncludeParent -IncludeDeleted

         It 'should call the REST endpoint with correct parameters' {
            Assert-MockCalled Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
               $Uri -eq "$($VSTeamVersionTable.Account)/MyProject/_apis/tfvc/branches/?api-version=$($VSTeamVersionTable.Tfvc)&path=$/MyProject/Master&includeChildren=True&includeParent=True&includeDeleted=True"
            }
         }
      }
   }
}