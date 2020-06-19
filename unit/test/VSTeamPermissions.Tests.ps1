Set-StrictMode -Version Latest

Describe "VSTeamPermissions" {
   BeforeAll {
      Import-Module SHiPS      
      
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")
      
      . "$PSScriptRoot/../../Source/Classes/VSTeamLeaf.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamDirectory.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamGroups.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamUsers.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/UncachedProjectCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/UncachedProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamUser.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamGroup.ps1"
      . "$PSScriptRoot/../../Source/Classes/$sut"
   }

   Context "Constructor" {
      BeforeAll {
         Mock Get-VSTeamUser { return [VSTeamGroup]::new(@{ }) }
         Mock Get-VSTeamGroup { return [VSTeamGroup]::new(@{ }) }

         $permissions = [VSTeamPermissions]::new('Permissions')
         $groups = $permissions.GetChildItem()[0]
         $users = $permissions.GetChildItem()[1]
      }

      It 'Should create Permissions' {
         $permissions | Should -Not -Be $null
         $permissions.GetChildItem().Count | Should -Be 2
      }

      It 'Should return groups' {
         $groups | Should -Not -Be $null
      }

      It 'Should return users' {
         $users | Should -Not -Be $null
      }
   }
}