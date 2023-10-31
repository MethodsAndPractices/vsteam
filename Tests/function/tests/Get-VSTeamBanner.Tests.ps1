Set-StrictMode -Version Latest

Describe 'VSTeamBanner' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$baseFolder/Source/Public/Invoke-VSTeamRequest.ps1"
   }

   Context 'Get-VSTeamBanner' {
      BeforeAll {
         Mock Invoke-VSTeamRequest {
            $firstId = '1234424'
            return @{
               count = 2
               value = @{
                  "$firstId" = @{ level = 'Info'; message = "This message has the ID $firstId" }
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
         $result.message | Should -Be "This message has the ID 1234424"
      }

      It 'Should throw exception for non-existent ID' {

         $nonExistentId = 'NonExistentID'
         { Get-VSTeamBanner -Id $nonExistentId } | Should -Throw "No banner found with ID $nonExistentId"
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
