Set-StrictMode -Version Latest

#region include
Import-Module SHiPS

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamLeaf.ps1"
. "$here/../../Source/Classes/VSTeamFeed.ps1"
. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Classes/ProjectValidateAttribute.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe 'VSTeamFeed' {
   Context 'Add-VSTeamFeed' {
      ## Arrange
      $results = Get-Content "$PSScriptRoot\sampleFiles\feeds.json" -Raw | ConvertFrom-Json
      Mock Invoke-RestMethod { return $results.value[0] }
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Packaging' }

      it 'with description should add feed' {
         ## Act
         Add-VSTeamFeed -Name 'module' -Description 'Test Module'

         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -eq "https://feeds.dev.azure.com/test/_apis/packaging/feeds?api-version=$(_getApiVersion Packaging)" -and
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
            $Uri -eq "https://feeds.dev.azure.com/test/_apis/packaging/feeds?api-version=$(_getApiVersion packaging)" -and
            $Method -eq 'Post' -and
            $ContentType -eq 'application/json' -and
            $Body -like '*"upstreamEnabled":*true*' -and
            $Body -like '*"hideDeletedPackageVersions":*false*'
         }
      }
   }
}