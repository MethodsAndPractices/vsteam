Set-StrictMode -Version Latest

#region include
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe 'VSTeamBuildTag' {
   # Load the mocks to create the project name dynamic parameter
   . "$PSScriptRoot\mocks\mockProjectNameDynamicParam.ps1"
   . "$PSScriptRoot\mocks\mockProjectNameDynamicParamNoPSet.ps1"

   # Set the account to use for testing. A normal user would do this
   # using the Set-VSTeamAccount function.
   Mock _getInstance { return 'https://dev.azure.com/test' }
   Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Build' }

   $tags = 'Tag1', 'Tag2'
   Mock Invoke-RestMethod {
      return @{ value = $tags }
   }

   Context 'Get-VSTeamBuildTag' {
      Context 'Services' {
         $returndata = Get-VSTeamBuildTag -projectName project -id 2

         It 'should create correct URL.' {
            Assert-MockCalled Invoke-RestMethod -Exactly -Scope Context -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/project/_apis/build/builds/2/tags?api-version=$(_getApiVersion Build)"
            }
         }

         It 'should return correct data.' {
            Compare-Object $tags  $returndata | Should Be $null
         }
      }

      Context 'Server' {
         Mock _useWindowsAuthenticationOnPremise { return $true }
         Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' }

         $returndata = Get-VSTeamBuildTag -projectName project -id 2

         It 'should create correct URL.' {
            Assert-MockCalled Invoke-RestMethod -Exactly -Scope Context -Times 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/builds/2/tags?api-version=$(_getApiVersion Build)"
            }
         }

         It 'should return correct data.' {
            Compare-Object $tags  $returndata | Should Be $null
         }
      }
   }
}