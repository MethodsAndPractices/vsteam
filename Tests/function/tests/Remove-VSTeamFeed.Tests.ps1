Set-StrictMode -Version Latest

Describe 'VSTeamFeed' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      
      Mock Invoke-RestMethod
      Mock _getApiVersion { return '1.0-unitTests' }
      Mock _getInstance { return 'https://dev.azure.com/test' }
   }

   Context 'Remove-VSTeamFeed' {
      It 'should delete feed' {
         Remove-VSTeamFeed -id '00000000-0000-0000-0000-000000000000' -Force

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Delete' -and
            $Uri -eq "https://feeds.dev.azure.com/test/_apis/packaging/feeds/00000000-0000-0000-0000-000000000000?api-version=$(_getApiVersion Packaging)"
         }
      }
   }
}