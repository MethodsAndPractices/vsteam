Set-StrictMode -Version Latest

Describe 'VSTeamBuildTag' {
   BeforeAll {
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")
      
      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"
   }

   Context 'Add-VSTeamBuildTag' -Tag "Add" {
      ## Arrange
      BeforeAll {
         $inputTags = "Test1", "Test2", "Test3"
         Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Build' }
      }

      Context 'Services' -Tag "Services" {
         ## Arrange
         BeforeAll {
            # Set the account to use for testing. A normal user would do this
            # using the Set-VSTeamAccount function.
            Mock _getInstance { return 'https://dev.azure.com/test' }

            Mock Invoke-RestMethod
         }

         It 'should add tags to Build' {
            ## Act
            Add-VSTeamBuildTag -ProjectName project -id 2 -Tags $inputTags

            ## Assert
            foreach ($inputTag in $inputTags) {
               Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
                  $Method -eq 'Put' -and
                  $Uri -eq "https://dev.azure.com/test/project/_apis/build/builds/2/tags?api-version=$(_getApiVersion Build)" + "&tag=$inputTag"
               }
            }
         }
      }

      Context 'Server' -Tag "Server" {
         ## Arrange
         BeforeAll {
            Mock _useWindowsAuthenticationOnPremise { return $true }

            Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' }

            Mock Invoke-RestMethod
         }

         It 'should add tags to Build' {
            ## Act
            Add-VSTeamBuildTag -ProjectName project -id 2 -Tags $inputTags

            ## Assert
            foreach ($inputTag in $inputTags) {
               Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
                  $Method -eq 'Put' -and
                  $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/builds/2/tags?api-version=$(_getApiVersion Build)" + "&tag=$inputTag"
               }
            }
         }
      }
   }
}