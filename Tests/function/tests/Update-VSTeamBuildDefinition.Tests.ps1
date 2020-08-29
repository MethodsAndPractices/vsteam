Set-StrictMode -Version Latest

Describe "VSTeamBuildDefinition" {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      
      . "$baseFolder/Source/Public/Remove-VSTeamAccount.ps1"
      
      $resultsAzD = Get-Content "$sampleFiles\buildDefvsts.json" -Raw | ConvertFrom-Json
   }

   Context "Update-VSTeamBuildDefinition" {
      Context "Services" {
         BeforeAll {
            # Set the account to use for testing. A normal user would do this
            # using the Set-VSTeamAccount function.
            Mock _getInstance { return 'https://dev.azure.com/test' }

            Mock Invoke-RestMethod {
               # If this test fails uncomment the line below to see how the mock was called.
               # Write-Host $args

               return $resultsAzD
            }
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
            Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' }

            Mock _useWindowsAuthenticationOnPremise { return $true }

            Mock Invoke-RestMethod {
               # If this test fails uncomment the line below to see how the mock was called.
               # Write-Host $args

               return $resultsAzD
            }

            Update-VSTeamBuildDefinition -projectName project -id 2 -inFile 'sampleFiles/builddef.json' -Force
         }

         It 'should update build definition' {
            Should -Invoke Invoke-RestMethod -Exactly -Scope Context -Times 1 -ParameterFilter {
               $Method -eq 'Put' -and
               $InFile -eq 'sampleFiles/builddef.json' -and
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/definitions/2?api-version=$(_getApiVersion Build)"
            }
         }
      }
   }
}