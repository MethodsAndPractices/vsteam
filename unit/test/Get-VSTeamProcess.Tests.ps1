Set-StrictMode -Version Latest

Describe 'VSTeamProcess' {
   BeforeAll {
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")
   
      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProcess.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProcessCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProcessTemplateCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProcessValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"
   
      Mock _getProjects { return @() }
      Mock _hasProjectCacheExpired { return $true }
      Mock _hasProcessTemplateCacheExpired { return $true }
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Processes' }

      # Note: if the call is to ...work/processes... the identity field is "TypeID". calling to ...Process/processes... it is "ID"
      $results = [PSCustomObject]@{
         value = @(
            [PSCustomObject]@{
               name        = 'Agile'
               description = ''
               url         = ''
               typeid      = '123-5464-dee43'
               isDefault   = 'false'
               type        = 'Agile'
            }
            [PSCustomObject]@{
               name        = 'Scrum'
               description = ''
               url         = ''
               typeid      = '234-6575-eff54'
               isDefault   = 'false'
               type        = 'Agile'
            }
         )
      }

      $singleResult = [PSCustomObject]@{
         name        = 'Agile'
         description = ''
         url         = ''
         typeid      = '123-5464-dee43'
         isDefault   = 'false'
         type        = 'Agile'
      }

      Mock Write-Warning
      Mock Invoke-RestMethod { return $results }
      Mock Invoke-RestMethod { return $singleResult } -ParameterFilter { $Uri -like "*123-5464-dee43*" }
   }

   Context 'Get-VSTeamProcess' {
      It 'should use process area for old APIs' {
         Mock _getApiVersion { return '' } -ParameterFilter { $Service -eq 'Processes' }

         ## Act
         $p = Get-VSTeamProcess

         ## Assert
         $p.count             | should -Be 2 
         $p[0].gettype().name | should -Be VSTeamProcess  # don't use BeOfType it's not in this scope/
         # Make sure it was called with the correct URI
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/_apis/process/processes*"
         }
      }

      It 'with no parameters using BearerToken should return process' {
         ## Act
         $p = Get-VSTeamProcess

         ## Assert
         $p.count             | should -Be 2 
         $p[0].gettype().name | should -Be VSTeamProcess  # don't use BeOfType it's not in this scope/
         # Make sure it was called with the correct URI
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/_apis/work/processes*" -and
            $Uri -like "*api-version=$(_getApiVersion Processes)*" 
         }
      }
      
      It 'with top should return warning' {
         ## Act
         Get-VSTeamProcess -top 10

         ## Assert
         # Make sure you warn the user
         Should -Invoke Write-Warning -Exactly -Times 1 -Scope It

         # Make sure it was called with the correct URI
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/_apis/work/processes*" -and
            $Uri -NotLike "*`$top=10*"
         }
      }

      It 'with skip should return warning' {
         ## Act
         Get-VSTeamProcess -skip 1

         ## Assert
         # Make sure you warn the user
         Should -Invoke Write-Warning -Exactly -Times 1 -Scope It

         # Make sure it was called with the correct URI
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/_apis/work/processes*" -and
            $Uri -like "*api-version=$(_getApiVersion Processes)*" -and
            $Uri -NotLike "*`$skip=1*" -and
            $Uri -NotLike "*`$top=100*"
         }
      }

      It 'by Name should return Process by Name' {
         [VSTeamProcessCache]::timestamp = -1
         $p = Get-VSTeamProcess -Name Agile

         $p.name | should -Be  'Agile'
         $p.id   | should -Not -BeNullOrEmpty

         # Make sure it was ca lled with the correct URI
         # Only called once for name - we don't validate the name, so wildcards can be given. 
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/_apis/work/processes*" -and
            $Uri -like "*api-version=$(_getApiVersion Processes)*"
         }
      }

      It 'by Id should return Process by Id' {
         Get-VSTeamProcess -Id '123-5464-dee43'

         # Make sure it was called with the correct URI
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/_apis/work/processes/123-5464-dee43*" -and
            $Uri -like "*api-version=$(_getApiVersion Processes)*"
         }
      }
   }
}