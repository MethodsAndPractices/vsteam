function Set-VSTeamAPIVersion {
   [CmdletBinding(DefaultParameterSetName = 'Target', SupportsShouldProcess = $true, ConfirmImpact = "Low")]
   param(
      [parameter(ParameterSetName = 'Target', Mandatory = $false, Position = 0)]
      [ValidateSet('TFS2017', 'TFS2018', 'AzD2019', 'VSTS', 'AzD', 'TFS2017U1', 'TFS2017U2', 'TFS2017U3', 'TFS2018U1', 'TFS2018U2', 'TFS2018U3', 'AzD2019U1')]
      [string] $Target = 'TFS2017',

      [parameter(ParameterSetName = 'Service', Mandatory = $true, Position = 0)]
      [ValidateSet('Build', 'Release', 'Core', 'Git', 'DistributedTask', 'VariableGroups', 'Tfvc', 'Packaging', 'MemberEntitlementManagement', 'ExtensionsManagement', 'ServiceEndpoints', 'Graph', 'TaskGroups', 'Policy')]
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
            'ServiceEndpoints' {
               [VSTeamVersions]::ServiceEndpoints = $Version
            }
            'Graph' {
               [VSTeamVersions]::Graph = $Version
            }
            'TaskGroups' {
               [VSTeamVersions]::TaskGroups = $Version
            }
            'Policy' {
               [VSTeamVersions]::Policy = $Version
            }
         }
      }
      else {
         # https://docs.microsoft.com/en-us/rest/api/azure/devops/?view=azure-devops-rest-5.1#api-and-tfs-version-mapping
         switch ($Target) {
            'AzD2019' {
               [VSTeamVersions]::Version = 'AzD2019'
               [VSTeamVersions]::Git = '5.0'
               [VSTeamVersions]::Core = '5.0'
               [VSTeamVersions]::Build = '5.0'
               [VSTeamVersions]::Release = '5.0'
               [VSTeamVersions]::DistributedTask = '5.0-preview'
               [VSTeamVersions]::VariableGroups = '5.0-preview'
               [VSTeamVersions]::Tfvc = '5.0'
               [VSTeamVersions]::Packaging = '5.0-preview'
               [VSTeamVersions]::TaskGroups = '5.0-preview'
               [VSTeamVersions]::MemberEntitlementManagement = ''
               [VSTeamVersions]::ServiceEndpoints = '5.0-preview'
               [VSTeamVersions]::ExtensionsManagement = '5.0-preview'
               [VSTeamVersions]::Graph = ''
               [VSTeamVersions]::Policy = '5.0'
               [VSTeamVersions]::Processes = '5.0-preview'
            }
            'AzD2019U1' {
               [VSTeamVersions]::Version = 'AzD2019'
               [VSTeamVersions]::Git = '5.1'
               [VSTeamVersions]::Core = '5.1'
               [VSTeamVersions]::Build = '5.1'
               [VSTeamVersions]::Release = '5.1'
               [VSTeamVersions]::DistributedTask = '5.1-preview'
               [VSTeamVersions]::VariableGroups = '5.1-preview'
               [VSTeamVersions]::Tfvc = '5.1'
               [VSTeamVersions]::Packaging = '5.1-preview'
               [VSTeamVersions]::TaskGroups = '5.1-preview'
               [VSTeamVersions]::MemberEntitlementManagement = ''
               [VSTeamVersions]::ServiceEndpoints = '5.1-preview'
               [VSTeamVersions]::ExtensionsManagement = '5.1-preview'
               [VSTeamVersions]::Graph = ''
               [VSTeamVersions]::Policy = '5.1'
               [VSTeamVersions]::Processes = '5.1-preview'
            }
            { $_ -eq 'TFS2018' -or $_ -eq 'TFS2018U1' } {
               [VSTeamVersions]::Version = 'TFS2018'
               [VSTeamVersions]::Git = '4.0'
               [VSTeamVersions]::Core = '4.0'
               [VSTeamVersions]::Build = '4.0'
               [VSTeamVersions]::Release = '4.0-preview'
               [VSTeamVersions]::DistributedTask = '4.0-preview'
               [VSTeamVersions]::VariableGroups = '4.0-preview'
               [VSTeamVersions]::Tfvc = '4.0'
               [VSTeamVersions]::Packaging = '4.0-preview'
               [VSTeamVersions]::TaskGroups = '4.0-preview'
               [VSTeamVersions]::MemberEntitlementManagement = ''
               [VSTeamVersions]::ServiceEndpoints = '4.0-preview'
               [VSTeamVersions]::ExtensionsManagement = '4.0-preview'
               [VSTeamVersions]::Graph = ''
               [VSTeamVersions]::Policy = '4.0'
               [VSTeamVersions]::Processes = '4.0-preview'
            }
            { $_ -eq 'TFS2018U2' -or $_ -eq 'TFS2018U3' } {
               [VSTeamVersions]::Version = 'TFS2018'
               [VSTeamVersions]::Git = '4.1'
               [VSTeamVersions]::Core = '4.1'
               [VSTeamVersions]::Build = '4.1'
               [VSTeamVersions]::Release = '4.1-preview'
               [VSTeamVersions]::DistributedTask = '4.1-preview'
               [VSTeamVersions]::VariableGroups = '4.1-preview'
               [VSTeamVersions]::Tfvc = '4.1'
               [VSTeamVersions]::Packaging = '4.1-preview'
               [VSTeamVersions]::TaskGroups = '4.1-preview'
               [VSTeamVersions]::MemberEntitlementManagement = ''
               [VSTeamVersions]::ServiceEndpoints = '4.1-preview'
               [VSTeamVersions]::ExtensionsManagement = '4.1-preview'
               [VSTeamVersions]::Graph = ''
               [VSTeamVersions]::Policy = '4.1'
               [VSTeamVersions]::Processes = '4.1-preview'
            }
            'TFS2017' {
               [VSTeamVersions]::Version = 'TFS2017'
               [VSTeamVersions]::Git = '3.0'
               [VSTeamVersions]::Core = '3.0'
               [VSTeamVersions]::Build = '3.0'
               [VSTeamVersions]::Release = '3.0-preview'
               [VSTeamVersions]::DistributedTask = '3.0-preview'
               [VSTeamVersions]::VariableGroups = '' # Was introduced in Update 1
               [VSTeamVersions]::TaskGroups = '3.0-preview'
               [VSTeamVersions]::ServiceEndpoints = '3.0-preview'
               [VSTeamVersions]::Tfvc = '3.0'
               [VSTeamVersions]::Packaging = '3.0-preview'
               [VSTeamVersions]::MemberEntitlementManagement = ''
               [VSTeamVersions]::ExtensionsManagement = '3.0-preview'
               [VSTeamVersions]::Graph = ''
               [VSTeamVersions]::Policy = '3.0'
               [VSTeamVersions]::Processes = ''
            }
            'TFS2017U1' {
               [VSTeamVersions]::Version = 'TFS2017'
               [VSTeamVersions]::Git = '3.1'
               [VSTeamVersions]::Core = '3.1'
               [VSTeamVersions]::Build = '3.1'
               [VSTeamVersions]::Release = '3.1-preview'
               [VSTeamVersions]::DistributedTask = '3.1-preview'
               [VSTeamVersions]::VariableGroups = '3.1-preview' # Resource of DistributedTask area
               [VSTeamVersions]::TaskGroups = '3.1-preview' # Resource of DistributedTask area
               [VSTeamVersions]::ServiceEndpoints = '3.1-preview' # The serviceendpoints resource of DistributedTask area
               [VSTeamVersions]::Tfvc = '3.1'
               [VSTeamVersions]::Packaging = '3.1-preview'
               [VSTeamVersions]::MemberEntitlementManagement = '' # SubDomain vsaex
               [VSTeamVersions]::ExtensionsManagement = '3.1-preview' # Actual area is extensionmanagement
               [VSTeamVersions]::Graph = '' # SubDomain vssps
               [VSTeamVersions]::Policy = '3.1'
               [VSTeamVersions]::Processes = ''
            }
            # Update 3 of TFS 2017 did not introduce a new API Version
            { $_ -eq 'TFS2017U2' -or $_ -eq 'TFS2017U3' } {
               [VSTeamVersions]::Version = 'TFS2017'
               [VSTeamVersions]::Git = '3.2'
               [VSTeamVersions]::Core = '3.2'
               [VSTeamVersions]::Build = '3.2'
               [VSTeamVersions]::Release = '3.2-preview'
               [VSTeamVersions]::DistributedTask = '3.2-preview'
               [VSTeamVersions]::VariableGroups = '3.2-preview' # Resource of DistributedTask area
               [VSTeamVersions]::TaskGroups = '3.2-preview' # Resource of DistributedTask area
               [VSTeamVersions]::ServiceEndpoints = '3.2-preview' # The serviceendpoints resource of DistributedTask area
               [VSTeamVersions]::Tfvc = '3.2'
               [VSTeamVersions]::Packaging = '3.2-preview'
               [VSTeamVersions]::MemberEntitlementManagement = '' # SubDomain vsaex
               [VSTeamVersions]::ExtensionsManagement = '3.2-preview' # Actual area is extensionmanagement
               [VSTeamVersions]::Graph = '' # SubDomain vssps
               [VSTeamVersions]::Policy = '3.2'
               [VSTeamVersions]::Processes = ''
            }
            # AZD, VSTS
            Default {
               [VSTeamVersions]::Version = $Target
               [VSTeamVersions]::Git = '5.1'
               [VSTeamVersions]::Core = '5.1'
               [VSTeamVersions]::Build = '5.1'
               [VSTeamVersions]::Release = '5.1'
               [VSTeamVersions]::DistributedTask = '6.0-preview'
               [VSTeamVersions]::VariableGroups = '5.1-preview.1'
               [VSTeamVersions]::TaskGroups = '6.0-preview'
               [VSTeamVersions]::Tfvc = '5.1'
               [VSTeamVersions]::Packaging = '6.0-preview' # SubDoman feeds
               [VSTeamVersions]::MemberEntitlementManagement = '6.0-preview'
               # This version is never passed to the API but is used to evaluate
               # if Service Fabric is enabled for the account. Just set it to
               # match Distributed Task for AzD
               [VSTeamVersions]::ServiceEndpoints = '5.0-preview'
               [VSTeamVersions]::ExtensionsManagement = '6.0-preview' # SubDomain extmgmt
               [VSTeamVersions]::Graph = '6.0-preview' # SubDomain vssps
               [VSTeamVersions]::Policy = '5.1'
               [VSTeamVersions]::Processes = '6.0-preview'
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
   Write-Verbose "Packaging: $(_getApiVersion Packaging)"
   Write-Verbose "TaskGroups: $([VSTeamVersions]::TaskGroups)"
   Write-Verbose "MemberEntitlementManagement: $([VSTeamVersions]::MemberEntitlementManagement)"
   Write-Verbose "ServiceEndpoints: $([VSTeamVersions]::ServiceEndpoints)"
   Write-Verbose "ExtensionsManagement: $([VSTeamVersions]::ExtensionsManagement)"
   Write-Verbose "Graph: $([VSTeamVersions]::Graph)"
   Write-Verbose "Policy: $([VSTeamVersions]::Policy)"
   Write-Verbose "Processes: $([VSTeamVersions]::Processes)"
}