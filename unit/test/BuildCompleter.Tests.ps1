Set-StrictMode -Version Latest

Describe "BuildCompleter" {
   BeforeAll {
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamBuild.ps1"
      . "$PSScriptRoot/../../Source/Classes/$sut"
   }

   Context "No default project" {
      BeforeAll {
         Mock _getDefaultProject { return $null }
      }

      It "it should return empty list" {
         $target = [BuildCompleter]::new()

         $actual = $target.CompleteArgument("Add-VSTeamRelease", "BuildNumber", "", $null, @{ })

         $actual.count | Should -Be 0
      }
   }

   Context "no builds" {
      BeforeAll {
         Mock _getDefaultProject { return "Test" }
         Mock Get-VSTeamBuild { return @() }
      }

      It "it should return empty list" {
         $target = [BuildCompleter]::new()

         $actual = $target.CompleteArgument($null, $null, "", $null, @{ })

         $actual.count | Should -Be 0
      }
   }

   Context "with builds" {
      BeforeAll {
         Mock _getDefaultProject { return "DefaultProject" }
         $builds = Get-Content "$PSScriptRoot\sampleFiles\get-vsteambuild.json" -Raw | ConvertFrom-Json
         Mock Get-VSTeamBuild { $builds.value }

         $target = [BuildCompleter]::new()
      }

      It "empty string should return all builds" {
         $actual = $target.CompleteArgument($null, $null, "", $null, @{ })

         $actual.count | Should -Be 15
         Should -Invoke Get-VSTeamBuild -Scope It -Exactly -Times 1 -ParameterFilter { $ProjectName -eq 'DefaultProject' }
      }

      It "5 string should return 5 builds" {
         # This tests makes sure that even if a default project is set that the projectName parameter
         # will be used if passed in.
         $actual = $target.CompleteArgument($null, $null, "5", $null, @{ProjectName = "ProjectParameter" })

         $actual.count | Should -Be 5
         Should -Invoke Get-VSTeamBuild -Scope It -Exactly -Times 1 -ParameterFilter { $ProjectName -eq 'ProjectParameter' }
      }
   }
}

