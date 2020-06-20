Set-StrictMode -Version Latest

Describe "VSTeamReleaseDefinition" {
   BeforeAll {
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"
   }

   Context "Update-VSTeamReleaseDefinition" {
      BeforeAll {
         Mock _callApi
         Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Release' }
      }

      It "with infile should update release" {
         Update-VSTeamReleaseDefinition -ProjectName Test -InFile "releaseDef.json" -Force

         Should -Invoke _callApi -Scope It -Exactly -Times 1 -ParameterFilter {
            $Method -eq "Put" -and
            $SubDomain -eq 'vsrm' -and
            $Area -eq 'Release' -and
            $Resource -eq 'definitions' -and
            $Version -eq "$(_getApiVersion Release)" -and
            $InFile -eq 'releaseDef.json'
         }
      }

      It "with release definition should update release" {
         Update-VSTeamReleaseDefinition -ProjectName Test -ReleaseDefinition "{}" -Force

         Should -Invoke _callApi -Scope It -Exactly -Times 1 -ParameterFilter {
            $Method -eq "Put" -and
            $SubDomain -eq 'vsrm' -and
            $Area -eq 'Release' -and
            $Resource -eq 'definitions' -and
            $Version -eq "$(_getApiVersion Release)" -and
            $InFile -eq $null -and
            $Body -eq "{}"
         }
      }
   }
}