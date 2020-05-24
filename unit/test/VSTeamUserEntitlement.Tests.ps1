Set-StrictMode -Version Latest

Describe 'VSTeamUserEntitlement' -Tag 'Classes', 'Unit' {
   BeforeAll {
      Import-Module SHiPS

      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamLeaf.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Classes/$sut"
   }

   Context 'ToString' {
      BeforeAll {
         $obj = [PSCustomObject]@{
            displayName = 'Test User'
            id          = '1'
            uniqueName  = 'test@email.com'
         }

         $target = [VSTeamUserEntitlement]::new($obj, 'Test Project')
      }

      It 'should return displayname' {
         $target.ToString() | Should -Be 'Test User'
      }
   }
}