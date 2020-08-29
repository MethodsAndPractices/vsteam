Set-StrictMode -Version Latest

Describe 'VSTeamBuild' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      Mock Invoke-RestMethod
   }

   Context 'Update Build status' {
      BeforeAll {
         # Set the account to use for testing. A normal user would do this
         # using the Set-VSTeamAccount function.
         Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable
      }

      It 'should post changes' {
         Stop-VSTeamBuild -projectName project -id 1

         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -ParameterFilter {
            $Method -eq 'Patch' -and
            $Body -eq '{"status":"Cancelling"}' -and
            $Uri -eq "https://dev.azure.com/test/project/_apis/build/builds/1?api-version=$(_getApiVersion Build)" }
      }

      It 'should process pipeline with multiple ids' {

         $idArr = (1..3)

         $idArr | Stop-VSTeamBuild -projectName project

         Should -Invoke Invoke-RestMethod -Exactly -Times $idArr.Count -ParameterFilter {
            $Method -eq 'Patch' -and
            $Body -eq '{"status":"Cancelling"}' -and
            $Uri -like "https://dev.azure.com/test/project/_apis/build/builds/*" -and
            $Uri -like "*api-version=$(_getApiVersion Build)*"
          }
      }
   }
}