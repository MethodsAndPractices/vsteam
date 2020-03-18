Set-StrictMode -Version Latest
$env:Testing=$true
# The InModuleScope command allows you to perform white-box unit testing on the
# internal \(non-exported\) code of a Script Module, ensuring the module is loaded.
InModuleScope VSTeam {
   Describe 'Set-VSTeamAccount' {
      $contents = @"
      [
         {
            "Name": "http://localhost:8080/tfs/defaultcollection",
            "URL": "http://localhost:8080/tfs/defaultcollection",
            "Pat": "",
            "Type": "OnPremise",
            "Version": "TFS2017",
            "Token": ""
         },
         {
            "Name": "mydemos",
            "URL": "https://dev.azure.com/mydemos",
            "Pat": "OjEyMzQ1",
            "Type": "Pat",
            "Token": "",
            "Version": "VSTS"
         },
         {
            "Name": "demonstrations",
            "URL": "https://dev.azure.com/demonstrations",
            "Pat": "dzY2a2x5am13YWtkcXVwYmg0emE=",
            "Type": "Pat",
            "Token": "",
            "Version": "VSTS"
         }
      ]
"@

      AfterAll {
         Remove-VSTeamAccount
      }

      Context 'You cannot use -UseWindowsAuthentication with Azd' {
         # This is only supported on a Windows machine. So we have
         # to Mock the call to _isOnWindows so you can develop on a
         # Mac or Linux machine.
         Mock _isOnWindows { return $true }

         # Have to Mock this because you can't call
         # [Security.Principal.WindowsIdentity]::GetCurrent()
         # on Mac and Linux
         Mock _testAdministrator { return $false }

         Mock Write-Error { } -Verifiable

         It 'Should return error' {
            Set-VSTeamAccount -Account test -UseWindowsAuthentication
            Assert-VerifiableMock
         }
      }

      Context 'Set-VSTeamAccount invalid profile' {
         Mock _isOnWindows { return $false }
         Mock Write-Error -Verifiable
         Mock Get-VSTeamProfile { return "[]" | ConvertFrom-Json | ForEach-Object { $_ } }

         Set-VSTeamAccount -Profile notFound

         It 'should write error' {
            Assert-VerifiableMock
         }
      }

      Context 'Set-VSTeamAccount profile' {
         Mock _isOnWindows { return $false }
         Mock _setEnvironmentVariables
         Mock Set-VSTeamAPIVersion
         Mock Get-VSTeamProfile { return $contents | ConvertFrom-Json | ForEach-Object { $_ } }

         It 'should set env at process level' {
            Set-VSTeamAccount -Profile mydemos

            Assert-MockCalled Set-VSTeamAPIVersion -Exactly -Scope It -Times 1 -ParameterFilter {
               $Target -eq 'VSTS'
            }

            # Make sure set env vars was called with the correct parameters
            Assert-MockCalled _setEnvironmentVariables -Exactly -Scope It -Times 1 -ParameterFilter {
               $Level -eq 'Process' -and $Pat -eq 'OjEyMzQ1' -and $Acct -eq 'https://dev.azure.com/mydemos'
            }
         }
      }

      Context 'Set-VSTeamAccount profile and drive' {
         Mock _isOnWindows { return $false }
         Mock _setEnvironmentVariables
         Mock Set-VSTeamAPIVersion
         Mock Write-Output -Verifiable
         Mock Get-VSTeamProfile { return $contents | ConvertFrom-Json | ForEach-Object { $_ } }

         It 'should set env at process level' {
            Set-VSTeamAccount -Profile mydemos -Drive mydemos

            Assert-VerifiableMock

            Assert-MockCalled Set-VSTeamAPIVersion -Exactly -Scope It -Times 1 -ParameterFilter {
               $Target -eq 'VSTS'
            }

            # Make sure set env vars was called with the correct parameters
            Assert-MockCalled _setEnvironmentVariables -Exactly -Scope It -Times 1 -ParameterFilter {
               $Level -eq 'Process' -and $Pat -eq 'OjEyMzQ1' -and $Acct -eq 'https://dev.azure.com/mydemos'
            }
         }
      }

      Context 'Set-VSTeamAccount vsts' {
         Mock _isOnWindows { return $false }
         Mock _setEnvironmentVariables
         Mock Set-VSTeamAPIVersion

         It 'should set env at process level' {
            Set-VSTeamAccount -a mydemos -pe 12345 -Version VSTS

            Assert-MockCalled Set-VSTeamAPIVersion -Exactly -Scope It -Times 1 -ParameterFilter {
               $Target -eq 'VSTS'
            }

            # Make sure set env vars was called with the correct parameters
            Assert-MockCalled _setEnvironmentVariables -Exactly -Scope It -Times 1 -ParameterFilter {
               $Level -eq 'Process' -and $Pat -eq 'OjEyMzQ1' -and $Acct -eq 'https://dev.azure.com/mydemos'
            }
         }
      }

      Context 'Set-VSTeamAccount vsts (old URL)' {
         Mock _isOnWindows { return $false }
         Mock _setEnvironmentVariables
         Mock Set-VSTeamAPIVersion

         It 'should set env at process level' {
            Set-VSTeamAccount -a https://mydemos.visualstudio.com -pe 12345 -Version VSTS

            Assert-MockCalled Set-VSTeamAPIVersion -Exactly -Scope It -Times 1 -ParameterFilter {
               $Target -eq 'VSTS'
            }

            # Make sure set env vars was called with the correct parameters
            Assert-MockCalled _setEnvironmentVariables -Exactly -Scope It -Times 1 -ParameterFilter {
               $Level -eq 'Process' -and $Pat -eq 'OjEyMzQ1' -and $Acct -eq 'https://dev.azure.com/mydemos'
            }
         }
      }

      Context 'Set-VSTeamAccount vsts OAuth' {
         Mock _isOnWindows { return $false }
         Mock _setEnvironmentVariables
         Mock Set-VSTeamAPIVersion

         It 'should set env at process level' {
            Set-VSTeamAccount -a mydemos -pe 12345 -Version VSTS -UseBearerToken

            Assert-MockCalled Set-VSTeamAPIVersion -Exactly -Scope It -Times 1 -ParameterFilter {
               $Target -eq 'VSTS'
            }

            # Make sure set env vars was called with the correct parameters
            Assert-MockCalled _setEnvironmentVariables -Exactly -Scope It -Times 1 -ParameterFilter {
               $Level -eq 'Process' -and $Pat -eq '' -and $BearerToken -eq 12345 -and $Acct -eq 'https://dev.azure.com/mydemos'
            }
         }
      }

      Context 'Set-VSTeamAccount vsts with securePersonalAccessToken' {
         Mock _isOnWindows { return $false }
         Mock _setEnvironmentVariables
         Mock Set-VSTeamAPIVersion

         It 'should set env at process level' {
            $password = '12345' | ConvertTo-SecureString -AsPlainText -Force

            Set-VSTeamAccount -a mydemos -SecurePersonalAccessToken $password -Version VSTS

            Assert-MockCalled Set-VSTeamAPIVersion -Exactly -Scope It -Times 1 -ParameterFilter {
               $Target -eq 'VSTS'
            }

            # Make sure set env vars was called with the correct parameters
            Assert-MockCalled _setEnvironmentVariables -Exactly -Scope It -Times 1 -ParameterFilter {
               $Level -eq 'Process' -and $Pat -eq 'OjEyMzQ1' -and $Acct -eq 'https://dev.azure.com/mydemos'
            }
         }
      }

      Context 'Set-VSTeamAccount run as administrator' {
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
            Set-VSTeamAccount -a mydemos -pe 12345

            Assert-MockCalled Set-VSTeamAPIVersion -Exactly -Scope It -Times 1 -ParameterFilter {
               $Target -eq 'VSTS'
            }

            # Make sure set env vars was called with the correct parameters
            Assert-MockCalled _setEnvironmentVariables -Exactly -Scope It -Times 1 -ParameterFilter {
               $Level -eq 'Process' -and $Pat -eq 'OjEyMzQ1' -and $Acct -eq 'https://dev.azure.com/mydemos'
            }
         }
      }

      Context 'Set-VSTeamAccount run as normal user' {
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
            Set-VSTeamAccount -a mydemos -pe 12345

            Assert-MockCalled Set-VSTeamAPIVersion -Exactly -Scope It -Times 1 -ParameterFilter {
               $Target -eq 'VSTS'
            }

            # Make sure set env vars was called with the correct parameters
            Assert-MockCalled _setEnvironmentVariables -Exactly -Scope It -Times 1 -ParameterFilter {
               $Level -eq 'Process' -and $Pat -eq 'OjEyMzQ1' -and $Acct -eq 'https://dev.azure.com/mydemos'
            }
         }
      }

      Context 'Set-VSTeamAccount TFS from windows' {
         # I have to write both test just in case the actually
         # start the PowerShell window as Admin or not. If I
         # don't write both of these I will get different code
         # coverage depending on if I started the PowerShell session
         # as admin or not.
         Mock _isOnWindows { return $true }
         Mock _testAdministrator { return $false }
         Mock Set-VSTeamAPIVersion
         Mock _setEnvironmentVariables

         It 'should set env at process level' {
            Set-VSTeamAccount -a http://localhost:8080/tfs/defaultcollection -UseWindowsAuthentication

            Assert-MockCalled Set-VSTeamAPIVersion -Exactly -Scope It -Times 1 -ParameterFilter {
               $Target -eq 'TFS2017'
            }

            # Make sure set env vars was called with the correct parameters
            Assert-MockCalled _setEnvironmentVariables -Exactly -Scope It -Times 1 -ParameterFilter {
               $Level -eq 'Process' -and $Acct -eq 'http://localhost:8080/tfs/defaultcollection'
            }
         }
      }

      Context 'Set-VSTeamAccount TFS' {
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
            Set-VSTeamAccount -a http://localhost:8080/tfs/defaultcollection -pe 12345

            Assert-MockCalled Set-VSTeamAPIVersion -Exactly -Scope It -Times 1 -ParameterFilter {
               $Target -eq 'TFS2017'
            }

            # Make sure set env vars was called with the correct parameters
            Assert-MockCalled _setEnvironmentVariables -Exactly -Scope It -Times 1 -ParameterFilter {
               $Level -eq 'Process' -and $Pat -eq 'OjEyMzQ1' -and $Acct -eq 'http://localhost:8080/tfs/defaultcollection'
            }
         }
      }

      Context 'Set-VSTeamAccount at user level on Windows machine' {
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
            Set-VSTeamAccount -a mydemos -pe 12345 -Level User

            Assert-MockCalled Set-VSTeamAPIVersion -Exactly -Scope It -Times 1 -ParameterFilter {
               $Target -eq 'VSTS'
            }

            # Make sure set env vars was called with the correct parameters
            Assert-MockCalled _setEnvironmentVariables -Exactly -Scope It -Times 1 -ParameterFilter {
               $Level -eq 'User' -and $Pat -eq 'OjEyMzQ1' -and $Acct -eq 'https://dev.azure.com/mydemos'
            }
         }
      }
   }
}