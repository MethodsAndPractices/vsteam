Set-StrictMode -Version Latest

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProcess.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Classes/VSTeamProcessCache.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/$sut"
   
Describe 'Get-VSTeamProcess' {
   [VSTeamVersions]::Account = 'https://dev.azure.com/test'
   . "$PSScriptRoot\mocks\mockProcessNameDynamicParam.ps1"

   $results = [PSCustomObject]@{
      value = [PSCustomObject]@{
         name        = 'Test'
         description = ''
         url         = ''
         id          = '123-5464-dee43'
         isDefault   = 'false'
         type        = 'Agile'
      }
   }

   $singleResult = [PSCustomObject]@{
      name        = 'Test'
      description = ''
      url         = ''
      id          = '123-5464-dee43'
      isDefault   = 'false'
      type        = 'Agile'
   }

   Context 'Get-VSTeamProcess with no parameters using BearerToken' {

      Mock Invoke-RestMethod { return $results }

      It 'Should return process' {
         Get-VSTeamProcess

         # Make sure it was called with the correct URI
         Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/_apis/process/processes/*" -and
            $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
            $Uri -like "*`$top=100*"
         }
      }
   }

   Context 'Get-VSTeamProcess with top 10' {

      Mock Invoke-RestMethod {
         # If this test fails uncomment the line below to see how the mock was called.
         #Write-Host $args
         return $results 
      }

      It 'Should return top 10 process' {
         Get-VSTeamProcess -top 10

         # Make sure it was called with the correct URI
         Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/_apis/process/processes/*" -and
            $Uri -like "*`$top=10*"
         }
      }
   }

   Context 'Get-VSTeamProcess with skip 1' {

      Mock Invoke-RestMethod { return $results }

      It 'Should skip first process' {
         Get-VSTeamProcess -skip 1

         # Make sure it was called with the correct URI
         Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/_apis/process/processes/*" -and
            $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
            $Uri -like "*`$skip=1*" -and
            $Uri -like "*`$top=100*"
         }
      }
   }

   Context 'Get-VSTeamProcess by Name' {
      #Although this returns a single VSTeamProcess instance, the REST call returns multiple results
      Mock Invoke-RestMethod { return $results }

      It 'Should return Process by Name' {
         Get-VSTeamProcess -Name Agile

         # Make sure it was called with the correct URI
         Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/_apis/process/processes/*" -and
            $Uri -like "*api-version=$([VSTeamVersions]::Core)*"
         }
      }
   }

   Context 'Get-VSTeamProcess by Id' {

      Mock Invoke-RestMethod { return $singleResult }

      It 'Should return Process by Id' {
         Get-VSTeamProcess -Id '123-5464-dee43'

         # Make sure it was called with the correct URI
         Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/_apis/process/processes/*" -and
            $Uri -like "*api-version=$([VSTeamVersions]::Core)*"
         }
      }
   }
}