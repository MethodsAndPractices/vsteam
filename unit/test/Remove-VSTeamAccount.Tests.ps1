Set-StrictMode -Version Latest

#region include
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe 'Remove-VSTeamAccount' {
   # Mock the call to Get-Projects by the dynamic parameter for ProjectName
   Mock Invoke-RestMethod { return @() } -ParameterFilter {
      $Uri -like "*_apis/projects*"
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
}