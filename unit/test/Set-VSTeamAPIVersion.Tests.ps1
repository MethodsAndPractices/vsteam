Set-StrictMode -Version Latest

Describe 'VSTeamAPIVersion' {
   BeforeAll {
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"
   }

   Context 'Set-VSTeamAPIVersion' {
      It 'Should default to TFS2017' {
         Set-VSTeamAPIVersion
         [VSTeamVersions]::Version | Should -Be 'TFS2017'
      }

      It 'Should return TFS2018' {
         Set-VSTeamAPIVersion -Target TFS2018
         [VSTeamVersions]::Version | Should -Be 'TFS2018'
      }

      It 'Should return AzD2019' {
         Set-VSTeamAPIVersion -Target AzD2019
         [VSTeamVersions]::Version | Should -Be 'AzD2019'
      }

      It 'Should VSTS' {
         Set-VSTeamAPIVersion -Target VSTS
         [VSTeamVersions]::Version | Should -Be 'VSTS'
      }

      It 'Should AzD' {
         Set-VSTeamAPIVersion -Target AzD
         [VSTeamVersions]::Version | Should -Be 'AzD'
      }

      It 'Should change just TaskGroups' {
         Set-VSTeamAPIVersion -Service TaskGroups -Version '7.0'
         [VSTeamVersions]::TaskGroups | Should -Be '7.0'
      }

      It 'Should change just Build' {
         Set-VSTeamAPIVersion -Service Build -Version '7.0'
         [VSTeamVersions]::Build | Should -Be '7.0'
      }

      It 'Should change just Git' {
         Set-VSTeamAPIVersion -Service Git -Version '7.0'
         [VSTeamVersions]::Git | Should -Be '7.0'
      }

      It 'Should change just Core' {
         Set-VSTeamAPIVersion -Service Core -Version '7.0'
         [VSTeamVersions]::Core | Should -Be '7.0'
      }

      It 'Should change just Release' {
         Set-VSTeamAPIVersion -Service Release -Version '7.0'
         [VSTeamVersions]::Release | Should -Be '7.0'
      }

      It 'Should change just DistributedTask' {
         Set-VSTeamAPIVersion -Service DistributedTask -Version '7.0'
         [VSTeamVersions]::DistributedTask | Should -Be '7.0'
      }

      It 'Should change just Tfvc' {
         Set-VSTeamAPIVersion -Service Tfvc -Version '7.0'
         [VSTeamVersions]::Tfvc | Should -Be '7.0'
      }

      It 'Should change just Packaging' {
         Set-VSTeamAPIVersion -Service Packaging -Version '7.0'
         [VSTeamVersions]::Packaging | Should -Be '7.0'
      }

      It 'Should change just MemberEntitlementManagement' {
         Set-VSTeamAPIVersion -Service MemberEntitlementManagement -Version '7.0'
         [VSTeamVersions]::MemberEntitlementManagement | Should -Be '7.0'
      }

      It 'Should change just ServiceFabricEndpoint' {
         Set-VSTeamAPIVersion -Service ServiceEndpoints -Version '7.0'
         [VSTeamVersions]::ServiceEndpoints | Should -Be '7.0'
      }

      It 'Should change just ExtensionsManagement' {
         Set-VSTeamAPIVersion -Service ExtensionsManagement -Version '7.0'
         [VSTeamVersions]::ExtensionsManagement | Should -Be '7.0'
      }
   }
}