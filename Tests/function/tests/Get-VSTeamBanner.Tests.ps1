Describe "VSTeamBanner" {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$baseFolder/Source/Public/Invoke-VSTeamRequest.ps1"
   }

   Context 'Get-VSTeamBanner' {
      BeforeAll {
         Mock Invoke-VSTeamRequest { return @{ value = @{ bannerId = '12345' } } }
      }

      It 'Should get a banner' {
         $result = Get-VSTeamBanner -Id '12345'

         Should -Invoke Invoke-VSTeamRequest -ParameterFilter {
            $Method -eq 'GET' -and
            $Area -eq 'settings' -and
            $Resource -eq 'entries/host/GlobalMessageBanners/12345' -and
            $Version -eq '3.2-preview'
         }

         $result.bannerId | Should -Be '12345'
      }

      It "Should return all existing banners" {
            # Mock des Invoke-VSTeamRequest, um ein vorher definiertes Ergebnis zurückzugeben
            Mock Invoke-VSTeamRequest { return @{ value = @('Banner1', 'Banner2') } }

            # Ausführung der Funktion
            $result = Get-VSTeamBanner

            # Überprüfung, ob das Ergebnis wie erwartet ist
            $result | Should -Be @('Banner1', 'Banner2')

            # Überprüfung, ob der Mock korrekt aufgerufen wurde
            Assert-MockCalled Invoke-VSTeamRequest -Exactly 1 -Scope It
      }
   }
}
