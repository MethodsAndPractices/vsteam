Set-StrictMode -Version Latest

#region include
Import-Module SHiPS

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamLeaf.ps1"
. "$here/../../Source/Classes/VSTeamFeed.ps1"
. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe 'VSTeamFeed' {
   ## Arrange
   $results = Get-Content "$PSScriptRoot\sampleFiles\feeds.json" -Raw | ConvertFrom-Json
   Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable

   [VSTeamVersions]::Packaging = '4.0'
   Mock Invoke-RestMethod {
      # Write-Host "$args"
      return $results.value[0]
   }

   Context 'Add-VSTeamFeed' {
      it 'with description should add feed' {
         ## Act
         Add-VSTeamFeed -Name 'module' -Description 'Test Module'

         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -eq "https://feeds.dev.azure.com/test/_apis/packaging/feeds?api-version=$([VSTeamVersions]::packaging)" -and
            $Method -eq 'Post' -and
            $ContentType -eq 'application/json' -and
            $Body -like '*"name": *"module"*'
         }
      }

      it 'with upstream sources should add feed' {
         ## Act
         Add-VSTeamFeed -Name 'module' -EnableUpstreamSources -showDeletedPackageVersions

         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -eq "https://feeds.dev.azure.com/test/_apis/packaging/feeds?api-version=$([VSTeamVersions]::packaging)" -and
            $Method -eq 'Post' -and
            $ContentType -eq 'application/json' -and
            $Body -like '*"upstreamEnabled":*true*' -and
            $Body -like '*"hideDeletedPackageVersions":*false*'
         }
      }
   }
}