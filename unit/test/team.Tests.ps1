Set-StrictMode -Version Latest

InModuleScope team {
   Describe 'Invoke-VSTeamRequest' {
      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter {
         $Uri -like "*_apis/projects*" 
      }

      Mock Write-Host

      Context 'Invoke-VSTeamRequest Options' {
         [VSTeamVersions]::Account = 'https://test.visualstudio.com'
         Mock Invoke-RestMethod { Write-Host $args }

         Invoke-VSTeamRequest -Method Options

         It 'Should call API' {
            Assert-VerifiableMock
         }
      }

      Context 'Invoke-VSTeamRequest Release' {
         [VSTeamVersions]::Account = 'https://test.visualstudio.com'
         Mock Invoke-RestMethod { Write-Host $args } -Verifiable

         Invoke-VSTeamRequest -Area release -Resource releases -Id 1 -SubDomain vsrm -Version '4.1-preview' -ProjectName testproject -JSON

         It 'Should call API' {
            Assert-VerifiableMock
         }
      }
   }

   Describe 'Team VSTS' {
      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter {
         $Uri -like "*_apis/projects*" 
      }
      
      . "$PSScriptRoot\mocks\mockProjectDynamicParamMandatoryFalse.ps1"

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
            "URL": "https://mydemos.visualstudio.com",
            "Pat": "OjEyMzQ1",
            "Type": "Pat",
            "Token": "",
            "Version": "VSTS"
         },
         {
            "Name": "demonstrations",
            "URL": "https://demonstrations.visualstudio.com",
            "Pat": "dzY2a2x5am13YWtkcXVwYmg0emE=",
            "Type": "Pat",
            "Token": "",
            "Version": "VSTS"
         }
      ]
"@

      Context 'Get-VSTeamInfo' {
         It 'should return account and default project' {
            [VSTeamVersions]::Account = "mydemos"
            $Global:PSDefaultParameterValues['*:projectName'] = 'MyProject'

            $info = Get-VSTeamInfo

            $info.Account | Should Be "mydemos"
            $info.DefaultProject | Should Be "MyProject"
         }
      }

      Context 'Get-VSTeamResourceArea' {
         Mock _callAPI { return @{
               value = @{}
            }
         }

         $actual = Get-VSTeamResourceArea

         It 'Should return resources' {
            $actual | Should Not Be $null
         }
      }

      Context 'Show-VSTeam' {
         Mock Show-Browser -Verifiable

         Show-VSTeam

         It 'Should open browser' {
            Assert-VerifiableMock
         }
      }

      Context 'Get-VSTeamOption' {
         # Set the account to use for testing. A normal user would do this
         # using the Add-VSTeamAccount function.
         [VSTeamVersions]::Account = 'https://test.visualstudio.com'

         Mock Invoke-RestMethod { return @{
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
            Assert-MockCalled Invoke-RestMethod -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/_apis/"
            }
         }

         It 'Should return release options' {
            Get-VSTeamOption -Release | Should Not Be $null
            Assert-MockCalled Invoke-RestMethod -ParameterFilter {
               $Uri -eq "https://test.vsrm.visualstudio.com/_apis/"
            }
         }
      }

      Context 'Add-VSTeamAccount invalid profile' {
         Mock _isOnWindows { return $false }
         Mock Write-Error -Verifiable
         Mock Get-VSTeamProfile { return "[]" | ConvertFrom-Json | ForEach-Object { $_ } }

         Add-VSTeamAccount -Profile notFound

         It 'should write error' {
            Assert-VerifiableMock
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

            Assert-VerifiableMock

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

      Context 'Add-VSTeamAccount vsts OAuth' {
         Mock _isOnWindows { return $false }
         Mock _setEnvironmentVariables
         Mock Set-VSTeamAPIVersion

         It 'should set env at process level' {
            Add-VSTeamAccount -a mydemos -pe 12345 -Version VSTS -UseBearerToken

            Assert-MockCalled Set-VSTeamAPIVersion -Exactly -Scope It -Times 1 -ParameterFilter {
               $Version -eq 'VSTS'
            }

            # Make sure set env vars was called with the correct parameters
            Assert-MockCalled _setEnvironmentVariables -Exactly -Scope It -Times 1 -ParameterFilter {
               $Level -eq 'Process' -and $Pat -eq '' -and $BearerToken -eq 12345 -and $Acct -eq 'https://mydemos.visualstudio.com'
            }
         }
      }

      Context 'Add-VSTeamAccount vsts with securePersonalAccessToken' {
         Mock _isOnWindows { return $false }
         Mock _setEnvironmentVariables
         Mock Set-VSTeamAPIVersion

         It 'should set env at process level' {
            $password = '12345' | ConvertTo-SecureString -AsPlainText -Force

            Add-VSTeamAccount -a mydemos -SecurePersonalAccessToken $password -Version VSTS

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

      Context 'Set-VSTeamAPIVersion' {
         BeforeEach {
            [VSTeamVersions]::Version = ''
         }

         It 'Should default to TFS2017' {
            Set-VSTeamAPIVersion
            [VSTeamVersions]::Version | Should Be 'TFS2017'
         }

         It 'Should return TFS2018' {
            Set-VSTeamAPIVersion -Version TFS2018
            [VSTeamVersions]::Version | Should Be 'TFS2018'
         }

         It 'Should VSTS' {
            Set-VSTeamAPIVersion -Version VSTS
            [VSTeamVersions]::Version | Should Be 'VSTS'
         }
      }
   }
}