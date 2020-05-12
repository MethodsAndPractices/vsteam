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

Describe 'Get-VSTeamArea' {

   $classificationNodeResult = Get-Content "$PSScriptRoot\sampleFiles\classificationNodeResult.json" -Raw | ConvertFrom-Json

   # Make sure the project name is valid. By returning an empty array
   # all project names are valid. Otherwise, you name you pass for the
   # project in your commands must appear in the list.
   Mock _getProjects { return @() }
   Mock _getInstance { return 'https://dev.azure.com/test' }
   Mock _getApiVersion { return '5.0-unitTests' } -ParameterFilter { $Service -eq 'Core' }
   
   Context 'simplest call' {
      Mock Invoke-RestMethod {
         # Write-Host $args
         return $classificationNodeResult 
      }

      It 'by path and depth should return areas' {
         ## Act
         Get-VSTeamArea -ProjectName "Public Demo" -Depth 5 -Path "test/test/test"

         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/Public Demo/_apis/wit/classificationnodes/areas/test/test/test*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Uri -like "*`$Depth=5*"
         }
      }

      It 'by Ids and depth should return areas' {
         ## Act
         Get-VSTeamArea -ProjectName "Public Demo" -Ids @(1, 2, 3, 4) -Depth 5

         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/Public Demo/_apis/wit/classificationnodes*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Uri -like "*Ids=1,2,3,4*" -and
            $Uri -like "*`$Depth=5*"
         }
      }
   }
}