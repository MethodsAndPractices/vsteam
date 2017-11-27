#Set-StrictMode -Version Latest

. "$PSScriptRoot\..\..\src\common.ps1"

Describe 'Common' {
   Context '_buildProjectNameDynamicParam' {
      Mock _getProjects { return  ConvertFrom-Json '["Demo", "Universal"]' }
     
      It 'should return dynamic parameter' {
         _buildProjectNameDynamicParam | Should Not BeNullOrEmpty
      }
   }

   Context '_openOnWindows' {
      Mock Start-Process -Verifiable -ParameterFilter { $FilePath -eq 'http://test.visualstudio.com' }
      Mock Start-Process { throw "Start-Process called incorrectly: $Args" }

      _openOnWindows 'http://test.visualstudio.com'

      It 'should call start process' {
         Assert-VerifiableMocks
      }
   }

   Context '_openOnMac' {
      Mock Start-Process -Verifiable -ParameterFilter { $FilePath -eq 'open' -and $ArgumentList -eq 'http://test.visualstudio.com' }
      Mock Start-Process { throw "Start-Process called incorrectly: $Args" }

      _openOnMac 'http://test.visualstudio.com'

      It 'should call start process' {
         Assert-VerifiableMocks
      }
   }

   Context '_openOnLinux' {
      Mock Start-Process -Verifiable -ParameterFilter { $FilePath -eq 'xdg-open' -and $ArgumentList -eq 'http://test.visualstudio.com' }
      Mock Start-Process { throw "Start-Process called incorrectly: $Args" }

      _openOnLinux 'http://test.visualstudio.com'

      It 'should call start process' {
         Assert-VerifiableMocks
      }
   }

   Context '_isOnMac' {
      It 'using IsOSX should return false' {
         
         if (Test-Path variable:IsMacOS) {
            Remove-Item variable:IsMacOS
         }         
         
         $global:IsOSX = $false
         _isOnMac | Should Be $false
      }

      It 'using IsMacOS should return false' {
         
         if (Test-Path variable:IsOSX) {
            Remove-Item variable:IsOSX
         }

         $global:IsMacOS = $false
         _isOnMac | Should Be $false
      }
   }

   Context '_isVSTS' {     
      It 'should return true' {
         _isVSTS 'https://test.visualstudio.com' | Should Be $true
      }

      It 'with / should return true' {
         _isVSTS 'https://test.visualstudio.com/' | Should Be $true
      }

      It 'should return false' {
         _isVSTS 'http://localhost:8080/tfs/defaultcollection' | Should Be $false
      }
   }
}