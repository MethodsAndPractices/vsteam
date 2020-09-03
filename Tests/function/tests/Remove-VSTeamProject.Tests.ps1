Set-StrictMode -Version Latest

Describe 'VSTeamProject' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      . "$baseFolder/Source/Classes/VSTeamLeaf.ps1"
      . "$baseFolder/Source/Classes/VSTeamDirectory.ps1"
      . "$baseFolder/Source/Private/applyTypes.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamQueue.ps1"
      . "$baseFolder/Source/Public/Remove-VSTeamAccount.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamBuildDefinition.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamProject.ps1"

      $singleResult = [PSCustomObject]@{
         name        = 'Test'
         description = ''
         url         = ''
         id          = '123-5464-dee43'
         state       = ''
         visibility  = ''
         revision    = [long]0
         defaultTeam = [PSCustomObject]@{ }
         _links      = [PSCustomObject]@{ }
      }

      Mock _getInstance { return 'https://dev.azure.com/test' }

      Mock Write-Progress
      Mock _trackProjectProgress
      Mock Invoke-RestMethod { return $singleResult } -ParameterFilter { $Uri -eq "https://dev.azure.com/test/_apis/projects/Test?api-version=$(_getApiVersion Core)" }
      Mock Invoke-RestMethod { return @{status = 'inProgress'; url = 'https://someplace.com' } } -ParameterFilter { $Method -eq 'Delete' -and $Uri -eq "https://dev.azure.com/test/_apis/projects/123-5464-dee43?api-version=$(_getApiVersion Core)" }
      Mock Invoke-RestMethod
   }

   Context 'Remove-VSTeamProject with Force' {
      It 'Should not call Invoke-RestMethod' {
         ## Act
         Remove-VSTeamProject -ProjectName Test -Force

         ## Assert
         Should -Invoke Invoke-RestMethod -Times 1 -ParameterFilter { $Uri -eq "https://dev.azure.com/test/_apis/projects/Test?api-version=$(_getApiVersion Core)" }
         Should -Invoke Invoke-RestMethod -Times 1 -ParameterFilter { $Method -eq 'Delete' -and $Uri -eq "https://dev.azure.com/test/_apis/projects/123-5464-dee43?api-version=$(_getApiVersion Core)" }
      }
   }
}