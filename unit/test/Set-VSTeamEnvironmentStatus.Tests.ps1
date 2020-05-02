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

   Context 'Set-VSTeamEnvironmentStatus by ID' {
      Mock _useWindowsAuthenticationOnPremise { return $false }
      Mock Invoke-RestMethod
      Mock Invoke-RestMethod { throw 'error' } -ParameterFilter { $Uri -like "*101*" }

      $expectedBody = ConvertTo-Json ([PSCustomObject]@{status = 'inProgress'; comment = ''; scheduledDeploymentTime = $null })

      It 'should set environments' {
         ## Act
         Set-VSTeamEnvironmentStatus -ProjectName project -ReleaseId 1 -Id 15 -Status inProgress -Force

         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Patch' -and
            $Body -eq $expectedBody -and
            $Uri -eq "https://vsrm.dev.azure.com/test/project/_apis/release/releases/1/environments/15?api-version=$(_getApiVersion Release)"
         }
      }

      It 'by Id should throw' {
         ## Act / Assert
         { Set-VSTeamEnvironmentStatus -ProjectName project -ReleaseId 101 -Id 101 -Status inProgress -Force } | Should Throw
      }
   }
}