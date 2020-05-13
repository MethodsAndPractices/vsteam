Set-StrictMode -Version Latest

#region include
Import-Module SHiPS

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamLeaf.ps1"
. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Classes/VSTeamClassificationNode.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/Remove-VSTeamClassificationNode.ps1"
. "$here/../../Source/Classes/ProjectCompleter.ps1"
. "$here/../../Source/Classes/ProjectValidateAttribute.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe 'Remove-VSTeamArea' {

   Mock _getInstance { return 'https://dev.azure.com/test' }
   Mock _getApiVersion { return '5.0-unitTests' } -ParameterFilter { $Service -eq 'Core' }

   Context 'simplest call' {
      Mock Invoke-RestMethod {
         #Write-Host $args
         return $null 
      }      

      It 'should delete area' -TestCases @(
      ) {     
         ## Act
         Remove-VSTeamArea -ProjectName "Public Demo" -Force

         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Method -eq "Delete" -and
            $Uri -like "https://dev.azure.com/test/Public Demo/_apis/wit/classificationnodes/areas*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*"
         }
      }

      It 'should delete area with reclassification id <ReClassifyId>' -TestCases @(
         @{ReClassifyId = 4}
      ) {
         param ($ReClassifyId)      
         ## Act
         Remove-VSTeamArea -ProjectName "Public Demo" -ReClassifyId $ReClassifyId -Force
         
         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Method -eq "Delete" -and
            $Uri -like "https://dev.azure.com/test/Public Demo/_apis/wit/classificationnodes/areas*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*"
         }
      }

      It 'with Path "<Path>" should delete area' -TestCases @(
         @{Path = "SubPath" }
         @{Path = "Path/SubPath" }
      ) {
         param ($Path)      
         ## Act
         Remove-VSTeamArea -ProjectName "Public Demo" -Path $Path -Force

         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Method -eq "Delete" -and
            $Uri -like "https://dev.azure.com/test/Public Demo/_apis/wit/classificationnodes/areas/$Path*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*"
         }
      }
      
      It 'with empty Path "<Path>" should delete area' -TestCases @(
         @{Path = "" }
         @{Path = $null }
      ) {
         param ($Path)      
         ## Act
         Remove-VSTeamArea -ProjectName "Public Demo" -Path $Path -Force

         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Method -eq "Delete" -and
            $Uri -like "https://dev.azure.com/test/Public Demo/_apis/wit/classificationnodes/areas?*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*"
         }
      }
   }
}