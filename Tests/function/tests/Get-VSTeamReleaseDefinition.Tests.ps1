Set-StrictMode -Version Latest

Describe 'VSTeamReleaseDefinition' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock Invoke-RestMethod { Open-SampleFile 'releaseDefAzD.json' }
      Mock Invoke-RestMethod { Open-SampleFile 'releaseDefAzD.json' -Index 0 } -ParameterFilter { 
         $Uri -like "*15*" 
      }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Release' }
   }

   Context 'Get-VSTeamReleaseDefinition' {
      It 'no parameters should return Release definitions' {
         ## Act
         Get-VSTeamReleaseDefinition -projectName project

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://vsrm.dev.azure.com/test/project/_apis/release/definitions?api-version=$(_getApiVersion Release)"
         }
      }

      It 'expand environments should return Release definitions' {
         ## Act
         Get-VSTeamReleaseDefinition -projectName project -expand environments

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://vsrm.dev.azure.com/test/project/_apis/release/definitions?api-version=$(_getApiVersion Release)&`$expand=environments"
         }
      }

      It 'by Id should return Release definition' {
         ## Act
         Get-VSTeamReleaseDefinition -projectName project -id 15

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://vsrm.dev.azure.com/test/project/_apis/release/definitions/15?api-version=$(_getApiVersion Release)"
         }
      }
   }
}