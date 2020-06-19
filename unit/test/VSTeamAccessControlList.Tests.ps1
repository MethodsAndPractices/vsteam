Set-StrictMode -Version Latest

Describe "VSTeamAccessControlList" {
   BeforeAll {
      Import-Module SHiPS

      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamLeaf.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamAccessControlEntry.ps1"
      . "$PSScriptRoot/../../Source/Classes/$sut"

      $accessControlListResult = Get-Content "$PSScriptRoot\sampleFiles\accessControlListResult.json" -Raw | ConvertFrom-Json
   }

   Context "Constructor" {
      BeforeAll {
         $target = [VSTeamAccessControlList]::new($accessControlListResult.value[0])
      }

      It "toString should return token" {
         $target.ToString() | Should -Be '1ba198c0-7a12-46ed-a96b-f4e77554c6d4'
      }
   }
}