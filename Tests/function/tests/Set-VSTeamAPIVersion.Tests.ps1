Set-StrictMode -Version Latest

Describe 'VSTeamAPIVersion' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
   }

   Context 'Set-VSTeamAPIVersion' {
      It 'Should default to TFS2017' {
         Set-VSTeamAPIVersion
         [vsteam_lib.Versions]::Version | Should -Be 'TFS2017'
      }

      It 'Should return TFS2018' {
         Set-VSTeamAPIVersion -Target TFS2018
         [vsteam_lib.Versions]::Version | Should -Be 'TFS2018'
      }

      It 'Should return AzD2019' {
         Set-VSTeamAPIVersion -Target AzD2019
         [vsteam_lib.Versions]::Version | Should -Be 'AzD2019'
      }

      It 'Should VSTS' {
         Set-VSTeamAPIVersion -Target VSTS
         [vsteam_lib.Versions]::Version | Should -Be 'VSTS'
      }

      It 'Should AzD' {
         Set-VSTeamAPIVersion -Target AzD
         [vsteam_lib.Versions]::Version | Should -Be 'AzD'
      }

      It 'Should change just TaskGroups' {
         Set-VSTeamAPIVersion -Service TaskGroups -Version '7.0'
         [vsteam_lib.Versions]::TaskGroups | Should -Be '7.0'
      }

      It 'Should change just Build' {
         Set-VSTeamAPIVersion -Service Build -Version '7.0'
         [vsteam_lib.Versions]::Build | Should -Be '7.0'
      }

      It 'Should change just Git' {
         Set-VSTeamAPIVersion -Service Git -Version '7.0'
         [vsteam_lib.Versions]::Git | Should -Be '7.0'
      }

      It 'Should change just Core' {
         Set-VSTeamAPIVersion -Service Core -Version '7.0'
         [vsteam_lib.Versions]::Core | Should -Be '7.0'
      }

      It 'Should change just Release' {
         Set-VSTeamAPIVersion -Service Release -Version '7.0'
         [vsteam_lib.Versions]::Release | Should -Be '7.0'
      }

      It 'Should change just DistributedTask' {
         Set-VSTeamAPIVersion -Service DistributedTask -Version '7.0'
         [vsteam_lib.Versions]::DistributedTask | Should -Be '7.0'
      }

      It 'Should change just Tfvc' {
         Set-VSTeamAPIVersion -Service Tfvc -Version '7.0'
         [vsteam_lib.Versions]::Tfvc | Should -Be '7.0'
      }

      It 'Should change just Packaging' {
         Set-VSTeamAPIVersion -Service Packaging -Version '7.0'
         [vsteam_lib.Versions]::Packaging | Should -Be '7.0'
      }

      It 'Should change just MemberEntitlementManagement' {
         Set-VSTeamAPIVersion -Service MemberEntitlementManagement -Version '7.0'
         [vsteam_lib.Versions]::MemberEntitlementManagement | Should -Be '7.0'
      }

      It 'Should change just ServiceFabricEndpoint' {
         Set-VSTeamAPIVersion -Service ServiceEndpoints -Version '7.0'
         [vsteam_lib.Versions]::ServiceEndpoints | Should -Be '7.0'
      }

      It 'Should change just ExtensionsManagement' {
         Set-VSTeamAPIVersion -Service ExtensionsManagement -Version '7.0'
         [vsteam_lib.Versions]::ExtensionsManagement | Should -Be '7.0'
      }
   }
}