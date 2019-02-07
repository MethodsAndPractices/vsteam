Set-StrictMode -Version Latest

InModuleScope VSTeam {
   Describe 'Invoke-VSTeamRequest' {
      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter {
         $Uri -like "*_apis/projects*"
      }

      Mock Write-Host

      Context 'Invoke-VSTeamRequest Options' {
         [VSTeamVersions]::Account = 'https://dev.azure.com/test'
         Mock Invoke-RestMethod { Write-Host $args }

         Invoke-VSTeamRequest -Method Options

         It 'Should call API' {
            Assert-VerifiableMock
         }
      }

      Context 'Invoke-VSTeamRequest Release' {
         [VSTeamVersions]::Account = 'https://dev.azure.com/test'
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
         # using the Set-VSTeamAccount function.
         [VSTeamVersions]::Account = 'https://dev.azure.com/test'

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
               $Uri -eq "https://dev.azure.com/test/_apis/"
            }
         }

         It 'Should return release options' {
            Get-VSTeamOption -Release | Should Not Be $null
            Assert-MockCalled Invoke-RestMethod -ParameterFilter {
               $Uri -eq "https://vsrm.dev.azure.com/test/_apis/"
            }
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

      Context 'Set-VSTeamAPIVersion' {
         BeforeEach {
            [VSTeamVersions]::Version = ''
         }

         It 'Should default to TFS2017' {
            Set-VSTeamAPIVersion
            [VSTeamVersions]::Version | Should Be 'TFS2017'
         }

         It 'Should return TFS2018' {
            Set-VSTeamAPIVersion -Target TFS2018
            [VSTeamVersions]::Version | Should Be 'TFS2018'
         }

         It 'Should VSTS' {
            Set-VSTeamAPIVersion -Target VSTS
            [VSTeamVersions]::Version | Should Be 'VSTS'
         }

         It 'Should AzD' {
            Set-VSTeamAPIVersion -Target AzD
            [VSTeamVersions]::Version | Should Be 'AzD'
         }

         It 'Should change just Build'{
            Set-VSTeamAPIVersion -Service Build -Version '5.0'
            [VSTeamVersions]::Build | Should Be '5.0'
         }

         It 'Should change just Git'{
            Set-VSTeamAPIVersion -Service Git -Version '5.0'
            [VSTeamVersions]::Git | Should Be '5.0'
         }

         It 'Should change just Core'{
            Set-VSTeamAPIVersion -Service Core -Version '5.0'
            [VSTeamVersions]::Core | Should Be '5.0'
         }

         It 'Should change just Release'{
            Set-VSTeamAPIVersion -Service Release -Version '5.0'
            [VSTeamVersions]::Release | Should Be '5.0'
         }

         It 'Should change just DistributedTask'{
            Set-VSTeamAPIVersion -Service DistributedTask -Version '5.0'
            [VSTeamVersions]::DistributedTask | Should Be '5.0'
         }

         It 'Should change just Tfvc'{
            Set-VSTeamAPIVersion -Service Tfvc -Version '5.0'
            [VSTeamVersions]::Tfvc | Should Be '5.0'
         }

         It 'Should change just Packaging'{
            Set-VSTeamAPIVersion -Service Packaging -Version '5.0'
            [VSTeamVersions]::Packaging | Should Be '5.0'
         }

         It 'Should change just MemberEntitlementManagement'{
            Set-VSTeamAPIVersion -Service MemberEntitlementManagement -Version '5.0'
            [VSTeamVersions]::MemberEntitlementManagement | Should Be '5.0'
         }

         It 'Should change just ServiceFabricEndpoint'{
            Set-VSTeamAPIVersion -Service ServiceFabricEndpoint -Version '5.0'
            [VSTeamVersions]::ServiceFabricEndpoint | Should Be '5.0'
         }

         It 'Should change just ExtensionsManagement'{
            Set-VSTeamAPIVersion -Service ExtensionsManagement -Version '5.0'
            [VSTeamVersions]::ExtensionsManagement | Should Be '5.0'
         }
      }
   }
}