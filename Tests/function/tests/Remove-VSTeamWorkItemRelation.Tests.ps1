Set-StrictMode -Version Latest

Describe 'VSTeamWorkItemRelation' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$baseFolder/Source/Public/Get-VSTeamWorkItem.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamWorkItemRelation.ps1"
      . "$baseFolder/Source/Public/New-VSTeamWorkItemRelation.ps1"
      . "$baseFolder/Source/Public/Update-VSTeamWorkItem.ps1"

      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '5.0-unitTests' } -ParameterFilter { $Service -eq 'Core' }
      Mock New-VSTeamWorkItemRelation { return [PSCustomObject]@{ Id = 80; RelationType = 'System.LinkTypes.Hierarchy-Reverse'; Operation = 'remove'; Index = '0' }} 
      Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamWorkItem-Id16-After.json' } -ParameterFilter { $Id -eq 16 -and $Relations -eq $null }
      Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamWorkItem-Id16.json' } -ParameterFilter { $Id -eq 16 -and $Relations -ne $null }

   }

   Context 'Remove-VSTeamWorkItemRelation' {
      It 'Should remove relations' {
         ## Act
         $workItem = Remove-VSTeamWorkItemRelation -Id 16 -FromRelatedId 80

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/wit/workitems/16?api-version=$(_getApiVersion Core)&`$Expand=Relations"
         } 
         Should -Invoke New-VSTeamWorkItemRelation -Exactly -Times 2 -Scope It
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Patch' -and
            $ContentType -eq 'application/json-patch+json; charset=utf-8' -and
            $Uri -eq "https://dev.azure.com/test/_apis/wit/workitems/16?api-version=$(_getApiVersion Core)"
         }

         $workItem.Id | Should -Be 16
         $workItem.Relations | Should -BeNullOrEmpty
      }
   }
}