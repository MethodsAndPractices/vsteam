Set-StrictMode -Version Latest

Describe 'VSTeamProcess' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Processes' }
      Mock Write-Warning
      Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamProcess.json' }
      Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamProcess.json' -Index 1 } -ParameterFilter {
         $Uri -like "*123-5464-dee43*" 
      }
   }

   Context 'Get-VSTeamProcess' {
      It 'should use process area for old APIs' {
         Mock _getApiVersion { return '' } -ParameterFilter { $Service -eq 'Processes' }

         ## Act
         $p = Get-VSTeamProcess

         ## Assert
         $p.count             | should -Be 5
         $p[0].gettype().name | should -Be 'Process'  # don't use BeOfType it's not in this scope/
         # Make sure it was called with the correct URI
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/_apis/process/processes*"
         }
      }

      It 'with no parameters using BearerToken should return process' {
         ## Act
         $p = Get-VSTeamProcess

         ## Assert
         $p.count             | should -Be 5
         $p[0].gettype().name | should -Be 'Process'  # don't use BeOfType it's not in this scope/
         # Make sure it was called with the correct URI
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/_apis/work/processes*" -and
            $Uri -like "*api-version=$(_getApiVersion Processes)*" 
         }
      }

      It 'by Name should return Process by Name' {
         [vsteam_lib.ProcessTemplateCache]::Invalidate()
         $p = Get-VSTeamProcess -Name Agile

         $p.name | should -Be  'Agile'
         $p.id   | should -Not -BeNullOrEmpty

         # Make sure it was ca lled with the correct URI
         # Only called once for name - we don't validate the name, so wildcards can be given. 
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/_apis/work/processes*" -and
            $Uri -like "*api-version=$(_getApiVersion Processes)*"
         }
      }

      It 'by Id should return Process by Id' {
         Get-VSTeamProcess -Id '123-5464-dee43'

         # Make sure it was called with the correct URI
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/_apis/work/processes/123-5464-dee43*" -and
            $Uri -like "*api-version=$(_getApiVersion Processes)*"
         }
      }
   }
}