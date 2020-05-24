Set-StrictMode -Version Latest

Describe 'VSTeamRelease' {
   BeforeAll {
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamRelease.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"

      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unittest' } -ParameterFilter { $Service -eq 'Release' }

      $singleResult = [PSCustomObject]@{
         environments = [PSCustomObject]@{ }
         variables    = [PSCustomObject]@{
            BrowserToUse = [PSCustomObject]@{
               value = "phantomjs"
            }
         }
         _links       = [PSCustomObject]@{
            self = [PSCustomObject]@{ }
            web  = [PSCustomObject]@{ }
         }
      }

      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter {
         $Uri -like "*_apis/projects*"
      }
   }

   Context 'Update-VSTeamRelease' {
      BeforeAll {
         Mock _useWindowsAuthenticationOnPremise { return $true }
         Mock Invoke-RestMethod {
            return $singleResult
         }
      }

      It 'should return releases' {
         $r = Get-VSTeamRelease -ProjectName project -Id 15

         $r.variables | Add-Member NoteProperty temp(@{value = 'temp' })

         Update-VSTeamRelease -ProjectName project -Id 15 -Release $r

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Put' -and
            $Body -ne $null -and
            $Uri -eq "https://vsrm.dev.azure.com/test/project/_apis/release/releases/15?api-version=$(_getApiVersion Release)"
         }
      }
   }
}