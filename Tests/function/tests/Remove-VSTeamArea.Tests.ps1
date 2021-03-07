Set-StrictMode -Version Latest

Describe 'VSTeamArea' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath      
      . "$baseFolder/Source/Public/Remove-VSTeamClassificationNode.ps1"

      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '5.0-unitTests' } -ParameterFilter { $Service -eq 'Core' }
   }

   Context 'Remove-VSTeamArea' {
      BeforeAll {
         Mock Invoke-RestMethod { return $null }
      }

      It 'with Path "<Path>" should delete area' -TestCases @(
         @{ Path = "SubPath" }
         @{ Path = "Path/SubPath" }
      ) {
         param ($Path)
         ## Act
         Remove-VSTeamArea -ProjectName "Public Demo" -Path $Path -ReClassifyId 4 -Force

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Method -eq "Delete" -and
            $Uri -like "https://dev.azure.com/test/Public Demo/_apis/wit/classificationnodes/areas/$Path*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*"
         }
      }
   }
}

