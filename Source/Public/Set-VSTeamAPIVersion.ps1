function Set-VSTeamAPIVersion {
   [CmdletBinding(DefaultParameterSetName = 'Target', SupportsShouldProcess = $true, ConfirmImpact = "Low")]
   param(
      [parameter(ParameterSetName = 'Target', Mandatory = $false, Position = 0)]
      [ValidateSet('TFS2017', 'TFS2018', 'VSTS', 'AzD')]
      [string] $Target = 'TFS2017',

      [parameter(ParameterSetName = 'Service', Mandatory = $true, Position = 0)]
      [ValidateSet('Build', 'Release', 'Core', 'Git', 'DistributedTask', 'VariableGroups', 'Tfvc', 'Packaging', 'MemberEntitlementManagement', 'ExtensionsManagement', 'ServiceFabricEndpoint', 'Graph')]
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
            'VariableGroups' {
               [VSTeamVersions]::VariableGroups = $Version
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
            'Graph' {
               [VSTeamVersions]::Graph = $Version
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
               [VSTeamVersions]::VariableGroups = '4.0-preview'
               [VSTeamVersions]::Tfvc = '3.2'
               [VSTeamVersions]::Packaging = ''
               [VSTeamVersions]::MemberEntitlementManagement = ''
               [VSTeamVersions]::ServiceFabricEndpoint = '3.2'
               [VSTeamVersions]::ExtensionsManagement = '3.2-preview'
               [VSTeamVersions]::Graph = ''
            }
            'TFS2017' {
               [VSTeamVersions]::Version = 'TFS2017'
               [VSTeamVersions]::Git = '3.0'
               [VSTeamVersions]::Core = '3.0'
               [VSTeamVersions]::Build = '3.0'
               [VSTeamVersions]::Release = '3.0-preview'
               [VSTeamVersions]::DistributedTask = '3.0-preview'
               [VSTeamVersions]::VariableGroups = '3.2-preview.1'
               [VSTeamVersions]::Tfvc = '3.0'
               [VSTeamVersions]::Packaging = ''
               [VSTeamVersions]::MemberEntitlementManagement = ''
               [VSTeamVersions]::ServiceFabricEndpoint = ''
               [VSTeamVersions]::ExtensionsManagement = '3.0-preview'
               [VSTeamVersions]::Graph = ''
            }
            Default {
               [VSTeamVersions]::Version = $Target
               [VSTeamVersions]::Git = '5.1-preview'
               [VSTeamVersions]::Core = '5.0'
               [VSTeamVersions]::Build = '5.0'
               [VSTeamVersions]::Release = '5.1-preview'
               [VSTeamVersions]::DistributedTask = '5.0-preview'
               [VSTeamVersions]::VariableGroups = '5.0-preview.1'
               [VSTeamVersions]::Tfvc = '5.0'
               [VSTeamVersions]::Packaging = '5.1-preview'
               [VSTeamVersions]::MemberEntitlementManagement = '5.1-preview'
               # This version is never passed to the API but is used to evaluate
               # if Service Fabric is enabled for the account. Just set it to
               # match Distributed Task for AzD
               [VSTeamVersions]::ServiceFabricEndpoint = '5.0-preview'
               [VSTeamVersions]::ExtensionsManagement = '5.1-preview'
               [VSTeamVersions]::Graph = '5.1-preview'
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
   Write-Verbose "VariableGroups: $([VSTeamVersions]::VariableGroups)"
   Write-Verbose "Tfvc: $([VSTeamVersions]::Tfvc)"
   Write-Verbose "Packaging: $([VSTeamVersions]::Packaging)"
   Write-Verbose "MemberEntitlementManagement: $([VSTeamVersions]::MemberEntitlementManagement)"
   Write-Verbose "ServiceFabricEndpoint: $([VSTeamVersions]::ServiceFabricEndpoint)"
   Write-Verbose "ExtensionsManagement: $([VSTeamVersions]::ExtensionsManagement)"
   Write-Verbose "Graph: $([VSTeamVersions]::Graph)"
}