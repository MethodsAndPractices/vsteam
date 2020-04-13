Set-StrictMode -Version Latest

#region include
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProcess.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Classes/VSTeamProcessCache.ps1"
. "$here/../../Source/Classes/ProcessCompleter.ps1"
. "$here/../../Source/Classes/ProcessValidateAttribute.ps1"
. "$here/../../Source/Classes/ProjectValidateAttribute.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe 'VSTeamProcess' {
   Mock _getProjects { return @() }
   Mock _hasProjectCacheExpired { return $true }
   Mock _hasProcessTemplateCacheExpired { return $true }
   Mock _getInstance { return 'https://dev.azure.com/test' }
   Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Core' }

   $results = [PSCustomObject]@{
      value = [PSCustomObject]@{
         name        = 'Agile'
         description = ''
         url         = ''
         id          = '123-5464-dee43'
         isDefault   = 'false'
         type        = 'Agile'
      }
   }

   $singleResult = [PSCustomObject]@{
      name        = 'Agile'
      description = ''
      url         = ''
      id          = '123-5464-dee43'
      isDefault   = 'false'
      type        = 'Agile'
   }

   Mock Invoke-RestMethod { return $results }
   Mock Invoke-RestMethod { return $singleResult } -ParameterFilter { $Uri -like "*123-5464-dee43*" }

   Context 'Get-VSTeamProcess' {
      It 'with no parameters using BearerToken should return process' {
         ## Act
         Get-VSTeamProcess

         ## Assert
         # Make sure it was called with the correct URI
         Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/_apis/process/processes*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Uri -like "*`$top=100*"
         }
      }

      It 'with top 10 should return top 10 process' {
         ## Act
         Get-VSTeamProcess -top 10

         ## Assert
         # Make sure it was called with the correct URI
         Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/_apis/process/processes*" -and
            $Uri -like "*`$top=10*"
         }
      }

      It 'with skip 1 should skip first process' {
         ## Act
         Get-VSTeamProcess -skip 1

         ## Assert
         # Make sure it was called with the correct URI
         Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/_apis/process/processes*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Uri -like "*`$skip=1*" -and
            $Uri -like "*`$top=100*"
         }
      }

      It 'by Name should return Process by Name' {
         Get-VSTeamProcess -Name Agile

         # Make sure it was called with the correct URI
         # It is called twice once for the call and once for the validator
         Assert-MockCalled Invoke-RestMethod -Exactly -Times 2 -Scope It -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/_apis/process/processes*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*"
         }
      }

      It 'by Id should return Process by Id' {
         Get-VSTeamProcess -Id '123-5464-dee43'

         # Make sure it was called with the correct URI
         Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/_apis/process/processes/123-5464-dee43*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*"
         }
      }
   }
}