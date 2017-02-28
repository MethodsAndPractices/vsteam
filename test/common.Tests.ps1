#Set-StrictMode -Version Latest

. "$PSScriptRoot\..\src\common.ps1"

Describe 'Common' {
   Context '_buildProjectNameDynamicParam' {
      Mock _getProjects { return  ConvertFrom-Json '["Demo", "Universal"]' }
     
      It 'should return dynamic parameter' {
         _buildProjectNameDynamicParam | Should Not BeNullOrEmpty
      }
   }
}