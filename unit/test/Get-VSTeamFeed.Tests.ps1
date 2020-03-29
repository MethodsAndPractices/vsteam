Set-StrictMode -Version Latest

#region include
Import-Module SHiPS

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamLeaf.ps1"
. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamFeed.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe 'VSTeamFeed' {
   Context 'Get-VSTeamFeed' {
      Context 'Services' {
         ## Arrange
         Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Packaging' }
         $results = Get-Content "$PSScriptRoot\sampleFiles\feeds.json" -Raw | ConvertFrom-Json

         Mock _supportsFeeds { return $true }
         Mock Invoke-RestMethod { return $results }
         Mock _getInstance { return 'https://dev.azure.com/test' }
         # Mock the call to Get-Projects by the dynamic parameter for ProjectName
         Mock Invoke-RestMethod { return @() } -ParameterFilter { $Uri -like "*_apis/projects*" }
         Mock Invoke-RestMethod { return $results.value[0] } -ParameterFilter { $Uri -like "*00000000-0000-0000-0000-000000000000*" }

         it 'with no parameters should return all the Feeds' {
            ## Act
            Get-VSTeamFeed

            ## Assert
            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://feeds.dev.azure.com/test/_apis/packaging/feeds?api-version=$(_getApiVersion packaging)"
            }
         }

         it 'by id should return one feed' {
            ## Act
            Get-VSTeamFeed -id '00000000-0000-0000-0000-000000000000'

            ## Assert
            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://feeds.dev.azure.com/test/_apis/packaging/feeds/00000000-0000-0000-0000-000000000000?api-version=$(_getApiVersion packaging)"
            }
         }
      }

      Context 'Server' {
         ## Arrange
         Mock _supportsFeeds { return $false }
         Mock _getApiVersion { return 'TFS2017' }
         Mock _getApiVersion { return '' } -ParameterFilter { $Service -eq 'Packaging' }

         it 'is not supported and should throw' {
            ## Act / Assert
            { Get-VSTeamFeed } | Should throw
         }
      }
   }
}