Set-StrictMode -Version Latest

Import-Module SHiPS

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamLeaf.ps1"
. "$here/../../Source/Classes/VSTeamFeed.ps1"
. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/$sut"

$results = Get-Content "$PSScriptRoot\sampleFiles\feeds.json" -Raw | ConvertFrom-Json

Describe 'VSTeamFeed' {
   Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable
      
   # Mock the call to Get-Projects by the dynamic parameter for ProjectName
   Mock Invoke-RestMethod { return @() } -ParameterFilter {
      $Uri -like "*_apis/projects*"
   }

   Context 'Add-VSTeamFeed with description' {
      [VSTeamVersions]::Packaging = '4.0'
      Mock Invoke-RestMethod {
         # Write-Host "$args"
         return $results.value[0]
      }

      it 'Should add Feed' {
         Add-VSTeamFeed -Name 'module' -Description 'Test Module'

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://feeds.dev.azure.com/test/_apis/packaging/feeds?api-version=$([VSTeamVersions]::packaging)" -and
            $Method -eq 'Post' -and
            $ContentType -eq 'application/json' -and
            $Body -like '*"name": *"module"*'
         }
      }
   }

   Context 'Add-VSTeamFeed with upstream sources' {
      [VSTeamVersions]::Packaging = '4.0'
      Mock Invoke-RestMethod {
         # Write-Host "$args"
         return $results.value[0]
      }

      it 'Should add Feed' {
         Add-VSTeamFeed -Name 'module' -EnableUpstreamSources -showDeletedPackageVersions

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://feeds.dev.azure.com/test/_apis/packaging/feeds?api-version=$([VSTeamVersions]::packaging)" -and
            $Method -eq 'Post' -and
            $ContentType -eq 'application/json' -and
            $Body -like '*"upstreamEnabled":*true*' -and
            $Body -like '*"hideDeletedPackageVersions":*false*'
         }
      }
   }
}