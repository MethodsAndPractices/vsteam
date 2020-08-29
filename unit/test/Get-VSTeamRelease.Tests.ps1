Set-StrictMode -Version Latest

Describe 'VSTeamRelease' {
   BeforeAll {
      Import-Module SHiPS
      Add-Type -Path "$PSScriptRoot/../../dist/bin/vsteam-lib.dll"

      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamLeaf.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"

      # Prime the project cache with an empty list. This will make sure
      # any project name used will pass validation and Get-VSTeamProject 
      # will not need to be called.
      [vsteam_lib.ProjectCache]::Update([string[]]@())
      
      $samples = "$PSScriptRoot/../../lib/vsteam-lib.Test/SampleFiles"
      $results = Get-Content "$samples/Get-VSTeamRelease.json" -Raw | ConvertFrom-Json
      $singleResult = Get-Content "$samples/Get-VSTeamRelease-id178-expandEnvironments.json" -Raw | ConvertFrom-Json

      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unittest' } -ParameterFilter { $Service -eq 'Release' }

      Mock Invoke-RestMethod { return $results }
      Mock Invoke-RestMethod { return $singleResult } -ParameterFilter { $Uri -like "*178*" }
   }

   Context 'Get-VSTeamRelease' {
      It 'by Id -Raw should return release as Raw' {
         ## Act
         $raw = Get-VSTeamRelease -ProjectName VSTeamRelease -Id 178 -Raw

         ## Assert
         $raw | Get-Member | Select-Object -First 1 -ExpandProperty TypeName | Should -Be 'System.Management.Automation.PSCustomObject'

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://vsrm.dev.azure.com/test/VSTeamRelease/_apis/release/releases/178?api-version=$(_getApiVersion Release)"
         }
      }

      It 'by Id should return release as Object' {
         ## Act
         $r = Get-VSTeamRelease -ProjectName VSTeamRelease -Id 178

         ## Assert
         $r | Get-Member | Select-Object -First 1 -ExpandProperty TypeName | Should -Be 'vsteam_lib.Release'

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://vsrm.dev.azure.com/test/VSTeamRelease/_apis/release/releases/178?api-version=$(_getApiVersion Release)"
         }
      }

      It 'by Id -JSON should return release as JSON' {
         ## Act
         $r = Get-VSTeamRelease -ProjectName VSTeamRelease -Id 178 -JSON

         ## Assert
         $r | Get-Member | Select-Object -First 1 -ExpandProperty TypeName | Should -Be 'System.String'

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://vsrm.dev.azure.com/test/VSTeamRelease/_apis/release/releases/178?api-version=$(_getApiVersion Release)"
         }
      }

      It 'with no parameters should return releases' {
         ## Act
         Get-VSTeamRelease -projectName VSTeamRelease

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://vsrm.dev.azure.com/test/VSTeamRelease/_apis/release/releases?api-version=$(_getApiVersion Release)"
         }
      }

      It 'with expand environments should return releases' {
         ## Act
         Get-VSTeamRelease -projectName VSTeamRelease -expand environments

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://vsrm.dev.azure.com/test/VSTeamRelease/_apis/release/releases?api-version=$(_getApiVersion Release)&`$expand=environments"
         }
      }

      It 'with no parameters & no project should return releases' {
         ## Act
         Get-VSTeamRelease

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://vsrm.dev.azure.com/test/_apis/release/releases?api-version=$(_getApiVersion Release)"
         }
      }
   }
}