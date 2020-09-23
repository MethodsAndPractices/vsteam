Set-StrictMode -Version Latest

Describe 'VSTeamBuildTag' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      
      ## Arrange
      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Build' }

      $tags = Open-SampleFile 'Get-VSTeamBuildTag-Id568.json' -ReturnValue
      Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamBuildTag-Id568.json' }
   }

   Context 'Get-VSTeamBuildTag' {
      Context 'Services' {
         BeforeAll {
            $returndata = Get-VSTeamBuildTag -projectName project -id 2
         }

         It 'should create correct URL.' {
            Should -Invoke Invoke-RestMethod -Exactly -Scope Context -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/project/_apis/build/builds/2/tags?api-version=$(_getApiVersion Build)"
            }
         }

         It 'should return correct data.' {
            Compare-Object $tags $returndata | Should -Be $null
         }
      }

      Context 'Server' {
         BeforeAll {
            Mock _useWindowsAuthenticationOnPremise { return $true }
            Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' }

            $returndata = Get-VSTeamBuildTag -projectName project -id 2
         }

         It 'should create correct URL.' {
            Should -Invoke Invoke-RestMethod -Exactly -Scope Context -Times 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/builds/2/tags?api-version=$(_getApiVersion Build)"
            }
         }

         It 'should return correct data.' {
            Compare-Object $tags  $returndata | Should -Be $null
         }
      }
   }
}