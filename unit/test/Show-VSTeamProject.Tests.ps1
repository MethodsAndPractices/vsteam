Set-StrictMode -Version Latest

#region include
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Classes/ProjectCompleter.ps1"
. "$here/../../Source/Classes/ProjectValidateAttribute.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe 'VSTeamProject' {
   Mock _getInstance { return 'https://dev.azure.com/test' }

   Context 'Show-VSTeamProject' {
      Mock Show-Browser

      It 'by ID should call start' {
         Show-VSTeamProject -Id 123456

         Assert-MockCalled Show-Browser -Exactly -Times 1 -Scope It -ParameterFilter {
            $Url -eq "https://dev.azure.com/test/123456"
         }
      }
   
      It 'by nameed ProjectName parameter should call open' {
         Show-VSTeamProject -ProjectName ShowProject

         Assert-MockCalled Show-Browser -Exactly -Times 1 -Scope It -ParameterFilter {
            $Url -eq "https://dev.azure.com/test/ShowProject"
         }
      }
   
      It 'by postion projectName parameter should call open' {
         Show-VSTeamProject ShowProject

         Assert-MockCalled Show-Browser -Exactly -Times 1 -Scope It -ParameterFilter {
            $Url -eq "https://dev.azure.com/test/ShowProject"
         }
      }
   }
}