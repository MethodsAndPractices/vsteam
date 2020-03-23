Set-StrictMode -Version Latest

#region include
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/Get-VSTeamProject.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe 'VSTeamReleaseDefinition' {
   ## Arrange
   [VSTeamVersions]::Release = '1.0-unittest'

   . "$PSScriptRoot\mocks\mockProjectNameDynamicParamNoPSet.ps1"

   $results = [PSCustomObject]@{
      value = [PSCustomObject]@{
         queue           = [PSCustomObject]@{ name = 'Default' }
         _links          = [PSCustomObject]@{
            self = [PSCustomObject]@{ }
            web  = [PSCustomObject]@{ }
         }
         retentionPolicy = [PSCustomObject]@{ }
         lastRelease     = [PSCustomObject]@{ }
         artifacts       = [PSCustomObject]@{ }
         modifiedBy      = [PSCustomObject]@{ name = 'project' }
         createdBy       = [PSCustomObject]@{ name = 'test' }
      }
   }

   # Mock the call to Get-Projects by the dynamic parameter for ProjectName
   Mock Invoke-RestMethod { return @() } -ParameterFilter { $Uri -like "*_apis/projects*" }   

   Context 'Remove-VSTeamReleaseDefinition' {
      Mock Invoke-RestMethod { return $results }

      Context 'Services' {
         Mock _getInstance { return 'https://dev.azure.com/test' }

         It 'should delete release definition' {
            ## Act
            Remove-VSTeamReleaseDefinition -projectName project -id 2 -Force

            ## Assert
            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Method -eq 'Delete' -and
               $Uri -eq "https://vsrm.dev.azure.com/test/project/_apis/release/definitions/2?api-version=$([VSTeamVersions]::Release)"
            }
         }
      }

      Context 'Server' {
         Mock _useWindowsAuthenticationOnPremise { return $true }
         Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' }
      
         It 'local Auth should delete release definition' {
            ## Act
            Remove-VSTeamReleaseDefinition -projectName project -id 2 -Force
            
            ## Assert
            Assert-MockCalled Invoke-RestMethod -Exactly -Scope Context -Times 1 -ParameterFilter {
               $Method -eq 'Delete' -and
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/release/definitions/2?api-version=$([VSTeamVersions]::Release)"
            }
         }
      }
   }
}