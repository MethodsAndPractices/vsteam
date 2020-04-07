Set-StrictMode -Version Latest
$env:Testing=$true
# The InModuleScope command allows you to perform white-box unit testing on the
# internal \(non-exported\) code of a Script Module, ensuring the module is loaded.
InModuleScope VSTeam {
Describe 'Remove-VSTeamAccount' {
      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter {
         $Uri -like "*_apis/projects*"
      }

      . "$PSScriptRoot\mocks\mockProjectDynamicParamMandatoryFalse.ps1"

      Context 'Remove-VSTeamAccount run as administrator' {
         Mock _isOnWindows { return $true }
         Mock _testAdministrator { return $true }
         Mock _clearEnvironmentVariables

         It 'should clear env at process level' {
            Remove-VSTeamAccount

            # Assert
            # Make sure set env vars was called with the correct parameters
            Assert-MockCalled _clearEnvironmentVariables -Exactly -Scope It -Times 1 -ParameterFilter {
               $Level -eq 'Process'
            }
         }
      }

      Context 'Remove-VSTeamAccount run as normal user' {
         Mock _isOnWindows { return $true }
         Mock _testAdministrator { return $false }
         Mock _clearEnvironmentVariables

         It 'should clear env at process level' {
            # Act
            Remove-VSTeamAccount

            # Assert
            # Make sure set env vars was called with the correct parameters
            Assert-MockCalled _clearEnvironmentVariables -Exactly -Scope It -Times 1 -ParameterFilter {
               $Level -eq 'Process'
            }
         }
      }

      Context 'Remove-VSTeamAccount with no arguments' {
         Mock _isOnWindows { return $false }
         Mock _clearEnvironmentVariables

         It 'should clear env at process level' {
            # Act
            Remove-VSTeamAccount

            # Assert
            # Make sure set env vars was called with the correct parameters
            Assert-MockCalled _clearEnvironmentVariables -Exactly -Scope It -Times 1 -ParameterFilter {
               $Level -eq 'Process'
            }
         }
      }

      Context 'Remove-VSTeamAccount at user level' {
         Mock _isOnWindows { return $true }
         Mock _testAdministrator { return $false }
         Mock _clearEnvironmentVariables

         It 'should clear env at user level' {
            # Act
            Remove-VSTeamAccount -Level User

            # Assert
            # Make sure set env vars was called with the correct parameters
            Assert-MockCalled _clearEnvironmentVariables -Exactly -Scope It -Times 1 -ParameterFilter {
               $Level -eq 'User'
            }
         }
      }

      Context 'Remove-VSTeamAccount at all levels as administrator' {
         Mock _testAdministrator { return $true }
         Mock _isOnWindows { return $true }
         Mock _clearEnvironmentVariables

         It 'should clear env at all levels' {
            # Act
            Remove-VSTeamAccount -Level All

            # Assert
            Assert-MockCalled _clearEnvironmentVariables -Exactly -Scope It -Times 1 -ParameterFilter {
               $Level -eq 'User'
            }

            Assert-MockCalled _clearEnvironmentVariables -Exactly -Scope It -Times 1 -ParameterFilter {
               $Level -eq 'Process'
            }

            Assert-MockCalled _clearEnvironmentVariables -Exactly -Scope It -Times 1 -ParameterFilter {
               $Level -eq 'Machine'
            }
         }
      }

      Context 'Remove-VSTeamAccount at all levels as normal user' {
         Mock _testAdministrator { return $false }
         Mock _isOnWindows { return $true }
         Mock Write-Warning
         Mock _clearEnvironmentVariables

         It 'should clear env at all levels' {
            # Act
            Remove-VSTeamAccount -Level All

            # Assert
            Assert-MockCalled _clearEnvironmentVariables -Exactly -Scope It -Times 1 -ParameterFilter {
               $Level -eq 'User'
            }

            Assert-MockCalled _clearEnvironmentVariables -Exactly -Scope It -Times 1 -ParameterFilter {
               $Level -eq 'Process'
            }

            Assert-MockCalled _clearEnvironmentVariables -Exactly -Scope It -Times 0 -ParameterFilter {
               $Level -eq 'Machine'
            }
         }
      }
   }
}