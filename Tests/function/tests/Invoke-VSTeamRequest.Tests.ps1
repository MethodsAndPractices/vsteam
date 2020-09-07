Set-StrictMode -Version Latest

Describe 'VSTeamRequest' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$baseFolder/Source/Public/Get-VSTeamProject.ps1"
   }

   Context 'Invoke-VSTeamRequest Options' {
      BeforeAll {
         Mock Invoke-RestMethod
         Mock _getInstance { return 'https://dev.azure.com/test' }

         $projectResult = Open-SampleFile 'projectResult.json'

         Mock _callAPI { return $projectResult } -ParameterFilter {
            $Resource -eq 'projects' -and
            $id -eq 'testproject' -and
            $Version -eq "$(_getApiVersion Core)" -and
            $IgnoreDefaultProject -eq $true
         }
      }

      It 'options should call API' {
         Invoke-VSTeamRequest -Method OPTIONS -NoProject

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq "Options" -and
            $Uri -eq "https://dev.azure.com/test/_apis"
         }
      }

      It 'release should call API' {
         Invoke-VSTeamRequest -Area release -Resource releases -Id 1 -SubDomain vsrm -Version '4.1-preview' -ProjectName testproject -JSON

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://vsrm.dev.azure.com/test/testproject/_apis/release/releases/1?api-version=4.1-preview"
         }
      }

      It 'AdditionalHeaders should call API' {
         Invoke-VSTeamRequest -Area release -Resource releases -Id 1 -SubDomain vsrm -Version '4.1-preview' -ProjectName testproject -JSON -AdditionalHeaders @{Test = "Test" }

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Headers["Test"] -eq 'Test' -and
            $Uri -eq "https://vsrm.dev.azure.com/test/testproject/_apis/release/releases/1?api-version=4.1-preview"
         }
      }

      It 'by Product Id should call API with product id instead of name' {
         Invoke-VSTeamRequest -ProjectName testproject -UseProjectId -Area release -Resource releases -Id 1 -SubDomain vsrm -Version '4.1-preview'

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://vsrm.dev.azure.com/test/010d06f0-00d5-472a-bb47-58947c230876/_apis/release/releases/1?api-version=4.1-preview"
         }
      }
   }
}