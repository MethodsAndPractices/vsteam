Set-StrictMode -Version Latest

Describe 'VSTeamBuild' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      ## Arrange
      Mock Invoke-RestMethod
      Mock _getInstance { return 'https://dev.azure.com/test' }
   }

   Context 'Update Build status' {
      It 'should post changes' {
         ## Act
         Stop-VSTeamBuild -projectName project -id 1

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -ParameterFilter {
            $Method -eq 'Patch' -and
            $Body -eq '{"status":"Cancelling"}' -and
            $Uri -eq "https://dev.azure.com/test/project/_apis/build/builds/1?api-version=$(_getApiVersion Build)" }
      }

      It 'should process pipeline with multiple ids' {
         ## Act
         $idArr = (1..3)
         $idArr | Stop-VSTeamBuild -projectName project

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times $idArr.Count -ParameterFilter {
            $Method -eq 'Patch' -and
            $Body -eq '{"status":"Cancelling"}' -and
            $Uri -like "https://dev.azure.com/test/project/_apis/build/builds/*" -and
            $Uri -like "*api-version=$(_getApiVersion Build)*"
         }
      }
   }
}