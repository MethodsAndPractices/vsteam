Set-StrictMode -Version Latest

#region include
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamProcessCache.ps1"
. "$here/../../Source/Private/applyTypes.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Classes/$sut"
#endregion

Describe "ProcessValidateAttribute" {
   Context "Existing Process" {
      Mock _hasProcessTemplateCacheExpired { return $true }
      Mock _getProcesses { return @("Test1", "Test2") }

      It "it is not in list and should throw" {
         $target = [ProcessValidateAttribute]::new()

         { $target.Validate("Test", $null) } | Should Throw
      }

      It "it is in list and should not throw" {
         $target = [ProcessValidateAttribute]::new()

         { $target.Validate("Test1", $null) } | Should Not Throw
      }
   }

   Context "No Processes" {
      Mock _getProcesses { return @() }
      Mock _hasProcessTemplateCacheExpired { return $true }

      It "list is empty and should not throw" {
         $target = [ProcessValidateAttribute]::new()

         { $target.Validate("Test", $null) } | Should Not Throw
      }
   }
}