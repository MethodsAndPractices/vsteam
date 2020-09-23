Set-StrictMode -Version Latest

Describe 'VSTeamTfvcBranch'  -Tag 'unit', 'tfvc' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Tfvc' }
   }

   Context 'Get-VSTeamTfvcBranch' {
      BeforeAll {
         Mock _callApi { Open-SampleFile 'Get-VSTeamTfvcBranch-ProjectName.json' }
         Mock _callApi { Open-SampleFile 'Get-VSTeamTfvcBranch-ProjectName.json' -Index 1 } -ParameterFilter {
            $Path -ne $null
         }
      }

      It 'should return all branches of project' {
         $actual = Get-VSTeamTfvcBranch -ProjectName 'TestProject' -IncludeChildren

         $actual.count | Should -Be 2

         Should -Invoke _callApi -Scope It -Exactly -Times 1 -ParameterFilter {
            $ProjectName -eq 'TestProject' -and
            $Area -eq 'tfvc' -and
            $Version -eq '1.0-unitTests' -and
            $QueryString['includeChildren'] -eq $true -and
            $QueryString['includeParent'] -eq $false -and
            $QueryString['includeDeleted'] -eq $false -and
            $Id -eq $null
         }
      }

      It 'should return branches under this path' {
         $actual = '$/iStay/Feature1' | Get-VSTeamTfvcBranch -IncludeDeleted

         $actual | Should -Not -Be $null

         Should -Invoke _callApi -Scope It -Exactly -Times 1 -ParameterFilter {
            $ProjectName -eq $null -and
            $Area -eq 'tfvc' -and
            $Version -eq '1.0-unitTests' -and
            $QueryString['includeChildren'] -eq $false -and
            $QueryString['includeParent'] -eq $false -and
            $QueryString['includeDeleted'] -eq $true -and
            $Id -eq '$/iStay/Feature1'
         }
      }

      It 'should return both paths' {
         Get-VSTeamTfvcBranch -Path $/iStay/Trunk, $/iStay/Feature1

         Should -Invoke _callApi -Scope It -Exactly -Times 1 -ParameterFilter {
            $Id -eq '$/iStay/Trunk'
         }
         Should -Invoke _callApi -Scope It -Exactly -Times 1 -ParameterFilter {
            $Id -eq '$/iStay/Feature1'
         }
      }
   }
}