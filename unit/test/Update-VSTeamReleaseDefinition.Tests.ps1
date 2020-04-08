Set-StrictMode -Version Latest

#region include
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Private/applyTypes.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe "VSTeamReleaseDefinition" {
   Context "Update-VSTeamReleaseDefinition" {
      Mock _callApi
      Mock _getApiVersion { return '1.0-unitTests'} -ParameterFilter { $Service -eq 'Release' }

      It "with infile should update release" {
         Update-VSTeamReleaseDefinition -ProjectName Test -InFile "releaseDef.json" -Force

         Assert-MockCalled _callApi -Scope It -Exactly -Times 1 -ParameterFilter {
            $Method -eq "Put" -and
            $SubDomain -eq 'vsrm' -and 
            $Area -eq 'Release' -and
            $Resource -eq 'definitions' -and 
            $Version -eq "$(_getApiVersion Release)" -and
            $ContentType -eq 'application/json' -and 
            $InFile -eq 'releaseDef.json'
         }
      }

      It "with release definition should update release" {
         Update-VSTeamReleaseDefinition -ProjectName Test -ReleaseDefinition "{}" -Force

         Assert-MockCalled _callApi -Scope It -Exactly -Times 1 -ParameterFilter {
            $Method -eq "Put" -and
            $SubDomain -eq 'vsrm' -and 
            $Area -eq 'Release' -and
            $Resource -eq 'definitions' -and 
            $Version -eq "$(_getApiVersion Release)" -and
            $ContentType -eq 'application/json' -and 
            $InFile -eq $null -and 
            $Body -eq "{}"
         }
      }
   }
}