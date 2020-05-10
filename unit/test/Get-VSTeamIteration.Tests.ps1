Set-StrictMode -Version Latest

#region include
Import-Module SHiPS

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamLeaf.ps1"
. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Classes/ProjectCompleter.ps1"
. "$here/../../Source/Classes/ProjectValidateAttribute.ps1"
. "$here/../../Source/Classes/VSTeamClassificationNode.ps1"
. "$here/../../Source/Public/Get-VSTeamClassificationNode"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe 'Get-VSTeamIteration' {
   $withoutChildNode = Get-Content "$PSScriptRoot\sampleFiles\withoutChildNode.json" -Raw | ConvertFrom-Json
   $classificationNodeResult = Get-Content "$PSScriptRoot\sampleFiles\classificationNodeResult.json" -Raw | ConvertFrom-Json

   # Set the account to use for testing. A normal user would do this
   # using the Set-VSTeamAccount function.
   Mock _getInstance { return 'https://dev.azure.com/test' }

   Mock _getApiVersion { return '5.0-unitTests' } -ParameterFilter { $Service -eq 'Core' }
   
   # Mock the call to Get-Projects by the dynamic parameter for ProjectName
   Mock Invoke-RestMethod { return @() } -ParameterFilter { $Uri -like "*_apis/projects*" }

   Context 'simplest call' {
      Mock Invoke-RestMethod { return $classificationNodeResult }
      Mock Invoke-RestMethod { return $withoutChildNode } -ParameterFilter { $Uri -like "*Ids=43,44*" }

      It 'by ids, path and depth should return iterations' {
         ## Act
         Get-VSTeamIteration -ProjectName "Public Demo" -Ids @(1, 2, 3, 4) -Depth 5 -Path "test/test/test"

         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/Public Demo/_apis/wit/classificationnodes/Iterations/test/test/test*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Uri -like "*Ids=1,2,3,4*" -and
            $Uri -like "*`$Depth=10*"
         }
      }
   }
}