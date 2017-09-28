Set-StrictMode -Version Latest

Get-Module team | Remove-Module -Force
Import-Module $PSScriptRoot\..\..\src\team.psm1 -Force

InModuleScope team {
   Describe 'Team' {
      . "$PSScriptRoot\mockProjectDynamicParam.ps1"

      Context 'Get-VSTeamInfo' {
         It 'should return account and default project' {
            $env:TEAM_ACCT = "mydemos"
            $Global:PSDefaultParameterValues['*:projectName'] = 'MyProject'

            $info = Get-VSTeamInfo

            $info.Account | Should Be "mydemos"
            $info.DefaultProject | Should Be "MyProject"
         }
      }

      Context 'Add-VSTeamAccount vsts' {
         Mock _isOnWindows { return $false }
         Mock _setEnvironmentVariables

         It 'should set env at process level' {
            Add-VSTeamAccount -a mydemos -pe 12345

            # Make sure set env vars was called with the correct parameters
            Assert-MockCalled _setEnvironmentVariables -Exactly -Scope It -Times 1 -ParameterFilter {
               $Level -eq 'Process' -and $Pat -eq 'OjEyMzQ1' -and $Acct -eq 'https://mydemos.visualstudio.com'
            }
         }
      }

      Context 'Add-VSTeamAccount run as administrator' {
         # I have to write both test just in case the actually
         # start the PowerShell window as Admin or not. If I
         # don't write both of these I will get different code
         # coverage depending on if I started the PowerShell session
         # as admin or not.
         Mock _isOnWindows { return $true }
         Mock _testAdministrator { return $true }
         Mock _setEnvironmentVariables

         It 'should set env at process level' {
            Add-VSTeamAccount -a mydemos -pe 12345

            # Make sure set env vars was called with the correct parameters
            Assert-MockCalled _setEnvironmentVariables -Exactly -Scope It -Times 1 -ParameterFilter {
               $Level -eq 'Process' -and $Pat -eq 'OjEyMzQ1' -and $Acct -eq 'https://mydemos.visualstudio.com'
            }
         }
      }

      Context 'Add-VSTeamAccount run as normal user' {
         # I have to write both test just in case the actually
         # start the PowerShell window as Admin or not. If I
         # don't write both of these I will get different code
         # coverage depending on if I started the PowerShell session
         # as admin or not.
         Mock _isOnWindows { return $false }
         Mock _testAdministrator { return $false }
         Mock _setEnvironmentVariables

         It 'should set env at process level' {
            Add-VSTeamAccount -a mydemos -pe 12345

            # Make sure set env vars was called with the correct parameters
            Assert-MockCalled _setEnvironmentVariables -Exactly -Scope It -Times 1 -ParameterFilter {
               $Level -eq 'Process' -and $Pat -eq 'OjEyMzQ1' -and $Acct -eq 'https://mydemos.visualstudio.com'
            }
         }
      }

      Context 'Add-VSTeamAccount at user level on Windows machine' {
         # This is only supported on a Windows machine. So we have
         # to Mock the call to _isOnWindows so you can develop on a
         # Mac or Linux machine.
         Mock _isOnWindows { return $true }

         # Have to Mock this because you can't call
         # [Security.Principal.WindowsIdentity]::GetCurrent()
         # on Mac and Linux
         Mock _testAdministrator { return $false }
         Mock _setEnvironmentVariables

         It 'should set env at user level' {
            Add-VSTeamAccount -a mydemos -pe 12345 -Level User

            # Make sure set env vars was called with the correct parameters
            Assert-MockCalled _setEnvironmentVariables -Exactly -Scope It -Times 1 -ParameterFilter {
               $Level -eq 'User' -and $Pat -eq 'OjEyMzQ1' -and $Acct -eq 'https://mydemos.visualstudio.com'
            }
         }
      }

      Context 'Remove-TeamAccount run as administrator' {
         Mock _isOnWindows { return $true }
         Mock _testAdministrator { return $true }
         Mock _clearEnvironmentVariables

         It 'should clear env at process level' {
            Remove-TeamAccount

            # Assert
            # Make sure set env vars was called with the correct parameters
            Assert-MockCalled _clearEnvironmentVariables -Exactly -Scope It -Times 1 -ParameterFilter {
               $Level -eq 'Process'
            }
         }
      }

      Context 'Remove-TeamAccount run as normal user' {
         Mock _isOnWindows { return $true }
         Mock _testAdministrator { return $false }
         Mock _clearEnvironmentVariables

         It 'should clear env at process level' {
            # Act
            Remove-TeamAccount

            # Assert
            # Make sure set env vars was called with the correct parameters
            Assert-MockCalled _clearEnvironmentVariables -Exactly -Scope It -Times 1 -ParameterFilter {
               $Level -eq 'Process'
            }
         }
      }

      Context 'Remove-TeamAccount with no arguments' {
         Mock _isOnWindows { return $false }
         Mock _clearEnvironmentVariables

         It 'should clear env at process level' {
            # Act
            Remove-TeamAccount

            # Assert
            # Make sure set env vars was called with the correct parameters
            Assert-MockCalled _clearEnvironmentVariables -Exactly -Scope It -Times 1 -ParameterFilter {
               $Level -eq 'Process'
            }
         }
      }

      Context 'Remove-TeamAccount at user level' {
         Mock _isOnWindows { return $true }
         Mock _testAdministrator { return $false }
         Mock _clearEnvironmentVariables

         It 'should clear env at user level' {
            # Act
            Remove-TeamAccount -Level User

            # Assert
            # Make sure set env vars was called with the correct parameters
            Assert-MockCalled _clearEnvironmentVariables -Exactly -Scope It -Times 1 -ParameterFilter {
               $Level -eq 'User'
            }
         }
      }

      Context 'Remove-TeamAccount at all levels as administrator' {
         Mock _testAdministrator { return $true }
         Mock _isOnWindows { return $true }
         Mock _clearEnvironmentVariables

         It 'should clear env at all levels' {
            # Act
            Remove-TeamAccount -Level All

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

      Context 'Remove-TeamAccount at all levels as normal user' {
         Mock _testAdministrator { return $false }
         Mock _isOnWindows { return $true }
         Mock Write-Warning
         Mock _clearEnvironmentVariables

         It 'should clear env at all levels' {
            # Act
            Remove-TeamAccount -Level All

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

      Context 'Set-VSTeamDefaultProject' {
         It 'should set default project' {
            Set-VSTeamDefaultProject 'MyProject'

            $Global:PSDefaultParameterValues['*:projectName'] | Should be 'MyProject'
         }

         It 'should update default project' {
            $Global:PSDefaultParameterValues['*:projectName'] = 'MyProject'

            Set-VSTeamDefaultProject -Project 'NextProject'

            $Global:PSDefaultParameterValues['*:projectName'] | Should be 'NextProject'
         }
      }

      Context 'Clear-VSTeamDefaultProject' {
         It 'should clear default project' {
            $Global:PSDefaultParameterValues['*:projectName'] = 'MyProject'

            Clear-VSTeamDefaultProject

            $Global:PSDefaultParameterValues['*:projectName'] | Should BeNullOrEmpty
         }
      }
   }
}