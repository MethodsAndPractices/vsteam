Set-StrictMode -Version Latest

#region include
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Private/applyTypes.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe 'VSTeamWorkItem' {
   Mock _getInstance { return 'https://dev.azure.com/test' }

   # Mock the call to Get-Projects by the dynamic parameter for ProjectName
   Mock Invoke-RestMethod { return @() } -ParameterFilter {
      $Uri -like "*_apis/projects*"
   }

   . "$PSScriptRoot\mocks\mockProjectNameDynamicParamNoPSet.ps1"

   $obj = @{
      id  = 47
      rev = 1
      url = "https://dev.azure.com/test/_apis/wit/workItems/47"
   }

   $collection = @{
      count = 1
      value = @($obj)
   }

   Context 'Get-VSTeamWorkItem' {
      Mock Invoke-RestMethod { return $obj }
      Mock Invoke-RestMethod { return $collection } -ParameterFilter { $Uri -like "*ids=47,48*" }

      It 'by id should return work items' {
         Get-VSTeamWorkItem -Id 47, 48

         # With PowerShell core the order of the query string is not the
         # same from run to run!  So instead of testing the entire string
         # matches I have to search for the portions I expect but can't
         # assume the order.
         # The general string should look like this:
         # https://dev.azure.com/test/test/_apis/wit/workitems/?api-version=$([VSTeamVersions]::Core)&ids=47,48&`$Expand=None&errorPolicy=omit

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/_apis/wit/workitems*" -and
            $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
            $Uri -like "*ids=47,48*" -and
            $Uri -like "*`$Expand=None*" -and
            $Uri -like "*errorPolicy=omit*"
         }
      }

      It 'by Id with Default Project should return single work item' {
         Get-VSTeamWorkItem -Id 47

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/wit/workitems/47?api-version=$([VSTeamVersions]::Core)&`$Expand=None"
         }
      }
   }
}