Set-StrictMode -Version Latest

Describe 'VSTeamPackageVersion' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      Mock _callApi { Open-SampleFile 'Get-VSTeamPackageVersion.json' } -ParameterFilter {
         $PackageId -eq 'b8b066d8-b272-0000-adf2-e4557f67cd98'
      }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Packaging' }
   }

   Context 'Get-VSTeamPackageVersion' {
      It 'should return all packages' {
         ## Act
         $actual = Get-VSTeamPackageVersion -FeedId '00000000-0000-0000-0000-000000000001' -packageId 'b8b066d8-b272-0000-adf2-e4557f67cd98'

         ## Assert
         $actual.count | Should -Be 5

         Should -Invoke _callApi -Exactly -Times 1 -Scope It -ParameterFilter {
            $Subdomain -eq 'feeds' -and
            $Area -eq 'Packaging' -and
            $Resource -eq 'Feeds' -and
            $Id -eq '00000000-0000-0000-0000-000000000001/Packages/b8b066d8-b272-0000-adf2-e4557f67cd98/versions' -and
            $Version -eq $(_getApiVersion packaging)
         }
      }

      It 'should return all versions from pipeline by name' {
         ## Arrange
         $package = [PSCustomObject]@{
            feedId = '00000000-0000-0000-0000-000000000001'
            id     = 'b8b066d8-b272-0000-adf2-e4557f67cd98'
         }

         ## Act
         $actual = $($package | Get-VSTeamPackageVersion -hideUrls)

         ## Assert
         $actual.count | Should -Be 5

         Should -Invoke _callApi -Exactly -Times 1 -Scope It -ParameterFilter {
            $Subdomain -eq 'feeds' -and
            $Area -eq 'Packaging' -and
            $Resource -eq 'Feeds' -and
            $QueryString['includeUrls'] -eq 'false' -and
            $Id -eq '00000000-0000-0000-0000-000000000001/Packages/b8b066d8-b272-0000-adf2-e4557f67cd98/versions'
         }
      }
   }
}