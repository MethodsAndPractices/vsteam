Set-StrictMode -Version Latest

InModuleScope VSTeam {
   Describe 'Invoke-VSTeamRequest' {
      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter {
         $Uri -like "*_apis/projects*"
      }

      Mock Write-Host

      Context 'Invoke-VSTeamRequest Options' {
         Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable
         Mock Invoke-RestMethod { Write-Host $args }

         Invoke-VSTeamRequest -Method Options

         It 'Should call API' {
            Assert-VerifiableMock
         }
      }

      Context 'Invoke-VSTeamRequest Release' {
         Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable
         Mock Invoke-RestMethod { Write-Host $args } -Verifiable

         Invoke-VSTeamRequest -Area release -Resource releases -Id 1 -SubDomain vsrm -Version '4.1-preview' -ProjectName testproject -JSON

         It 'Should call API' {
            Assert-VerifiableMock
         }
      }

      Context 'Invoke-VSTeamRequest AdditionalHeaders' {
         Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable
         Mock Invoke-RestMethod { return @() } -Verifiable -ParameterFilter {
            $Headers["Test"] -eq 'Test'
         }

         Invoke-VSTeamRequest -Area release -Resource releases -Id 1 -SubDomain vsrm -Version '4.1-preview' -ProjectName testproject -JSON -AdditionalHeaders @{Test = "Test"}

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

      Context 'Get-VSTeamInfo' {
         AfterAll {
            $Global:PSDefaultParameterValues.Remove("*:projectName")
         }
         
         It 'should return account and default project' {
            [VSTeamVersions]::Account = "mydemos"
            $Global:PSDefaultParameterValues['*:projectName'] = 'TestProject'

            $info = Get-VSTeamInfo

            $info.Account | Should Be "mydemos"
            $info.DefaultProject | Should Be "TestProject"
         }
      }

      Context 'Get-VSTeamResourceArea' {
         Mock _callAPI { return @{
               value = @{ }
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
         Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable

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
               $Uri -eq "https://dev.azure.com/test/_apis"
            }
         }

         It 'Should return release options' {
            Get-VSTeamOption -subDomain vsrm | Should Not Be $null
            Assert-MockCalled Invoke-RestMethod -ParameterFilter {
               $Uri -eq "https://vsrm.dev.azure.com/test/_apis"
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

         It 'Should return AzD2019' {
            Set-VSTeamAPIVersion -Target AzD2019
            [VSTeamVersions]::Version | Should Be 'AzD2019'
         }

         It 'Should VSTS' {
            Set-VSTeamAPIVersion -Target VSTS
            [VSTeamVersions]::Version | Should Be 'VSTS'
         }

         It 'Should AzD' {
            Set-VSTeamAPIVersion -Target AzD
            [VSTeamVersions]::Version | Should Be 'AzD'
         }

         It 'Should change just TaskGroups' {
            Set-VSTeamAPIVersion -Service TaskGroups -Version '7.0'
            [VSTeamVersions]::TaskGroups | Should Be '7.0'
         }

         It 'Should change just Build' {
            Set-VSTeamAPIVersion -Service Build -Version '7.0'
            [VSTeamVersions]::Build | Should Be '7.0'
         }

         It 'Should change just Git' {
            Set-VSTeamAPIVersion -Service Git -Version '7.0'
            [VSTeamVersions]::Git | Should Be '7.0'
         }

         It 'Should change just Core' {
            Set-VSTeamAPIVersion -Service Core -Version '7.0'
            [VSTeamVersions]::Core | Should Be '7.0'
         }

         It 'Should change just Release' {
            Set-VSTeamAPIVersion -Service Release -Version '7.0'
            [VSTeamVersions]::Release | Should Be '7.0'
         }

         It 'Should change just DistributedTask' {
            Set-VSTeamAPIVersion -Service DistributedTask -Version '7.0'
            [VSTeamVersions]::DistributedTask | Should Be '7.0'
         }

         It 'Should change just Tfvc' {
            Set-VSTeamAPIVersion -Service Tfvc -Version '7.0'
            [VSTeamVersions]::Tfvc | Should Be '7.0'
         }

         It 'Should change just Packaging' {
            Set-VSTeamAPIVersion -Service Packaging -Version '7.0'
            [VSTeamVersions]::Packaging | Should Be '7.0'
         }

         It 'Should change just MemberEntitlementManagement' {
            Set-VSTeamAPIVersion -Service MemberEntitlementManagement -Version '7.0'
            [VSTeamVersions]::MemberEntitlementManagement | Should Be '7.0'
         }

         It 'Should change just ServiceFabricEndpoint' {
            Set-VSTeamAPIVersion -Service ServiceFabricEndpoint -Version '7.0'
            [VSTeamVersions]::ServiceFabricEndpoint | Should Be '7.0'
         }

         It 'Should change just ExtensionsManagement' {
            Set-VSTeamAPIVersion -Service ExtensionsManagement -Version '7.0'
            [VSTeamVersions]::ExtensionsManagement | Should Be '7.0'
         }
      }
   }
}