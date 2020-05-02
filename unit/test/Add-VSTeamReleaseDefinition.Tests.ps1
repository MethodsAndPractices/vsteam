Set-StrictMode -Version Latest

#region include
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Classes/ProjectCompleter.ps1"
. "$here/../../Source/Classes/ProjectValidateAttribute.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/Get-VSTeamProject.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe 'VSTeamReleaseDefinition' {
   Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Release' }

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
   Mock Invoke-RestMethod { return @() } -ParameterFilter {
      $Uri -like "*_apis/projects*"
   }

   Context 'Add-VSTeamReleaseDefinition' {
      Mock Invoke-RestMethod { return $results }

      Context 'Services' {
         Mock _getInstance { return 'https://dev.azure.com/test' }

         it 'should add release' {
            ## Act
            Add-VSTeamReleaseDefinition -projectName project -inFile 'Releasedef.json'

            ## Assert
            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Method -eq 'Post' -and
               $InFile -eq 'Releasedef.json' -and
               $Uri -eq "https://vsrm.dev.azure.com/test/project/_apis/release/definitions?api-version=$(_getApiVersion Release)"
            }
         }
      }

      Context 'Server' {
         Mock _useWindowsAuthenticationOnPremise { return $true }
         Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' }

         it 'local Auth should add release' {
            ## Act
            Add-VSTeamReleaseDefinition -projectName project -inFile 'Releasedef.json'

            ## Assert
            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Method -eq 'Post' -and
               $InFile -eq 'Releasedef.json' -and
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/release/definitions?api-version=$(_getApiVersion Release)"
            }
         }
      }
   }
}