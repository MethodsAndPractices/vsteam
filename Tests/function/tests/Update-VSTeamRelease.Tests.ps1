Set-StrictMode -Version Latest

Describe 'VSTeamRelease' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$baseFolder/Source/Public/Get-VSTeamRelease.ps1"

      Mock _useWindowsAuthenticationOnPremise { return $true }
      Mock _getInstance { return 'https://dev.azure.com/test' }      
      Mock _getApiVersion { return '1.0-unittest' } -ParameterFilter { $Service -eq 'Release' }
      Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamRelease-id178-expandEnvironments.json' }
   }

   Context 'Update-VSTeamRelease' {
      It 'should return releases' {
         ## Arrange
         $r = Get-VSTeamRelease -ProjectName project -Id 178
         $r.variables | Add-Member NoteProperty temp(@{value = 'temp' })

         ## Act
         Update-VSTeamRelease -ProjectName project -Id 178 -Release $r

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Put' -and
            $Body -ne $null -and
            $Uri -eq "https://vsrm.dev.azure.com/test/project/_apis/release/releases/178?api-version=$(_getApiVersion Release)"
         }
      }
   }
}