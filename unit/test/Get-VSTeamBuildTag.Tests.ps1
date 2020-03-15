Set-StrictMode -Version Latest

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/$sut"

Describe 'Get-VSTeamBuildTag' {
   # Load the mocks to create the project name dynamic parameter
   . "$PSScriptRoot\mocks\mockProjectNameDynamicParamNoPSet.ps1"

   # Set the account to use for testing. A normal user would do this
   # using the Set-VSTeamAccount function.
   Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable

   # Mock the call to Get-Projects by the dynamic parameter for ProjectName
   Mock Invoke-RestMethod { return @() } -ParameterFilter {
      $Uri -like "*_apis/projects*"
   }

   Context 'Get-VSTeamBuildTag calls correct Url' {
      Mock Invoke-RestMethod {
         return @{ value = 'Tag1', 'Tag2' }
      }

      It 'should get all Build Tags for the Build.' {
         Get-VSTeamBuildTag -projectName project -id 2

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/project/_apis/build/builds/2/tags?api-version=$([VSTeamVersions]::Build)"
         }
      }
   }

   Context 'Get-VSTeamBuildTag returns correct data' {
      $tags = 'Tag1', 'Tag2'
      Mock Invoke-RestMethod {
         return @{ value = $tags }
      }

      It 'should get all Build Tags for the Build.' {
         $returndata = Get-VSTeamBuildTag -projectName project -id 2

         Compare-Object $tags  $returndata |
         Should Be $null
      }
   }
}

Describe 'Get-VSTeamBuildTag' {
   . "$PSScriptRoot\mocks\mockProjectNameDynamicParam.ps1"

   Mock _useWindowsAuthenticationOnPremise { return $true }

   # Mock the call to Get-Projects by the dynamic parameter for ProjectName
   Mock Invoke-RestMethod { return @() } -ParameterFilter {
      $Uri -like "*_apis/projects*"
   }

   Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' } -Verifiable

   Context 'Get-VSTeamBuildTag returns correct data on TFS local Auth' {
      $tags = 'Tag1', 'Tag2'
      Mock Invoke-RestMethod {
         return @{ value = $tags }
      }

      It 'should get all Build Tags for the Build.' {
         $returndata = Get-VSTeamBuildTag -projectName project -id 2

         Compare-Object $tags  $returndata |
         Should Be $null
      }
   }
}