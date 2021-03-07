Set-StrictMode -Version Latest

Describe 'VSTeamProject' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$baseFolder/Source/Public/Get-VSTeamProject.ps1"

      Mock _getInstance { return 'https://dev.azure.com/test' }

      Mock Write-Progress
      Mock _trackProjectProgress
      Mock Invoke-RestMethod
      Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamProject-NamePeopleTracker.json' } -ParameterFilter {
         $Uri -eq "https://dev.azure.com/test/_apis/projects/Test?api-version=$(_getApiVersion Core)"
      }
      Mock Invoke-RestMethod { return @{ status = 'inProgress'; url = 'https://someplace.com' } } -ParameterFilter { 
         $Method -eq 'Delete' -and
         $Uri -eq "https://dev.azure.com/test/_apis/projects/00000000-0000-0000-0000-000000000000?api-version=$(_getApiVersion Core)" 
      }
   }

   Context 'Remove-VSTeamProject with Force' {
      It 'Should not call Invoke-RestMethod' {
         ## Act
         Remove-VSTeamProject -ProjectName Test -Force

         ## Assert
         Should -Invoke Invoke-RestMethod -Times 1 -ParameterFilter { 
            $Uri -eq "https://dev.azure.com/test/_apis/projects/Test?api-version=$(_getApiVersion Core)" 
         }
         Should -Invoke Invoke-RestMethod -Times 1 -ParameterFilter {
            $Method -eq 'Delete' -and $Uri -eq "https://dev.azure.com/test/_apis/projects/00000000-0000-0000-0000-000000000000?api-version=$(_getApiVersion Core)" 
         }
      }
   }
}