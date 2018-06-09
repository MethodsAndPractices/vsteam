#Set-StrictMode -Version Latest

# Remove any loaded version of this module so only the files
# imported below are being tested.
Get-Module VSTeam | Remove-Module -Force

# Load the modules we want to test and any dependencies
Import-Module $PSScriptRoot\..\..\src\team.psm1 -Force

. "$PSScriptRoot\..\..\src\common.ps1"

Describe 'Common' {
   Context '_buildProjectNameDynamicParam set Alias' {
      Mock _getProjects

      $actual = _buildProjectNameDynamicParam -AliasName TestAlias

      It 'Should set the alias of dynamic parameter' {
         $actual["ProjectName"].Attributes[1].AliasNames | Should Be 'TestAlias'
      }
   }

   Context '_getUserAgent on Mac' {
      Mock _isOnWindows { return $false }
      Mock _isOnMac { return $true }
      Mock _isOnLinux { return $false }
      $VSTeamVersionTable.ModuleVersion = '0.0.0'

      $actual = _getUserAgent

      It 'Should return User Agent for OSx' {
         $actual | Should BeLike '*OSX*'
      }

      It 'Should return User Agent for Module Version' {
         $actual | Should BeLike '*0.0.0*'
      }

      It 'Should return User Agent for PowerShell Version' {
         $actual | Should BeLike "*$($PSVersionTable.PSVersion.ToString())*"
      }
   }

   Context '_getUserAgent on Linux' {
      Mock _isOnWindows { return $false }
      Mock _isOnMac { return $false }
      Mock _isOnLinux { return $true }
      $VSTeamVersionTable.ModuleVersion = '0.0.0'

      $actual = _getUserAgent

      It 'Should return User Agent for Linux' {
         $actual | Should BeLike '*Linux*'
      }

      It 'Should return User Agent for Module Version' {
         $actual | Should BeLike '*0.0.0*'
      }

      It 'Should return User Agent for PowerShell Version' {
         $actual | Should BeLike "*$($PSVersionTable.PSVersion.ToString())*"
      }
   }

   Context '_buildProjectNameDynamicParam' {
      Mock _getProjects { return  ConvertFrom-Json '["Demo", "Universal"]' }
     
      It 'should return dynamic parameter' {
         _buildProjectNameDynamicParam | Should Not BeNullOrEmpty
      }
   }

   Context '_getWorkItemTypes' {
      $VSTeamVersionTable.Account = $null

      It 'should return empty array' {
         _getWorkItemTypes -ProjectName test | Should be @()
      }
   }

   Context '_handleException' {
      $obj = "{Value: {Message: 'Top Message'}, Exception: {Message: 'Test Exception', Response: { StatusCode: '401'}}}"
      $ex = ConvertFrom-Json $obj

      It 'Should Write two warnings' {
         Mock ConvertFrom-Json { return $ex }
         Mock Write-Warning -ParameterFilter { $Message -eq 'An error occurred: Test Exception'} -Verifiable
         Mock Write-Warning -ParameterFilter { $Message -eq 'Top Message' } -Verifiable

         _handleException $ex

         Assert-VerifiableMock
      }
   }

   Context '_handleException message only' {
      $obj = "{Exception: {Message: 'Test Exception'}, Message: 'Test Exception'}"
      $ex = ConvertFrom-Json $obj

      It 'Should Write one warnings' {
         Mock ConvertFrom-Json { return $ex }
         Mock Write-Warning -ParameterFilter { $Message -eq 'Test Exception' } -Verifiable

         _handleException $ex

         Assert-VerifiableMock
      }
   }

   Context '_openOnWindows' {
      Mock Start-Process -Verifiable -ParameterFilter { $FilePath -eq 'http://test.visualstudio.com' }
      Mock Start-Process { throw "Start-Process called incorrectly: $Args" }

      _openOnWindows 'http://test.visualstudio.com'

      It 'should call start process' {
         Assert-VerifiableMock
      }
   }

   Context '_openOnMac' {
      Mock Start-Process -Verifiable -ParameterFilter { $FilePath -eq 'open' -and $ArgumentList -eq 'http://test.visualstudio.com' }
      Mock Start-Process { throw "Start-Process called incorrectly: $Args" }

      _openOnMac 'http://test.visualstudio.com'

      It 'should call start process' {
         Assert-VerifiableMock
      }
   }

   Context '_openOnLinux' {
      Mock Start-Process -Verifiable -ParameterFilter { $FilePath -eq 'xdg-open' -and $ArgumentList -eq 'http://test.visualstudio.com' }
      Mock Start-Process { throw "Start-Process called incorrectly: $Args" }

      _openOnLinux 'http://test.visualstudio.com'

      It 'should call start process' {
         Assert-VerifiableMock
      }
   }

   Context '_isOnLinux' {
      It 'on PowerShell 5.* should return false' {
         Mock Test-Path { return $false }
         
         _isOnLinux | Should Be $false
      }

      It 'using IsLinux should return true' {
         Mock Test-Path { return $true } -ParameterFilter { $Path -eq 'variable:global:IsLinux'} -Verifiable
         Mock Get-Content { return $true } -ParameterFilter { $Path -eq 'variable:global:IsLinux'} -Verifiable

         Mock Test-Path { throw "Wrong call to Test-Path: $args" }
         Mock Get-Content { throw "Wrong call to Get-Content: $args" }

         _isOnLinux | Should Be $true
         Assert-VerifiableMock
      }
   }

   Context '_isOnWindows on PowerShell 5.* ' {
      Mock Test-Path { return $false } { $Path -eq 'variable:global:IsWindows'} -Verifiable
      Mock Test-Path { return $true } { $Path -eq 'env:os'} -Verifiable
      Mock Get-Content { return 'Windows_NT' } -ParameterFilter { $Path -eq 'env:os'} -Verifiable

      Mock Test-Path { throw "Wrong call to Test-Path: $args" }
      Mock Get-Content { throw "Wrong call to Get-Content: $args" }

      It 'should return true' {
         _isOnWindows | Should Be $true
         Assert-VerifiableMock
      }
   }

   Context '_isOnWindows using IsWindows ' {
      Mock Test-Path { return $true } -ParameterFilter { $Path -eq 'variable:global:IsWindows'} -Verifiable
      Mock Get-Content { return $true } -ParameterFilter { $Path -eq 'variable:global:IsWindows'} -Verifiable

      Mock Test-Path { throw "Wrong call to Test-Path: $args" }
      Mock Get-Content { throw "Wrong call to Get-Content: $args" }
      
      It 'should return true' {
         _isOnWindows | Should Be $true
         Assert-VerifiableMock
      }
   }

   Context '_isOnWindows' {
      Mock Test-Path { return $false } -Verifiable
      Mock Get-Content { throw "Wrong call to Get-Content: $args" }

      It 'using IsWindows should return false' {
         _isOnWindows | Should Be $false
         Assert-VerifiableMock
      }
   }

   Context '_isOnMac' {
      It 'on PowerShell 5.* should return false' {
         Mock Test-Path { return $false }
         
         _isOnMac | Should Be $false
      }

      It 'using IsMacOS should return true' {
         Mock Test-Path { return $true } -ParameterFilter { $Path -eq 'variable:global:IsMacOS'} -Verifiable
         Mock Get-Content { return $true } -ParameterFilter { $Path -eq 'variable:global:IsMacOS'} -Verifiable

         Mock Test-Path { throw "Wrong call to Test-Path: $args" }
         Mock Get-Content { throw "Wrong call to Get-Content: $args" }

         _isOnMac | Should Be $true
         Assert-VerifiableMock
      }

      It 'using IsOSX should return false' {
         Mock Test-Path { return $false } -ParameterFilter { $Path -eq 'variable:global:IsMacOS'} -Verifiable
         Mock Test-Path { return $true } -ParameterFilter { $Path -eq 'variable:global:IsOSX'} -Verifiable
         Mock Get-Content { return $false } -ParameterFilter { $Path -eq 'variable:global:IsOSX'} -Verifiable

         Mock Test-Path { throw "Wrong call to Test-Path: $args" }
         Mock Get-Content { throw "Wrong call to Get-Content: $args" }

         _isOnMac | Should Be $false
         Assert-VerifiableMock
      }
   }

   Context '_isVSTS' {     
      It 'should return true' {
         _isVSTS 'https://test.visualstudio.com' | Should Be $true
      }

      It 'with / should return true' {
         _isVSTS 'https://test.visualstudio.com/' | Should Be $true
      }

      It 'should return false' {
         _isVSTS 'http://localhost:8080/tfs/defaultcollection' | Should Be $false
      }
   }
}