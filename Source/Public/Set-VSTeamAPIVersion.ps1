function Set-VSTeamAPIVersion {
   [CmdletBinding(DefaultParameterSetName = 'Target', SupportsShouldProcess = $true, ConfirmImpact = "Low")]
   param(
      [parameter(ParameterSetName = 'Target', Mandatory = $false, Position = 0)]
      [ValidateSet('TFS2017', 'TFS2018', 'VSTS', 'AzD')]
      [string] $Target = 'TFS2017',

      [parameter(ParameterSetName = 'Service', Mandatory = $true, Position = 0)]
      [ValidateSet('Build', 'Release', 'Core', 'Git', 'DistributedTask', 'Tfvc', 'Packaging', 'MemberEntitlementManagement', 'ExtensionsManagement', 'ServiceFabricEndpoint')]
      [string] $Service,

      [parameter(ParameterSetName = 'Service', Mandatory = $true, Position = 1)]
      [string] $Version,

      [switch] $Force
   )

   if ($Force -or $pscmdlet.ShouldProcess($Target, "Set-VSTeamAPIVersion")) {
      if ($PSCmdlet.ParameterSetName -eq 'Service') {
         switch ($Service) {
            'Build' {
               [VSTeamVersions]::Build = $Version
            }
            'Release' {
               [VSTeamVersions]::Release = $Version
            }
            'Core' {
               [VSTeamVersions]::Core = $Version
            }
            'Git' {
               [VSTeamVersions]::Git = $Version
            }
            'DistributedTask' {
               [VSTeamVersions]::DistributedTask = $Version
            }
            'Tfvc' {
               [VSTeamVersions]::Tfvc = $Version
            }
            'Packaging' {
               [VSTeamVersions]::Packaging = $Version
            }
            'MemberEntitlementManagement' {
               [VSTeamVersions]::MemberEntitlementManagement = $Version
            }
            'ExtensionsManagement' {
               [VSTeamVersions]::ExtensionsManagement = $Version
            }
            'ServiceFabricEndpoint' {
               [VSTeamVersions]::ServiceFabricEndpoint = $Version
            }
         }
      }
      else {
         switch ($Target) {
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
            'TFS2017' {
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
            Default {
               [VSTeamVersions]::Version = $Target
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