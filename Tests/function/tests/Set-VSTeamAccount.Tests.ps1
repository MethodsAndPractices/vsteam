Set-StrictMode -Version Latest

Describe 'VSTeamAccount' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$baseFolder/Source/Public/Clear-VSTeamDefaultProject.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamProfile.ps1"
      . "$baseFolder/Source/Public/Set-VSTeamAPIVersion.ps1"
      . "$baseFolder/Source/Public/Remove-VSTeamAccount.ps1"
   }

   AfterAll {
      Remove-VSTeamAccount
   }

   Context 'You cannot use -UseWindowsAuthentication with Azd' {
      BeforeAll {
         # This is only supported on a Windows machine. So we have
         # to Mock the call to _isOnWindows so you can develop on a
         # Mac or Linux machine.
         Mock _isOnWindows { return $true }

         # Have to Mock this because you can't call
         # [Security.Principal.WindowsIdentity]::GetCurrent()
         # on Mac and Linux
         Mock _testAdministrator { return $false }

         Mock Write-Error { } -Verifiable
      }

      It 'Should return error' {
         Set-VSTeamAccount -Account test -UseWindowsAuthentication
         Should -InvokeVerifiable
      }
   }

   Context 'Set-VSTeamAccount invalid profile' {
      BeforeAll {
         Mock _isOnWindows { return $false }
         Mock Write-Error -Verifiable
         Mock Get-VSTeamProfile { return "[]" | ConvertFrom-Json | ForEach-Object { $_ } }

         Set-VSTeamAccount -Profile notFound
      }

      It 'should write error' {
         Should -InvokeVerifiable
      }
   }

   Context 'Set-VSTeamAccount profile' {
      BeforeAll {
         Mock _isOnWindows { return $false }
         Mock _setEnvironmentVariables
         Mock Set-VSTeamAPIVersion
         Mock Get-VSTeamProfile { return Open-SampleFile 'Get-VSTeamProfile.json' | ForEach-Object { $_ } }
      }

      It 'should set env at process level' {
         Set-VSTeamAccount -Profile test

         Should -Invoke Set-VSTeamAPIVersion -Exactly -Scope It -Times 1 -ParameterFilter {
            $Target -eq 'VSTS'
         }

         # Make sure set env vars was called with the correct parameters
         Should -Invoke _setEnvironmentVariables -Exactly -Scope It -Times 1 -ParameterFilter {
            $Level -eq 'Process' -and 
            $Pat -eq 'OndrejR0ZHpwbDM3bXUycGt5c3hm' -and 
            $Acct -eq 'https://dev.azure.com/test'
         }
      }
   }

   Context 'Set-VSTeamAccount profile and drive' {
      BeforeAll {
         Mock _isOnWindows { return $false }
         Mock _setEnvironmentVariables
         Mock Set-VSTeamAPIVersion
         Mock Write-Output -Verifiable
         Mock Get-VSTeamProfile { return Open-SampleFile 'Get-VSTeamProfile.json' | ForEach-Object { $_ } }
      }

      It 'should set env at process level' {
         Set-VSTeamAccount -Profile test -Drive test

         Should -InvokeVerifiable

         Should -Invoke Set-VSTeamAPIVersion -Exactly -Scope It -Times 1 -ParameterFilter {
            $Target -eq 'VSTS'
         }

         # Make sure set env vars was called with the correct parameters
         Should -Invoke _setEnvironmentVariables -Exactly -Scope It -Times 1 -ParameterFilter {
            $Level -eq 'Process' -and 
            $Pat -eq 'OndrejR0ZHpwbDM3bXUycGt5c3hm' -and 
            $Acct -eq 'https://dev.azure.com/test'
         }
      }
   }

   Context 'Set-VSTeamAccount vsts' {
      BeforeAll {
         Mock _isOnWindows { return $false }
         Mock _setEnvironmentVariables
         Mock Set-VSTeamAPIVersion
      }

      It 'should set env at process level' {
         Set-VSTeamAccount -a mydemos -pe 12345 -Version VSTS

         Should -Invoke Set-VSTeamAPIVersion -Exactly -Scope It -Times 1 -ParameterFilter {
            $Target -eq 'VSTS'
         }

         # Make sure set env vars was called with the correct parameters
         Should -Invoke _setEnvironmentVariables -Exactly -Scope It -Times 1 -ParameterFilter {
            $Level -eq 'Process' -and
            $Pat -eq 'OjEyMzQ1' -and
            $Acct -eq 'https://dev.azure.com/mydemos'
         }
      }
   }

   Context 'Set-VSTeamAccount vsts (old URL)' {
      BeforeAll {
         Mock _isOnWindows { return $false }
         Mock _setEnvironmentVariables
         Mock Set-VSTeamAPIVersion
      }

      It 'should set env at process level' {
         Set-VSTeamAccount -a https://mydemos.visualstudio.com -pe 12345 -Version VSTS

         Should -Invoke Set-VSTeamAPIVersion -Exactly -Scope It -Times 1 -ParameterFilter {
            $Target -eq 'VSTS'
         }

         # Make sure set env vars was called with the correct parameters
         Should -Invoke _setEnvironmentVariables -Exactly -Scope It -Times 1 -ParameterFilter {
            $Level -eq 'Process' -and 
            $Pat -eq 'OjEyMzQ1' -and 
            $Acct -eq 'https://dev.azure.com/mydemos'
         }
      }
   }

   Context 'Set-VSTeamAccount vsts OAuth' {
      BeforeAll {
         Mock _isOnWindows { return $false }
         Mock _setEnvironmentVariables
         Mock Set-VSTeamAPIVersion
      }

      It 'should set env at process level' {
         Set-VSTeamAccount -a mydemos -pe 12345 -Version VSTS -UseBearerToken

         Should -Invoke Set-VSTeamAPIVersion -Exactly -Scope It -Times 1 -ParameterFilter {
            $Target -eq 'VSTS'
         }

         # Make sure set env vars was called with the correct parameters
         Should -Invoke _setEnvironmentVariables -Exactly -Scope It -Times 1 -ParameterFilter {
            $Level -eq 'Process' -and 
            $Pat -eq '' -and 
            $BearerToken -eq 12345 -and
            $Acct -eq 'https://dev.azure.com/mydemos'
         }
      }
   }

   Context 'Set-VSTeamAccount vsts with securePersonalAccessToken' {
      BeforeAll {
         Mock _isOnWindows { return $false }
         Mock _setEnvironmentVariables
         Mock Set-VSTeamAPIVersion
      }

      It 'should set env at process level' {
         $password = '12345' | ConvertTo-SecureString -AsPlainText -Force

         Set-VSTeamAccount -a mydemos -SecurePersonalAccessToken $password -Version VSTS

         Should -Invoke Set-VSTeamAPIVersion -Exactly -Scope It -Times 1 -ParameterFilter {
            $Target -eq 'VSTS'
         }

         # Make sure set env vars was called with the correct parameters
         Should -Invoke _setEnvironmentVariables -Exactly -Scope It -Times 1 -ParameterFilter {
            $Level -eq 'Process' -and 
            $Pat -eq 'OjEyMzQ1' -and 
            $Acct -eq 'https://dev.azure.com/mydemos'
         }
      }
   }

   Context 'Set-VSTeamAccount run as administrator' {
      BeforeAll {
         # I have to write both test just in case the actually
         # start the PowerShell window as Admin or not. If I
         # don't write both of these I will get different code
         # coverage depending on if I started the PowerShell session
         # as admin or not.
         Mock _isOnWindows { return $true }
         Mock _testAdministrator { return $true }
         Mock Set-VSTeamAPIVersion
         Mock _setEnvironmentVariables
      }

      It 'should set env at process level' {
         Set-VSTeamAccount -a mydemos -pe 12345

         Should -Invoke Set-VSTeamAPIVersion -Exactly -Scope It -Times 1 -ParameterFilter {
            $Target -eq 'VSTS'
         }

         # Make sure set env vars was called with the correct parameters
         Should -Invoke _setEnvironmentVariables -Exactly -Scope It -Times 1 -ParameterFilter {
            $Level -eq 'Process' -and $Pat -eq 'OjEyMzQ1' -and $Acct -eq 'https://dev.azure.com/mydemos'
         }
      }
   }

   Context 'Set-VSTeamAccount run as normal user' {
      BeforeAll {
         # I have to write both test just in case the actually
         # start the PowerShell window as Admin or not. If I
         # don't write both of these I will get different code
         # coverage depending on if I started the PowerShell session
         # as admin or not.
         Mock _isOnWindows { return $false }
         Mock _testAdministrator { return $false }
         Mock Set-VSTeamAPIVersion
         Mock _setEnvironmentVariables
      }

      It 'should set env at process level' {
         Set-VSTeamAccount -a mydemos -pe 12345

         Should -Invoke Set-VSTeamAPIVersion -Exactly -Scope It -Times 1 -ParameterFilter {
            $Target -eq 'VSTS'
         }

         # Make sure set env vars was called with the correct parameters
         Should -Invoke _setEnvironmentVariables -Exactly -Scope It -Times 1 -ParameterFilter {
            $Level -eq 'Process' -and $Pat -eq 'OjEyMzQ1' -and $Acct -eq 'https://dev.azure.com/mydemos'
         }
      }
   }

   Context 'Set-VSTeamAccount TFS from windows' {
      BeforeAll {
         # I have to write both test just in case the actually
         # start the PowerShell window as Admin or not. If I
         # don't write both of these I will get different code
         # coverage depending on if I started the PowerShell session
         # as admin or not.
         Mock _isOnWindows { return $true }
         Mock _testAdministrator { return $false }
         Mock Set-VSTeamAPIVersion
         Mock _setEnvironmentVariables
      }

      It 'should set env at process level' {
         Set-VSTeamAccount -a http://localhost:8080/tfs/defaultcollection -UseWindowsAuthentication

         Should -Invoke Set-VSTeamAPIVersion -Exactly -Scope It -Times 1 -ParameterFilter {
            $Target -eq 'TFS2017'
         }

         # Make sure set env vars was called with the correct parameters
         Should -Invoke _setEnvironmentVariables -Exactly -Scope It -Times 1 -ParameterFilter {
            $Level -eq 'Process' -and $Acct -eq 'http://localhost:8080/tfs/defaultcollection'
         }
      }
   }

   Context 'Set-VSTeamAccount TFS' {
      BeforeAll {
         # I have to write both test just in case the actually
         # start the PowerShell window as Admin or not. If I
         # don't write both of these I will get different code
         # coverage depending on if I started the PowerShell session
         # as admin or not.
         Mock _isOnWindows { return $false }
         Mock _testAdministrator { return $false }
         Mock Set-VSTeamAPIVersion
         Mock _setEnvironmentVariables
      }

      It 'should set env at process level' {
         Set-VSTeamAccount -a http://localhost:8080/tfs/defaultcollection -pe 12345

         Should -Invoke Set-VSTeamAPIVersion -Exactly -Scope It -Times 1 -ParameterFilter {
            $Target -eq 'TFS2017'
         }

         # Make sure set env vars was called with the correct parameters
         Should -Invoke _setEnvironmentVariables -Exactly -Scope It -Times 1 -ParameterFilter {
            $Level -eq 'Process' -and $Pat -eq 'OjEyMzQ1' -and $Acct -eq 'http://localhost:8080/tfs/defaultcollection'
         }
      }
   }

   Context 'Set-VSTeamAccount at user level on Windows machine' {
      BeforeAll {
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
      }

      It 'should set env at user level' {
         Set-VSTeamAccount -a mydemos -pe 12345 -Level User

         Should -Invoke Set-VSTeamAPIVersion -Exactly -Scope It -Times 1 -ParameterFilter {
            $Target -eq 'VSTS'
         }

         # Make sure set env vars was called with the correct parameters
         Should -Invoke _setEnvironmentVariables -Exactly -Scope It -Times 1 -ParameterFilter {
            $Level -eq 'User' -and $Pat -eq 'OjEyMzQ1' -and $Acct -eq 'https://dev.azure.com/mydemos'
         }
      }
   }
}