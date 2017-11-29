Set-StrictMode -Version Latest

Get-Module VSTeam | Remove-Module -Force
Get-Module team | Remove-Module -Force
Get-Module profile | Remove-Module -Force

Import-Module $PSScriptRoot\..\..\src\team.psm1 -Force
Import-Module $PSScriptRoot\..\..\src\profile.psm1 -Force

InModuleScope team {
   Describe 'Team' {
      . "$PSScriptRoot\mockProjectDynamicParam.ps1"

$contents = @"
      [
         {
            "Name": "http://localhost:8080/tfs/defaultcollection",
            "URL": "http://localhost:8080/tfs/defaultcollection",
            "Pat": "",
            "Type": "OnPremise",
            "Version": "TFS2017"
         },
         {
            "Name": "mydemos",
            "URL": "https://mydemos.visualstudio.com",
            "Pat": "OjEyMzQ1",
            "Type": "Pat",
            "Version": "VSTS"
         },
         {
            "Name": "demonstrations",
            "URL": "https://demonstrations.visualstudio.com",
            "Pat": "dzY2a2x5am13YWtkcXVwYmg0emE=",
            "Type": "Pat",
            "Version": "VSTS"
         }
      ]
"@      

      Context 'Get-VSTeamInfo' {
         It 'should return account and default project' {
            $VSTeamVersionTable.Account = "mydemos"
            $Global:PSDefaultParameterValues['*:projectName'] = 'MyProject'

            $info = Get-VSTeamInfo

            $info.Account | Should Be "mydemos"
            $info.DefaultProject | Should Be "MyProject"
         }
      }

      Context 'Add-VSTeamAccount profile' {
         Mock _isOnWindows { return $false }
         Mock _setEnvironmentVariables
         Mock Set-VSTeamAPIVersion
         Mock Get-VSTeamProfile { return $contents | ConvertFrom-Json | ForEach-Object { $_ } }

         It 'should set env at process level' {
            Add-VSTeamAccount -Profile mydemos

            Assert-MockCalled Set-VSTeamAPIVersion -Exactly -Scope It -Times 1 -ParameterFilter {
               $Version -eq 'VSTS'
            }

            # Make sure set env vars was called with the correct parameters
            Assert-MockCalled _setEnvironmentVariables -Exactly -Scope It -Times 1 -ParameterFilter {
               $Level -eq 'Process' -and $Pat -eq 'OjEyMzQ1' -and $Acct -eq 'https://mydemos.visualstudio.com'
            }
         }
      }

      Context 'Add-VSTeamAccount profile and drive' {
         Mock _isOnWindows { return $false }
         Mock _setEnvironmentVariables
         Mock Set-VSTeamAPIVersion
         Mock New-PSDrive -Verifiable
         Mock Get-VSTeamProfile { return $contents | ConvertFrom-Json | ForEach-Object { $_ } }

         It 'should set env at process level' {
            Add-VSTeamAccount -Profile mydemos -Drive mydemos

            Assert-VerifiableMocks

            Assert-MockCalled Set-VSTeamAPIVersion -Exactly -Scope It -Times 1 -ParameterFilter {
               $Version -eq 'VSTS'
            }

            # Make sure set env vars was called with the correct parameters
            Assert-MockCalled _setEnvironmentVariables -Exactly -Scope It -Times 1 -ParameterFilter {
               $Level -eq 'Process' -and $Pat -eq 'OjEyMzQ1' -and $Acct -eq 'https://mydemos.visualstudio.com'
            }
         }
      }

      Context 'Add-VSTeamAccount vsts' {
         Mock _isOnWindows { return $false }
         Mock _setEnvironmentVariables
         Mock Set-VSTeamAPIVersion

         It 'should set env at process level' {
            Add-VSTeamAccount -a mydemos -pe 12345 -Version VSTS

            Assert-MockCalled Set-VSTeamAPIVersion -Exactly -Scope It -Times 1 -ParameterFilter {
               $Version -eq 'VSTS'
            }

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
         Mock Set-VSTeamAPIVersion
         Mock _setEnvironmentVariables

         It 'should set env at process level' {
            Add-VSTeamAccount -a mydemos -pe 12345

            Assert-MockCalled Set-VSTeamAPIVersion -Exactly -Scope It -Times 1 -ParameterFilter {
               $Version -eq 'VSTS'
            }

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
         Mock Set-VSTeamAPIVersion
         Mock _setEnvironmentVariables

         It 'should set env at process level' {
            Add-VSTeamAccount -a mydemos -pe 12345

            Assert-MockCalled Set-VSTeamAPIVersion -Exactly -Scope It -Times 1 -ParameterFilter {
               $Version -eq 'VSTS'
            }

            # Make sure set env vars was called with the correct parameters
            Assert-MockCalled _setEnvironmentVariables -Exactly -Scope It -Times 1 -ParameterFilter {
               $Level -eq 'Process' -and $Pat -eq 'OjEyMzQ1' -and $Acct -eq 'https://mydemos.visualstudio.com'
            }
         }
      }

      Context 'Add-VSTeamAccount TFS' {
         # I have to write both test just in case the actually
         # start the PowerShell window as Admin or not. If I
         # don't write both of these I will get different code
         # coverage depending on if I started the PowerShell session
         # as admin or not.
         Mock _isOnWindows { return $false }
         Mock _testAdministrator { return $false }
         Mock Set-VSTeamAPIVersion
         Mock _setEnvironmentVariables

         It 'should set env at process level' {
            Add-VSTeamAccount -a http://localhost:8080/tfs/defaultcollection -pe 12345

            Assert-MockCalled Set-VSTeamAPIVersion -Exactly -Scope It -Times 1 -ParameterFilter {
               $Version -eq 'TFS2017'
            }

            # Make sure set env vars was called with the correct parameters
            Assert-MockCalled _setEnvironmentVariables -Exactly -Scope It -Times 1 -ParameterFilter {
               $Level -eq 'Process' -and $Pat -eq 'OjEyMzQ1' -and $Acct -eq 'http://localhost:8080/tfs/defaultcollection'
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
         Mock Set-VSTeamAPIVersion

         It 'should set env at user level' {
            Add-VSTeamAccount -a mydemos -pe 12345 -Level User

            Assert-MockCalled Set-VSTeamAPIVersion -Exactly -Scope It -Times 1 -ParameterFilter {
               $Version -eq 'VSTS'
            }

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