function Set-VSTeamAPIVersion {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Low")]
   param(
      [ValidateSet('TFS2017', 'TFS2018', 'VSTS')]
      [string] $Version = 'TFS2017',
      [switch] $Force
   )

   if ($Force -or $pscmdlet.ShouldProcess($version, "Set-VSTeamAPIVersion")) {
      switch ($version) {
         'TFS2018' {
            [VSTeamVersions]::Version = 'TFS2018'
            [VSTeamVersions]::Git = '3.2'
            [VSTeamVersions]::Core = '3.2'
            [VSTeamVersions]::Build = '3.2'
            [VSTeamVersions]::Release = '4.0-preview'
            [VSTeamVersions]::DistributedTask = '4.0-preview'
            [VSTeamVersions]::Tfvc = '3.2'
            [VSTeamVersions]::Packaging = ''
            [VSTeamVersions]::MemberEntitlementManagement = ''
            [VSTeamVersions]::ServiceFabricEndpoint = '3.2'
            [VSTeamVersions]::ExtensionsManagement = '3.2-preview'
         }
         'VSTS' {
            [VSTeamVersions]::Version = 'VSTS'
            [VSTeamVersions]::Git = '4.0'
            [VSTeamVersions]::Core = '4.0'
            [VSTeamVersions]::Build = '4.0'
            [VSTeamVersions]::Release = '4.1-preview'
            [VSTeamVersions]::DistributedTask = '4.1-preview'
            [VSTeamVersions]::Tfvc = '4.0'
            [VSTeamVersions]::Packaging = '4.0-preview'
            [VSTeamVersions]::MemberEntitlementManagement = '4.1-preview'
            [VSTeamVersions]::ServiceFabricEndpoint = '4.1-preview'
            [VSTeamVersions]::ExtensionsManagement = '4.1-preview.1'
         }
         Default {
            [VSTeamVersions]::Version = 'TFS2017'
            [VSTeamVersions]::Git = '3.0'
            [VSTeamVersions]::Core = '3.0'
            [VSTeamVersions]::Build = '3.0'
            [VSTeamVersions]::Release = '3.0-preview'
            [VSTeamVersions]::DistributedTask = '3.0-preview'
            [VSTeamVersions]::Tfvc = '3.0'
            [VSTeamVersions]::Packaging = ''
            [VSTeamVersions]::MemberEntitlementManagement = ''
            [VSTeamVersions]::ServiceFabricEndpoint = ''
            [VSTeamVersions]::ExtensionsManagement = '3.0-preview'
         }
      }
   }

   Write-Verbose [VSTeamVersions]::Version
   Write-Verbose "Git: $([VSTeamVersions]::Git)"
   Write-Verbose "Core: $([VSTeamVersions]::Core)"
   Write-Verbose "Build: $([VSTeamVersions]::Build)"
   Write-Verbose "Release: $([VSTeamVersions]::Release)"
   Write-Verbose "DistributedTask: $([VSTeamVersions]::DistributedTask)"
   Write-Verbose "Tfvc: $([VSTeamVersions]::Tfvc)"
   Write-Verbose "Packaging: $([VSTeamVersions]::Packaging)"
   Write-Verbose "MemberEntitlementManagement: $([VSTeamVersions]::MemberEntitlementManagement)"
   Write-Verbose "ServiceFabricEndpoint: $([VSTeamVersions]::ServiceFabricEndpoint)"
   Write-Verbose "ExtensionsManagement: $([VSTeamVersions]::ExtensionsManagement)"
}