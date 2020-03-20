Set-StrictMode -Version Latest

#region include
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe 'Add-VSTeamBuildTag' {
   Context 'Add-VSTeamBuildTag' {
      ## Arrange
      $inputTags = "Test1", "Test2", "Test3"

      Context 'Services' {
         ## Arrange
         # Load the mocks to create the project name dynamic parameter
         . "$PSScriptRoot\mocks\mockProjectNameDynamicParamNoPSet.ps1"

         # Set the account to use for testing. A normal user would do this
         # using the Set-VSTeamAccount function.
         Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable

         Mock Invoke-RestMethod

         It 'should add tags to Build' {
            ## Act
            Add-VSTeamBuildTag -ProjectName project -id 2 -Tags $inputTags

            ## Assert
            foreach ($inputTag in $inputTags) {
               Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
                  $Method -eq 'Put' -and
                  $Uri -eq "https://dev.azure.com/test/project/_apis/build/builds/2/tags?api-version=$([VSTeamVersions]::Build)" + "&tag=$inputTag"
               }
            }
         }
      }

      Context 'Server' {
         ## Arrange
         . "$PSScriptRoot\mocks\mockProjectNameDynamicParam.ps1"
   
         Mock _useWindowsAuthenticationOnPremise { return $true }
         
         Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' } -Verifiable
   
         Mock Invoke-RestMethod
   
         It 'should add tags to Build' {
            ## Act
            Add-VSTeamBuildTag -ProjectName project -id 2 -Tags $inputTags
   
            ## Assert
            foreach ($inputTag in $inputTags) {
               Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
                  $Method -eq 'Put' -and
                  $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/builds/2/tags?api-version=$([VSTeamVersions]::Build)" + "&tag=$inputTag"
               }
            }
         }
      }
   }
}