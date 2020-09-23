Set-StrictMode -Version Latest

Describe "VSTeamReleaseDefinition" {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
   }

   Context "Update-VSTeamReleaseDefinition" {
      BeforeAll {
         Mock _callApi
         Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Release' }
      }

      It "with infile should update release" {
         ## Act
         Update-VSTeamReleaseDefinition -ProjectName Test -InFile "releaseDef.json" -Force

         ## Assert
         Should -Invoke _callApi -Scope It -Exactly -Times 1 -ParameterFilter {
            $Method -eq "Put" -and
            $SubDomain -eq 'vsrm' -and
            $Area -eq 'Release' -and
            $Resource -eq 'definitions' -and
            $Version -eq "$(_getApiVersion Release)" -and
            $InFile -eq 'releaseDef.json'
         }
      }

      It "with release definition should update release" {
         ## Act
         Update-VSTeamReleaseDefinition -ProjectName Test -ReleaseDefinition "{}" -Force

         ## Assert
         Should -Invoke _callApi -Scope It -Exactly -Times 1 -ParameterFilter {
            $Method -eq "Put" -and
            $SubDomain -eq 'vsrm' -and
            $Area -eq 'Release' -and
            $Resource -eq 'definitions' -and
            $Version -eq "$(_getApiVersion Release)" -and
            $InFile -eq $null -and
            $Body -eq "{}"
         }
      }
   }
}