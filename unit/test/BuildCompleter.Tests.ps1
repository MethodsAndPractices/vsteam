Set-StrictMode -Version Latest

#region include
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Classes/ProjectCompleter.ps1"
. "$here/../../Source/Classes/ProjectValidateAttribute.ps1"
. "$here/../../Source/Private/applyTypes.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/Get-VSTeamBuild.ps1"
. "$here/../../Source/Classes/$sut"
#endregion

Describe "BuildCompleter" {
   Context "No default project" {
      Mock _getDefaultProject { return $null }

      It "it should return empty list" {
         $target = [BuildCompleter]::new()

         $actual = $target.CompleteArgument("Add-VSTeamRelease", "BuildNumber", "", $null, @{ })

         $actual.count | Should Be 0
      }
   }

   Context "no builds" {
      Mock _getDefaultProject { return "Test" }
      Mock Get-VSTeamBuild { return @() }

      It "it should return empty list" {
         $target = [BuildCompleter]::new()

         $actual = $target.CompleteArgument($null, $null, "", $null, @{ })

         $actual.count | Should Be 0
      }
   }

   Context "with builds" {
      Mock _getDefaultProject { return "DefaultProject" }
      $builds = Get-Content "$PSScriptRoot\sampleFiles\get-vsteambuild.json" -Raw | ConvertFrom-Json
      Mock Get-VSTeamBuild { $builds.value }

      $target = [BuildCompleter]::new()

      It "empty string should return all builds" {
         $actual = $target.CompleteArgument($null, $null, "", $null, @{ })

         $actual.count | Should Be 15
         Assert-MockCalled Get-VSTeamBuild -Scope It -Exactly -Times 1 -ParameterFilter { $ProjectName -eq 'DefaultProject' }
      }

      It "5 string should return 5 builds" {
         # This tests makes sure that even if a default project is set that the projectName parameter
         # will be used if passed in.
         $actual = $target.CompleteArgument($null, $null, "5", $null, @{ProjectName = "ProjectParameter" })

         $actual.count | Should Be 5
         Assert-MockCalled Get-VSTeamBuild -Scope It -Exactly -Times 1 -ParameterFilter { $ProjectName -eq 'ProjectParameter' }
      }
   }
}