Set-StrictMode -Version Latest

#region include
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Private/applyTypes.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Classes/$sut"
#endregion

Describe "ProjectValidateAttribute" {
   Context "Existing Project" {
      Mock _hasProjectCacheExpired { return $true }
      Mock _getProjects { return @("Test1", "Test2") }

      It "it is not in list and should throw" {
         $target = [ProjectValidateAttribute]::new()

         { $target.Validate("Test", $null) } | Should Throw
      }

      It "it is in list and should not throw" {
         $target = [ProjectValidateAttribute]::new()

         { $target.Validate("Test1", $null) } | Should Not Throw
      }
   }

   Context "No Projects" {
      Mock _getProjects { return @() }
      Mock _hasProjectCacheExpired { return $true }

      It "list is empty and should not throw" {
         $target = [ProjectValidateAttribute]::new()

         { $target.Validate("Test", $null) } | Should Not Throw
      }
   }
}