Set-StrictMode -Version Latest

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/$sut"

Describe 'Get-VSTeamBuildLog' {
   # Load the mocks to create the project name dynamic parameter
   . "$PSScriptRoot\mocks\mockProjectNameDynamicParamNoPSet.ps1"

   # Set the account to use for testing. A normal user would do this
   # using the Set-VSTeamAccount function.
   Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable

   # Mock the call to Get-Projects by the dynamic parameter for ProjectName
   Mock Invoke-RestMethod { return @() } -ParameterFilter {
      $Uri -like "*_apis/projects*"
   }

   Context 'Get Build Log with build id' {
      Mock Invoke-RestMethod { return @{ count = 4 } } -Verifiable -ParameterFilter {
         $Uri -eq "https://dev.azure.com/test/project/_apis/build/builds/1/logs?api-version=$([VSTeamVersions]::Build)"
      }
      Mock Invoke-RestMethod { return @{ value = @{ } } } -Verifiable -ParameterFilter {
         $Uri -eq "https://dev.azure.com/test/project/_apis/build/builds/1/logs/3?api-version=$([VSTeamVersions]::Build)"
      }
      Mock Invoke-RestMethod { throw 'Invoke-RestMethod called with wrong URL' }

      Get-VSTeamBuildLog -projectName project -Id 1

      It 'Should return full log' {
         Assert-VerifiableMock
      }
   }

   Context 'Get Build Log with build id and index' {
      Mock Invoke-RestMethod { return @{ value = @{ } } } -Verifiable -ParameterFilter { $Uri -eq "https://dev.azure.com/test/project/_apis/build/builds/1/logs/2?api-version=$([VSTeamVersions]::Build)" }
      Mock Invoke-RestMethod { throw 'Invoke-RestMethod called with wrong URL' }

      Get-VSTeamBuildLog -projectName project -Id 1 -Index 2

      It 'Should return full log' {
         Assert-VerifiableMock
      }
   }
}

Describe 'Get-VSTeamBuildLog' {
   . "$PSScriptRoot\mocks\mockProjectNameDynamicParam.ps1"

   Mock _useWindowsAuthenticationOnPremise { return $true }

   # Mock the call to Get-Projects by the dynamic parameter for ProjectName
   Mock Invoke-RestMethod { return @() } -ParameterFilter {
      $Uri -like "*_apis/projects*"
   }

   # Remove any previously loaded accounts
   Remove-VSTeamAccount

   Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' } -Verifiable

   Context 'Get Build Log with index on TFS local Auth' {
      Mock Invoke-RestMethod { return @{ value = @{ } } } -Verifiable -ParameterFilter { $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/builds/1/logs/2?api-version=$([VSTeamVersions]::Build)" }
      Mock Invoke-RestMethod { throw 'Invoke-RestMethod called with wrong URL' }

      Get-VSTeamBuildLog -projectName project -Id 1 -Index 2

      It 'Should return full log' {
         Assert-VerifiableMock
      }
   }

   Context 'Get Build Log on TFS local Auth' {
      Mock Invoke-RestMethod { return @{ count = 4 } } -Verifiable -ParameterFilter {
         $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/builds/1/logs?api-version=$([VSTeamVersions]::Build)"
      }
      Mock Invoke-RestMethod { return @{ value = @{ } } } -Verifiable -ParameterFilter {
         $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/builds/1/logs/3?api-version=$([VSTeamVersions]::Build)"
      }
      Mock Invoke-RestMethod { throw 'Invoke-RestMethod called with wrong URL' }

      Get-VSTeamBuildLog -projectName project -Id 1

      It 'Should return full log' {
         Assert-VerifiableMock
      }
   }
}