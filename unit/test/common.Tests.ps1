#Set-StrictMode -Version Latest

. "$PSScriptRoot\..\..\src\common.ps1"

Describe 'Common' {
   Context '_buildProjectNameDynamicParam' {
      Mock _getProjects { return  ConvertFrom-Json '["Demo", "Universal"]' }
     
      It 'should return dynamic parameter' {
         _buildProjectNameDynamicParam | Should Not BeNullOrEmpty
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