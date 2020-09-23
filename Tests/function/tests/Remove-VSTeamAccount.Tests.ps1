Set-StrictMode -Version Latest

Describe 'Remove-VSTeamAccount' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      Mock _clearEnvironmentVariables
   }

   Context 'Remove-VSTeamAccount run as administrator' {
      BeforeAll {
         Mock _isOnWindows { return $true }
         Mock _testAdministrator { return $true }
      }

      It 'should clear env at process level' {
         Remove-VSTeamAccount

         # Assert
         # Make sure set env vars was called with the correct parameters
         Should -Invoke _clearEnvironmentVariables -Exactly -Scope It -Times 1 -ParameterFilter {
            $Level -eq 'Process'
         }
      }
   }

   Context 'Remove-VSTeamAccount run as normal user' {
      BeforeAll {
         Mock _isOnWindows { return $true }
         Mock _testAdministrator { return $false }
      }

      It 'should clear env at process level' {
         # Act
         Remove-VSTeamAccount

         # Assert
         # Make sure set env vars was called with the correct parameters
         Should -Invoke _clearEnvironmentVariables -Exactly -Scope It -Times 1 -ParameterFilter {
            $Level -eq 'Process'
         }
      }
   }

   Context 'Remove-VSTeamAccount with no arguments' {
      BeforeAll {
         Mock _isOnWindows { return $false }
      }

      It 'should clear env at process level' {
         # Act
         Remove-VSTeamAccount

         # Assert
         # Make sure set env vars was called with the correct parameters
         Should -Invoke _clearEnvironmentVariables -Exactly -Scope It -Times 1 -ParameterFilter {
            $Level -eq 'Process'
         }
      }
   }

   Context 'Remove-VSTeamAccount at user level' {
      BeforeAll {
         Mock _isOnWindows { return $true }
         Mock _testAdministrator { return $false }
      }

      It 'should clear env at user level' {
         # Act
         Remove-VSTeamAccount -Level User

         # Assert
         # Make sure set env vars was called with the correct parameters
         Should -Invoke _clearEnvironmentVariables -Exactly -Scope It -Times 1 -ParameterFilter {
            $Level -eq 'User'
         }
      }
   }

   Context 'Remove-VSTeamAccount at all levels as administrator' {
      BeforeAll {
         Mock _isOnWindows { return $true }
         Mock _testAdministrator { return $true }
      }

      It 'should clear env at all levels' {
         # Act
         Remove-VSTeamAccount -Level All

         # Assert
         Should -Invoke _clearEnvironmentVariables -Exactly -Scope It -Times 1 -ParameterFilter {
            $Level -eq 'User'
         }

         Should -Invoke _clearEnvironmentVariables -Exactly -Scope It -Times 1 -ParameterFilter {
            $Level -eq 'Process'
         }

         Should -Invoke _clearEnvironmentVariables -Exactly -Scope It -Times 1 -ParameterFilter {
            $Level -eq 'Machine'
         }
      }
   }

   Context 'Remove-VSTeamAccount at all levels as normal user' {
      BeforeAll {
         Mock Write-Warning
         Mock _isOnWindows { return $true }
         Mock _testAdministrator { return $false }
      }

      It 'should clear env at all levels' {
         # Act
         Remove-VSTeamAccount -Level All

         # Assert
         Should -Invoke _clearEnvironmentVariables -Exactly -Scope It -Times 1 -ParameterFilter {
            $Level -eq 'User'
         }

         Should -Invoke _clearEnvironmentVariables -Exactly -Scope It -Times 1 -ParameterFilter {
            $Level -eq 'Process'
         }

         Should -Invoke _clearEnvironmentVariables -Exactly -Scope It -Times 0 -ParameterFilter {
            $Level -eq 'Machine'
         }
      }
   }
}