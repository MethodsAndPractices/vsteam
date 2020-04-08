Set-StrictMode -Version Latest

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/Remove-VSTeamAccount.ps1"
. "$here/../../Source/Public/$sut"

$resultsAzD = Get-Content "$PSScriptRoot\sampleFiles\buildDefvsts.json" -Raw | ConvertFrom-Json

Describe "Update-VSTeamBuildDefinition" {  
   Mock _hasProjectCacheExpired { return $false }
   
   Context "AzD" {
      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' }
      
      Mock Invoke-RestMethod {
         # If this test fails uncomment the line below to see how the mock was called.
         # Write-Host $args
         
         return $resultsAzD
      }

      It "should update build definition from json" {
         # This should stop the call to cache projects
         [VSTeamProjectCache]::timestamp = (Get-Date).Minute

         Update-VSTeamBuildDefinition -ProjectName Demo -Id 23 -BuildDefinition 'JSON'

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Put' -and
            $Uri -like "*https://dev.azure.com/test/Demo/_apis/build/definitions/23*" -and
            $Uri -like "*api-version=$(_getApiVersion Build)*"
         }
      }

      It 'should update build definition from file' {
         # This should stop the call to cache projects
         [VSTeamProjectCache]::timestamp = (Get-Date).Minute
         
         Update-VSTeamBuildDefinition -projectName project -id 2 -inFile 'sampleFiles/builddef.json' -Force

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Put' -and
            $InFile -eq 'sampleFiles/builddef.json' -and
            $Uri -eq "https://dev.azure.com/test/project/_apis/build/definitions/2?api-version=$(_getApiVersion Build)"
         }
      }
   }   

   Context 'TFS local Auth' {
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

      It 'should update build definition' {
         Assert-MockCalled Invoke-RestMethod -Exactly -Scope Context -Times 1 -ParameterFilter {
            $Method -eq 'Put' -and
            $InFile -eq 'sampleFiles/builddef.json' -and
            $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/definitions/2?api-version=$(_getApiVersion Build)"
         }
      }
   }
}