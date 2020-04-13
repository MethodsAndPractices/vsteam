Set-StrictMode -Version Latest

#region include
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Classes/ProjectCompleter.ps1"
. "$here/../../Source/Classes/ProjectValidateAttribute.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe 'Add-VSTeamBuildTag' {
   Context 'Add-VSTeamBuildTag' {
      ## Arrange
      $inputTags = "Test1", "Test2", "Test3"
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Build' }

      Context 'Services' {
         ## Arrange
         # Set the account to use for testing. A normal user would do this
         # using the Set-VSTeamAccount function.
         Mock _getInstance { return 'https://dev.azure.com/test' }

         Mock Invoke-RestMethod

         It 'should add tags to Build' {
            ## Act
            Add-VSTeamBuildTag -ProjectName project -id 2 -Tags $inputTags

            ## Assert
            foreach ($inputTag in $inputTags) {
               Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
                  $Method -eq 'Put' -and
                  $Uri -eq "https://dev.azure.com/test/project/_apis/build/builds/2/tags?api-version=$(_getApiVersion Build)" + "&tag=$inputTag"
               }
            }
         }
      }

      Context 'Server' {
         ## Arrange
         Mock _useWindowsAuthenticationOnPremise { return $true }

         Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' }

         Mock Invoke-RestMethod

         It 'should add tags to Build' {
            ## Act
            Add-VSTeamBuildTag -ProjectName project -id 2 -Tags $inputTags

            ## Assert
            foreach ($inputTag in $inputTags) {
               Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
                  $Method -eq 'Put' -and
                  $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/builds/2/tags?api-version=$(_getApiVersion Build)" + "&tag=$inputTag"
               }
            }
         }
      }
   }
}