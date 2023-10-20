Describe 'VSTeamBanner' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$baseFolder/Source/Public/Invoke-VSTeamRequest.ps1"
   }

   Context 'Get-VSTeamBanner' {
      BeforeAll {
         Mock Invoke-VSTeamRequest {
            return @{
               count = 2
               value = @{
                  '1234424' = @{ level = 'Info'; message = '' }
                  '574745'  = @{ level = 'Info'; message = '' }
               }
            }
         }
      }

      It 'Should get a banner by ID' {
         $result = Get-VSTeamBanner -Id '1234424'

         Should -Invoke Invoke-VSTeamRequest -ParameterFilter {
            $Method -eq 'GET' -and
            $Area -eq 'settings' -and
            $Resource -eq 'entries/host/GlobalMessageBanners' -and
            $Version -eq '3.2-preview'
         }
         $result | Should -Not -Be $null
         $result.level | Should -Be 'Info'
      }

      It 'Should throw exception for non-existent ID' {
         { Get-VSTeamBanner -Id 'NonExistentID' } | Should -Throw 'No banner found with ID NonExistentID'
      }

      It 'Should return all existing banners' {

         $result = Get-VSTeamBanner

         $result.Keys | Should -Contain @('574745')
         $result.Keys | Should -Contain @('1234424')
         $result.Count | Should -Be 2

         Assert-MockCalled Invoke-VSTeamRequest -Exactly 1 -Scope It
      }
   }
}
