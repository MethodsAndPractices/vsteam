Set-StrictMode -Version Latest

Describe 'VSTeamBuildTag' {
   BeforeAll {
      Add-Type -Path "$PSScriptRoot/../../dist/bin/vsteam-lib.dll"
   
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"
   
      # Prime the project cache with an empty list. This will make sure
      # any project name used will pass validation and Get-VSTeamProject 
      # will not need to be called.
      [vsteam_lib.ProjectCache]::Update([string[]]@())
      
      ## Arrange
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