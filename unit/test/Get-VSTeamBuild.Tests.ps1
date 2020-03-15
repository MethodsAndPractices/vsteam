Set-StrictMode -Version Latest

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Private/applyTypes.ps1"
. "$here/../../Source/Public/$sut"

# Sample result of a single build
$singleResult = [PSCustomObject]@{
   logs              = [PSCustomObject]@{ }
   queue             = [PSCustomObject]@{ }
   _links            = [PSCustomObject]@{ }
   project           = [PSCustomObject]@{ }
   repository        = [PSCustomObject]@{ }
   requestedFor      = [PSCustomObject]@{ }
   orchestrationPlan = [PSCustomObject]@{ }
   definition        = [PSCustomObject]@{ }
   lastChangedBy     = [PSCustomObject]@{ }
   requestedBy       = [PSCustomObject]@{ }
}

# Sample result for list of builds
$results = [PSCustomObject]@{
   value = [PSCustomObject]@{
      logs              = [PSCustomObject]@{ }
      queue             = [PSCustomObject]@{ }
      _links            = [PSCustomObject]@{ }
      project           = [PSCustomObject]@{ }
      repository        = [PSCustomObject]@{ }
      requestedFor      = [PSCustomObject]@{ }
      orchestrationPlan = [PSCustomObject]@{ }
      definition        = [PSCustomObject]@{ }
      lastChangedBy     = [PSCustomObject]@{ }
      requestedBy       = [PSCustomObject]@{ }
   }
}

Describe 'Get-VSTeamBuild' {
   # Load the mocks to create the project name dynamic parameter
   . "$PSScriptRoot\mocks\mockProjectNameDynamicParamNoPSet.ps1"

   # Set the account to use for testing. A normal user would do this
   # using the Set-VSTeamAccount function.
   Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable

   # Mock the call to Get-Projects by the dynamic parameter for ProjectName
   Mock Invoke-RestMethod { return @() } -ParameterFilter {
      $Uri -like "*_apis/projects*"
   }

   Context 'Get Builds with no parameters' {
      Mock Invoke-RestMethod { return $results }

      It 'should return builds' {
         Get-VSTeamBuild -projectName project

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/project/_apis/build/builds?api-version=$([VSTeamVersions]::Build)"
         }
      }
   }

   Context 'Get Builds with Top parameter' {
      Mock Invoke-RestMethod { return $results }

      It 'should return top builds' {
         Get-VSTeamBuild -projectName project -top 1

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/project/_apis/build/builds?api-version=$([VSTeamVersions]::Build)&`$top=1"
         }
      }
   }

   Context 'Get Build build by id' {
      Mock Invoke-RestMethod { return $singleResult }

      Get-VSTeamBuild -projectName project -id 1

      It 'should return top builds' {
         Assert-MockCalled Invoke-RestMethod -Exactly -Scope Context -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/project/_apis/build/builds/1?api-version=$([VSTeamVersions]::Build)"
         }
      }
   }
}

Describe 'Get-VSTeamBuild' {
   . "$PSScriptRoot\mocks\mockProjectNameDynamicParam.ps1"

   Mock _useWindowsAuthenticationOnPremise { return $true }

   # Mock the call to Get-Projects by the dynamic parameter for ProjectName
   Mock Invoke-RestMethod { return @() } -ParameterFilter {
      $Uri -like "*_apis/projects*"
   }

   # Remove any previously loaded accounts
   Remove-VSTeamAccount

   Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' } -Verifiable

   Context 'Get Builds with no parameters on TFS local Auth' {
      Mock Invoke-RestMethod { return $results }

      It 'should return builds' {
         Get-VSTeamBuild -projectName project

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/builds?api-version=$([VSTeamVersions]::Build)"
         }
      }
   }

   Context 'Get Build by id on TFS local Auth' {
      Mock Invoke-RestMethod { return $singleResult }

      It 'should return builds' {
         Get-VSTeamBuild -projectName project -id 2

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter { $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/builds/2?api-version=$([VSTeamVersions]::Build)" }
      }
   }
}