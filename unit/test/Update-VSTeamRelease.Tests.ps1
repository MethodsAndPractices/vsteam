Set-StrictMode -Version Latest

Describe 'VSTeamRelease' {
   BeforeAll {
      Add-Type -Path "$PSScriptRoot/../../dist/bin/vsteam-lib.dll"
      
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")
      
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamRelease.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"

      # Prime the project cache with an empty list. This will make sure
      # any project name used will pass validation and Get-VSTeamProject 
      # will not need to be called.
      [vsteam_lib.ProjectCache]::Update([string[]]@())

      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unittest' } -ParameterFilter { $Service -eq 'Release' }

      $samples = "$PSScriptRoot/../../lib/vsteam-lib.Test/SampleFiles"
      $singleResult = Get-Content "$samples/Get-VSTeamRelease-id178-expandEnvironments.json" -Raw | ConvertFrom-Json

      Mock _useWindowsAuthenticationOnPremise { return $true }
      Mock Invoke-RestMethod { return $singleResult }
   }

   Context 'Update-VSTeamRelease' {
      It 'should return releases' {
         $r = Get-VSTeamRelease -ProjectName project -Id 178

         $r.variables | Add-Member NoteProperty temp(@{value = 'temp' })

         Update-VSTeamRelease -ProjectName project -Id 178 -Release $r

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Put' -and
            $Body -ne $null -and
            $Uri -eq "https://vsrm.dev.azure.com/test/project/_apis/release/releases/178?api-version=$(_getApiVersion Release)"
         }
      }
   }
}