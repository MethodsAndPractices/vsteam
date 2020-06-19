Set-StrictMode -Version Latest

BeforeAll {
   $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

   . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
   . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
   . "$PSScriptRoot/../../Source/Classes/ProjectCompleter.ps1"
   . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
   . "$PSScriptRoot/../../Source/Private/common.ps1"
   . "$PSScriptRoot/../../Source/Public/$sut"
}

Describe 'VSTeamBuildTag' {
   BeforeAll {
      ## Arrange
      # Make sure the project name is valid. By returning an empty array
      # all project names are valid. Otherwise, you name you pass for the
      # project in your commands must appear in the list.
      Mock _getProjects { return @() }

      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Build' }

      $tags = 'Tag1', 'Tag2'
      Mock Invoke-RestMethod {
         return @{ value = $tags }
      }
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
            Compare-Object $tags  $returndata | Should -Be $null
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