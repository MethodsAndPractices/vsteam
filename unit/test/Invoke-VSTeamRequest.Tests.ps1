Set-StrictMode -Version Latest

#region include
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Classes/ProjectCompleter.ps1"
. "$here/../../Source/Classes/ProjectValidateAttribute.ps1"
. "$here/../../Source/Classes/UnCachedProjectCompleter.ps1"
. "$here/../../Source/Classes/UnCachedProjectValidateAttribute.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/Get-VSTeamProject.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe 'Invoke-VSTeamRequest' {
   Mock _hasProjectCacheExpired { return $false }
   
   Context 'Invoke-VSTeamRequest Options' {
      Mock Invoke-RestMethod

      Mock _getInstance { return 'https://dev.azure.com/test' }

      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter { $Uri -like "*_apis/projects*" }

      # Called to convert from ProjectName to ProjectID
      Mock Get-VSTeamProject { return [PSCustomObject]@{ id = '00000000-0000-0000-0000-000000000000' } } -Verifiable

      It 'options should call API' {
         Invoke-VSTeamRequest -Method Options
         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq "Options" -and
            $Uri -eq "https://dev.azure.com/test/_apis"
         }
      }

      It 'release should call API' {
         Invoke-VSTeamRequest -Area release -Resource releases -Id 1 -SubDomain vsrm -Version '4.1-preview' -ProjectName testproject -JSON
         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://vsrm.dev.azure.com/test/testproject/_apis/release/releases/1?api-version=4.1-preview"
         }
      }

      It 'AdditionalHeaders should call API' {
         Invoke-VSTeamRequest -Area release -Resource releases -Id 1 -SubDomain vsrm -Version '4.1-preview' -ProjectName testproject -JSON -AdditionalHeaders @{Test = "Test" }
         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Headers["Test"] -eq 'Test' -and
            $Uri -eq "https://vsrm.dev.azure.com/test/testproject/_apis/release/releases/1?api-version=4.1-preview"
         }
      }

      It 'by Product Id should call API with product id instead of name' {
         Invoke-VSTeamRequest -ProjectName testproject -UseProjectId -Area release -Resource releases -Id 1 -SubDomain vsrm -Version '4.1-preview'

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://vsrm.dev.azure.com/test/00000000-0000-0000-0000-000000000000/_apis/release/releases/1?api-version=4.1-preview"
         }
      }
   }
}