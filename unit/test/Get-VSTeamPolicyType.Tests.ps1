Set-StrictMode -Version Latest

Describe "VSTeamPolicyType" {
   BeforeAll {
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamProject.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"

      ## Arrnage
      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Policy' }

      $results = [PSCustomObject]@{
         value = [PSCustomObject]@{ }
      }

      $singleResult = [PSCustomObject]@{ }

      Mock Invoke-RestMethod { return $results }
      Mock Invoke-RestMethod { throw 'Error' } -ParameterFilter { $Uri -like "*boom*" }
      Mock Invoke-RestMethod { return $singleResult } -ParameterFilter { $Uri -like "*90a51335-0c53-4a5f-b6ce-d9aff3ea60e0*" }
   }

   Context 'Get-VSTeamPolicyType' {
      It 'by project should return policies' {
         ## Act
         Get-VSTeamPolicyType -ProjectName Demo

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/Demo/_apis/policy/types?api-version=$(_getApiVersion Policy)"
         }
      }

      It 'by project throws should throw' {
         ## Act / Assert
         { Get-VSTeamPolicyType -ProjectName boom } | Should -Throw
      }

      It 'Should return policies' {
         ## Act
         Get-VSTeamPolicyType -ProjectName Demo -id 90a51335-0c53-4a5f-b6ce-d9aff3ea60e0

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/Demo/_apis/policy/types/90a51335-0c53-4a5f-b6ce-d9aff3ea60e0?api-version=$(_getApiVersion Policy)"
         }
      }

      It 'Should return policies' {
         ## Act / Assert
         { Get-VSTeamPolicyType -ProjectName boom -id 90a51335-0c53-4a5f-b6ce-d9aff3ea60e1 } | Should -Throw
      }
   }
}