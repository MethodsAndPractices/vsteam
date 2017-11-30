Set-StrictMode -Version Latest

Get-Module VSTeam | Remove-Module -Force
Get-Module team | Remove-Module -Force
Get-Module profile | Remove-Module -Force

Import-Module $PSScriptRoot\..\..\src\team.psm1 -Force
Import-Module $PSScriptRoot\..\..\src\profile.psm1 -Force

InModuleScope team {
   Describe 'Team VSTS' {
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

      Context 'Get-VSTeamResourceArea' {
         Mock _get { return @{
               value = @{
               
               }
            } 
         }

         $actual = Get-VSTeamResourceArea

         It 'Should return resources' {
            $actual | Should Not Be $null
         }
      }

      Context 'Show-VSTeam' {
         Mock _ShowInBrowser -Verifiable

         Show-VSTeam

         It 'Should open browser' {
            Assert-VerifiableMocks
         }
      }

      Context 'Get-VSTeamOption' {
         # Set the account to use for testing. A normal user would do this
         # using the Add-VSTeamAccount function.
         $VSTeamVersionTable.Account = 'https://test.visualstudio.com'
   
         Mock _options { return @{
               count = 1
               value = @(
                  @{
                     id           = '5e8a8081-3851-4626-b677-9891cc04102e'
                     area         = 'git'
                     resourceName = 'annotatedTags'
                  }
               )
            }
         }
         
         It 'Should return all options' {
            Get-VSTeamOption | Should Not Be $null
            Assert-MockCalled _options -ParameterFilter { 
               $Url -eq "https://test.visualstudio.com/_apis/"
            }
         }

         It 'Should return release options' {
            Get-VSTeamOption -Release | Should Not Be $null
            Assert-MockCalled _options -ParameterFilter { 
               $Url -eq "https://test.vsrm.visualstudio.com/_apis/"
            }
         }
      }

      Context 'Add-VSTeamAccount invalid profile' {
         Mock _isOnWindows { return $false }
         Mock Write-Error -Verifiable
         Mock Get-VSTeamProfile { return "[]" | ConvertFrom-Json | ForEach-Object { $_ } }
         
         Add-VSTeamAccount -Profile notFound

         It 'should write error' {
            Assert-VerifiableMocks
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
         Mock Write-Host -Verifiable
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

      Context 'Add-VSTeamAccount TFS from windows' {
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
            Add-VSTeamAccount -a http://localhost:8080/tfs/defaultcollection -UseWindowsAuthentication

            Assert-MockCalled Set-VSTeamAPIVersion -Exactly -Scope It -Times 1 -ParameterFilter {
               $Version -eq 'TFS2017'
            }

            # Make sure set env vars was called with the correct parameters
            Assert-MockCalled _setEnvironmentVariables -Exactly -Scope It -Times 1 -ParameterFilter {
               $Level -eq 'Process' -and $Acct -eq 'http://localhost:8080/tfs/defaultcollection'
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

      Context 'Set-VSTeamDefaultProject on Non Windows' {
         Mock _isOnWindows { return $false } -Verifiable

         It 'should set default project' {
            Set-VSTeamDefaultProject 'MyProject'

            Assert-VerifiableMocks
            $Global:PSDefaultParameterValues['*:projectName'] | Should be 'MyProject'
         }
      }

      Context 'Set-VSTeamDefaultProject As Admin on Windows' {
         Mock _isOnWindows { return $true }
         Mock _testAdministrator { return $true } -Verifiable

         It 'should set default project' {
            Set-VSTeamDefaultProject 'MyProject'

            Assert-VerifiableMocks
            $Global:PSDefaultParameterValues['*:projectName'] | Should be 'MyProject'
         }
      }

      Context 'Clear-VSTeamDefaultProject' {
         It 'should clear default project' {
            $Global:PSDefaultParameterValues['*:projectName'] = 'MyProject'

            Clear-VSTeamDefaultProject

            $Global:PSDefaultParameterValues['*:projectName'] | Should BeNullOrEmpty
         }
      }

      Context 'Set-VSTeamAPIVersion' {
         It 'Should default to TFS2017' {
            Set-VSTeamAPIVersion
            $VSTeamVersionTable.Version | Should Be 'TFS2017'
         }

         It 'Should return TFS2018' {
            Set-VSTeamAPIVersion -Version TFS2018
            $VSTeamVersionTable.Version | Should Be 'TFS2018'
         }

         It 'Should VSTS' {
            Set-VSTeamAPIVersion -Version VSTS
            $VSTeamVersionTable.Version | Should Be 'VSTS'
         }

         BeforeEach {
            $VSTeamVersionTable.Version = ''
         }
      }
   }
}