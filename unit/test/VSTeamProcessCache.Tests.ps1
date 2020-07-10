Set-StrictMode -Version Latest

Describe "VSTeamProcessCache" {
   BeforeAll {
      Import-Module SHiPS

      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamProcess.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProcessCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProcessTemplateCompleter.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamProcess.ps1"
      . "$PSScriptRoot/../../Source/Classes/$sut"
   }

   Context 'HasExpired' {
      BeforeAll {
         Mock Get-Date {
            return New-Object DateTime 1970, 1, 1, 0, 0, 0, ([DateTimeKind]::Utc)
         }
      }

      It 'Should false' {
         # Arrange
         # Above we mocked Get-Date to return a date with
         # a minute value of 0
         [VSTeamProcessCache]::timestamp = 0

         # Act
         $actual = [VSTeamProcessCache]::HasExpired()

         # Assert
         $actual | Should -Be $false
      }

      It 'Should return true' {
         # Arrange
         # Invalidate should set [VSTeamProcessCache]::timestamp
         # to -1 which will never be returned by the Minute
         # property of Get-Date so the cache should return
         # true from Has Expired
         [VSTeamProcessCache]::Invalidate()

         # Act
         $actual = [VSTeamProcessCache]::HasExpired()

         # Assert
         $actual | Should -Be $true
      }
   }

   Context 'GetCurrent' {
      BeforeAll {
         # Arrange
         Mock Get-VSTeamProcess {
            return @(
               [PSCustomObject]@{ Name = "Test1"; url = 'http://bogus.none/100' },
               [PSCustomObject]@{ Name = "Test2"; url = 'http://bogus.none/101' }
            )
         }

         Mock Get-Date {
            return New-Object DateTime 1970, 1, 1, 0, 15, 0, ([DateTimeKind]::Utc)
         }

         # Act
         [VSTeamProcessCache]::Invalidate()
         $actual = [VSTeamProcessCache]::GetCurrent()
      }

      It 'Should call Get-VSTeamProcess' {
         Should -Invoke Get-VSTeamProcess -Exactly -Scope Context -Times 1
      }

      It 'Should return array' {
         # Assert
         $actual.length | Should -Be 2
      }

      It 'Should set timestamp' {
         # Assert
         [VSTeamProcessCache]::timestamp | Should -Be 15
      }
   }

   Context 'GetURl' {
      BeforeAll {
         # Arrange
         Mock Get-VSTeamProcess {
            return @(
               [PSCustomObject]@{ Name = "Test1"; url = 'http://bogus.none/100' },
               [PSCustomObject]@{ Name = "Test2"; url = 'http://bogus.none/101' }
            )
         }

         Mock Get-Date {
            return New-Object DateTime 1970, 1, 1, 0, 15, 0, ([DateTimeKind]::Utc)
         }

         # Act
         [VSTeamProcessCache]::Invalidate()
         $actual = [VSTeamProcessCache]::GetURL("Test1")
      }

      It 'Should call Get-VSTeamProcess' {
         Should -Invoke Get-VSTeamProcess -Exactly -Scope Context -Times 1
      }

      It 'Should return cache entry' {
         # Assert
         $actual | Should -Not -Be $null
      }

      It 'Should set timestamp' {
         # Assert
         [VSTeamProcessCache]::timestamp | Should -Be 15
      }
   }

   Context 'Update with provided list' {
      BeforeAll {
         # Arrange
         Mock Get-VSTeamProcess

         Mock Get-Date {
            return New-Object DateTime 1970, 1, 1, 0, 15, 0, ([DateTimeKind]::Utc)
         }

         $list = @(
            [PSCustomObject]@{ Name = "Test1"; url = 'http://bogus.none/100' },
            [PSCustomObject]@{ Name = "Test2"; url = 'http://bogus.none/101' }
         )

         # Act
         [VSTeamProcessCache]::Update($list)
      }

      It 'Should call Get-VSTeamProcess' {
         Should -Invoke Get-VSTeamProcess -Exactly -Scope Context -Times 0
      }

      It 'Should return array' {
         # Assert
         [VSTeamProcessCache]::processes.length | Should -Be 2
      }

      It 'Should set timestamp' {
         # Assert
         [VSTeamProcessCache]::timestamp | Should -Be 15
      }
   }

   Context 'Update with empty list' {
      BeforeAll {
         # Arrange
         Mock Get-VSTeamProcess {
            return @()
         }

         Mock Get-Date {
            return New-Object DateTime 1970, 1, 1, 0, 15, 0, ([DateTimeKind]::Utc)
         }

         # Act
         [VSTeamProcessCache]::Update($null)
      }

      It 'Should call Get-VSTeamProcess' {
         Should -Invoke Get-VSTeamProcess -Exactly -Scope Context -Times 1
      }

      It 'Should return empty array' {
         # Assert
         [VSTeamProcessCache]::processes.length | Should -Be 0
      }

      It 'Should set timestamp' {
         # Assert
         [VSTeamProcessCache]::timestamp | Should -Be 15
      }
   }
}