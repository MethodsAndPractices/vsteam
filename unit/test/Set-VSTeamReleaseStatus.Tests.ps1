Set-StrictMode -Version Latest

#region include
Import-Module SHiPS

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamLeaf.ps1"
. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamFeed.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Classes/ProjectCompleter.ps1"
. "$here/../../Source/Classes/ProjectValidateAttribute.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Private/applyTypes.ps1"
. "$here/../../Source/Public/Get-VSTeamBuild.ps1"
. "$here/../../Source/Public/Get-VSTeamReleaseDefinition.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe 'VSTeamReleaseStatus' {
   ## Arrange
   Mock _getApiVersion { return '1.0-unittest' } -ParameterFilter { $Service -eq 'Release' }

   Mock _getInstance { return 'https://dev.azure.com/test' }

   # Mock the call to Get-Projects by the dynamic parameter for ProjectName
   Mock Invoke-RestMethod { return @() } -ParameterFilter { $Uri -like "*_apis/projects*" }

   Context 'Set-VSTeamReleaseStatus' {
      ## Arrange
      Mock _useWindowsAuthenticationOnPremise { return $true }
      Mock Invoke-RestMethod
      Mock Invoke-RestMethod { throw 'error' } -ParameterFilter { $Uri -like "*101*" }

      It 'by Id should set release status' {
         ## Act
         Set-VSTeamReleaseStatus -ProjectName project -Id 15 -Status Abandoned -Force

         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Patch' -and
            $Body -eq '{ "id": 15, "status": "Abandoned" }' -and
            $Uri -eq "https://vsrm.dev.azure.com/test/project/_apis/release/releases/15?api-version=$(_getApiVersion Release)"
         }
      }

      It 'by Id should throw' {
         ## Act / Assert
         { Set-VSTeamReleaseStatus -ProjectName project -Id 101 -Status Abandoned -Force } | Should Throw
      }
   }
}