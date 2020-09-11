Set-StrictMode -Version Latest

Describe "VSTeamBuildDefinition" {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$baseFolder/Source/Public/Remove-VSTeamAccount.ps1"
   }

   Context "Update-VSTeamBuildDefinition" {
      Context "Services" {
         BeforeAll {
            # Set the account to use for testing. A normal user would do this
            # using the Set-VSTeamAccount function.
            Mock _getInstance { return 'https://dev.azure.com/test' }
            Mock Invoke-RestMethod { Open-SampleFile 'buildDefvsts.json' }
         }

         It "should update build definition from json" {
            Update-VSTeamBuildDefinition -ProjectName Demo -Id 23 -BuildDefinition 'JSON'

            Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Method -eq 'Put' -and
               $Uri -like "*https://dev.azure.com/test/Demo/_apis/build/definitions/23*" -and
               $Uri -like "*api-version=$(_getApiVersion Build)*"
            }
         }

         It 'should update build definition from file' {
            Update-VSTeamBuildDefinition -projectName project -id 2 -inFile 'sampleFiles/builddef.json' -Force

            Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Method -eq 'Put' -and
               $InFile -eq 'sampleFiles/builddef.json' -and
               $Uri -eq "https://dev.azure.com/test/project/_apis/build/definitions/2?api-version=$(_getApiVersion Build)"
            }
         }
      }

      Context 'Server' {
         BeforeAll {
            # Set the account to use for testing. A normal user would do this
            # using the Set-VSTeamAccount function.
            Remove-VSTeamAccount
            Mock _useWindowsAuthenticationOnPremise { return $true }
            Mock Invoke-RestMethod { Open-SampleFile 'buildDefvsts.json' }
            Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' }
         }
         
         It 'should update build definition' {
            Update-VSTeamBuildDefinition -projectName project -id 2 -inFile 'sampleFiles/builddef.json' -Force

            Should -Invoke Invoke-RestMethod -Exactly -Scope Context -Times 1 -ParameterFilter {
               $Method -eq 'Put' -and
               $InFile -eq 'sampleFiles/builddef.json' -and
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/definitions/2?api-version=$(_getApiVersion Build)"
            }
         }
      }
   }
}