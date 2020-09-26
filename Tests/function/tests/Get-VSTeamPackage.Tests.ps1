Set-StrictMode -Version Latest

Describe 'VSTeamPackage' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      Mock _callApi { Open-SampleFile 'Get-VSTeamPackage.json' }
      Mock _callApi { Open-SampleFile 'Get-VSTeamPackage.json' -Index 0 } -ParameterFilter {
         $PackageId -eq 'b8b066d8-b272-0000-adf2-e4557f67cd98'
      }
   }

   Context 'Get-VSTeamPackage' {
      It 'should return all packages' {
         ## Act
         $actual = Get-VSTeamPackage -FeedId '00000000-0000-0000-0000-000000000001'

         ## Assert
         $actual.count | Should -Be 4

         Should -Invoke _callApi -Exactly -Times 1 -Scope It -ParameterFilter {
            $Subdomain -eq 'feeds' -and
            $Area -eq 'Packaging' -and
            $Resource -eq 'Feeds' -and
            $Id -eq '00000000-0000-0000-0000-000000000001/Packages/'
         }
      }

      It 'should return package by id' {
         ## Act
         $actual = Get-VSTeamPackage -FeedId '00000000-0000-0000-0000-000000000001' `
            -PackageId 'b8b066d8-b272-0000-adf2-e4557f67cd98'

         ## Assert
         $actual | Should -Not -Be $null
         $actual.Id | Should -Be 'b8b066d8-b272-0000-adf2-e4557f67cd98'

         Should -Invoke _callApi -Exactly -Times 1 -Scope It -ParameterFilter {
            $Subdomain -eq 'feeds' -and
            $Area -eq 'Packaging' -and
            $Resource -eq 'Feeds' -and
            $Id -eq '00000000-0000-0000-0000-000000000001/Packages/b8b066d8-b272-0000-adf2-e4557f67cd98'
         }
      }

      It 'should return all packages from pipeline by name' {
         ## Arrange
         $feed = [PSCustomObject]@{
            feedId = '00000000-0000-0000-0000-000000000001'
         }

         ## Act
         $actual = $($feed | Get-VSTeamPackage)

         ## Assert
         $actual.count | Should -Be 4

         Should -Invoke _callApi -Exactly -Times 1 -Scope It -ParameterFilter {
            $Subdomain -eq 'feeds' -and
            $Area -eq 'Packaging' -and
            $Resource -eq 'Feeds' -and
            $Id -eq '00000000-0000-0000-0000-000000000001/Packages/'
         }
      }

      It 'should return all packages from pipeline by value' {
         ## Act
         $actual = $('00000000-0000-0000-0000-000000000001' | Get-VSTeamPackage)

         ## Assert
         $actual.count | Should -Be 4

         Should -Invoke _callApi -Exactly -Times 1 -Scope It -ParameterFilter {
            $Subdomain -eq 'feeds' -and
            $Area -eq 'Packaging' -and
            $Resource -eq 'Feeds' -and
            $Id -eq '00000000-0000-0000-0000-000000000001/Packages/'
         }
      }
   }
}