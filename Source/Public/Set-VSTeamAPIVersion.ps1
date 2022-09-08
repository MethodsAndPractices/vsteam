function Set-VSTeamAPIVersion {
   [CmdletBinding(DefaultParameterSetName = 'Target', SupportsShouldProcess = $true, ConfirmImpact = "Low",
      HelpUri = 'https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Set-VSTeamAPIVersion')]
   param(
      [parameter(ParameterSetName = 'Target', Mandatory = $false, Position = 0)]
      [ValidateSet('AzD2019', 'VSTS', 'AzD', 'AzD2019U1')]
      [string] $Target = 'AzD2019',

      [parameter(ParameterSetName = 'Service', Mandatory = $true, Position = 0)]
      [ValidateSet('Build', 'Release', 'Core', 'Git', 'DistributedTask',
         'DistributedTaskReleased', 'VariableGroups', 'Tfvc',
         'Packaging', 'MemberEntitlementManagement',
         'ExtensionsManagement', 'ServiceEndpoints', 'Graph',
         'TaskGroups', 'Policy', 'Processes', 'HierarchyQuery',
         'Pipelines', 'Billing', 'Wiki', 'WorkItemTracking')]
      [string] $Service,

      [parameter(ParameterSetName = 'Service', Mandatory = $true, Position = 1)]
      [string] $Version,

      [switch] $Force
   )

   if ($Force -or $pscmdlet.ShouldProcess($Target, "Set-VSTeamAPIVersion")) {
      if ($PSCmdlet.ParameterSetName -eq 'Service') {
         [vsteam_lib.Versions]::SetApiVersion($Service, $Version);
      }
      else {
         # https://docs.microsoft.com/en-us/rest/api/azure/devops/?view=azure-devops-rest-5.1#api-and-tfs-version-mapping
         switch ($Target) {
            'AzD2019' {
               [vsteam_lib.Versions]::Version = 'AzD2019'
               [vsteam_lib.Versions]::Git = '5.0'
               [vsteam_lib.Versions]::Core = '5.0'
               [vsteam_lib.Versions]::Build = '5.0'
               [vsteam_lib.Versions]::Release = '5.0'
               [vsteam_lib.Versions]::DistributedTask = '5.0-preview'
               [vsteam_lib.Versions]::DistributedTaskReleased = ''
               [vsteam_lib.Versions]::Pipelines = ''
               [vsteam_lib.Versions]::HierarchyQuery = '5.0-preview'
               [vsteam_lib.Versions]::VariableGroups = '5.0-preview'
               [vsteam_lib.Versions]::Tfvc = '5.0'
               [vsteam_lib.Versions]::Packaging = '5.0-preview'
               [vsteam_lib.Versions]::TaskGroups = '5.0-preview'
               [vsteam_lib.Versions]::MemberEntitlementManagement = ''
               [vsteam_lib.Versions]::ServiceEndpoints = '5.0-preview'
               [vsteam_lib.Versions]::ExtensionsManagement = '5.0-preview'
               [vsteam_lib.Versions]::Graph = ''
               [vsteam_lib.Versions]::Policy = '5.0'
               [vsteam_lib.Versions]::Processes = '5.0-preview'
               [vsteam_lib.Versions]::Billing = ''
               [vsteam_lib.Versions]::Wiki = '5.0'
               [vsteam_lib.Versions]::WorkItemTracking = '5.0'
            }
            'AzD2019U1' {
               [vsteam_lib.Versions]::Version = 'AzD2019'
               [vsteam_lib.Versions]::Git = '5.1'
               [vsteam_lib.Versions]::Core = '5.1'
               [vsteam_lib.Versions]::Build = '5.1'
               [vsteam_lib.Versions]::Release = '5.1'
               [vsteam_lib.Versions]::DistributedTask = '5.1-preview'
               [vsteam_lib.Versions]::DistributedTaskReleased = ''
               [vsteam_lib.Versions]::Pipelines = '5.1-preview'
               [vsteam_lib.Versions]::HierarchyQuery = '5.1-preview'
               [vsteam_lib.Versions]::VariableGroups = '5.1-preview'
               [vsteam_lib.Versions]::Tfvc = '5.1'
               [vsteam_lib.Versions]::Packaging = '5.1-preview'
               [vsteam_lib.Versions]::TaskGroups = '5.1-preview'
               [vsteam_lib.Versions]::MemberEntitlementManagement = ''
               [vsteam_lib.Versions]::ServiceEndpoints = '5.0-preview'
               [vsteam_lib.Versions]::ExtensionsManagement = '5.1-preview'
               [vsteam_lib.Versions]::Graph = ''
               [vsteam_lib.Versions]::Policy = '5.1'
               [vsteam_lib.Versions]::Processes = '5.1-preview'
               [vsteam_lib.Versions]::Billing = ''
               [vsteam_lib.Versions]::Wiki = '5.1'
               [vsteam_lib.Versions]::WorkItemTracking = '5.1-preview'
            }
            # AZD, VSTS
            Default {
               [vsteam_lib.Versions]::Version = $Target
               [vsteam_lib.Versions]::Git = '5.1'
               [vsteam_lib.Versions]::Core = '5.1'
               [vsteam_lib.Versions]::Build = '5.1'
               [vsteam_lib.Versions]::Release = '5.1'
               [vsteam_lib.Versions]::DistributedTask = '6.0-preview'
               [vsteam_lib.Versions]::DistributedTaskReleased = '5.1'
               [vsteam_lib.Versions]::Pipelines = '5.1-preview'
               [vsteam_lib.Versions]::HierarchyQuery = '5.1-preview'
               [vsteam_lib.Versions]::VariableGroups = '5.1-preview.1'
               [vsteam_lib.Versions]::TaskGroups = '6.0-preview'
               [vsteam_lib.Versions]::Tfvc = '5.1'
               [vsteam_lib.Versions]::Packaging = '6.0-preview' # SubDoman feeds
               [vsteam_lib.Versions]::MemberEntitlementManagement = '6.0-preview'
               # This version is never passed to the API but is used to evaluate
               # if Service Fabric is enabled for the account. Just set it to
               # match Distributed Task for AzD
               [vsteam_lib.Versions]::ServiceEndpoints = '5.0-preview'
               [vsteam_lib.Versions]::ExtensionsManagement = '6.0-preview' # SubDomain extmgmt
               [vsteam_lib.Versions]::Graph = '6.0-preview' # SubDomain vssps
               [vsteam_lib.Versions]::Policy = '5.1'
               [vsteam_lib.Versions]::Processes = '6.0-preview'
               [vsteam_lib.Versions]::Billing = '5.1-preview.1'
               [vsteam_lib.Versions]::Wiki = '6.0'
               [vsteam_lib.Versions]::WorkItemTracking = '6.0-preview.1'
            }
         }
      }
   }

   Write-Verbose [vsteam_lib.Versions]::Version

   # The Get-VSTeamOption comments above each version are the
   # calls you can use to see if the versions match. Once the
   # resources under an area deviates we have to introduce a
   # new version. For example the calls for Service Endpoints
   # used to use DistributedTask until they were no longer the
   # same and the ServiceEndpoints version was added.

   # Get-VSTeamOption -area 'git' -resource 'repositories'
   # Get-VSTeamOption -area 'git' -resource 'pullRequests'
   Write-Verbose "Git: $([vsteam_lib.Versions]::Git)"

   # Get-VSTeamOption -area 'core' -resource 'teams'
   # Get-VSTeamOption -area 'core' -resource 'members'
   # Get-VSTeamOption -area 'core' -resource 'projects'
   # Get-VSTeamOption -area 'wit' -resource 'queries'
   # Get-VSTeamOption -area 'wit' -resource 'workItems'
   # Get-VSTeamOption -area 'wit' -resource 'workItemTypes'
   # Get-VSTeamOption -area 'wit' -resource 'classificationNodes'
   # Get-VSTeamOption -area 'Security' -resource 'SecurityNamespaces'
   # Get-VSTeamOption -area 'Security' -resource 'AccessControlLists'
   # Get-VSTeamOption -area 'Security' -resource 'AccessControlEntries'
   Write-Verbose "Core: $([vsteam_lib.Versions]::Core)"

   # Get-VSTeamOption -area 'build' -resource 'Builds'
   # Get-VSTeamOption -area 'build' -resource 'Definitions'
   Write-Verbose "Build: $([vsteam_lib.Versions]::Build)"

   # Get-VSTeamOption -subDomain vsrm -area 'Release' -resource 'releases'
   # Get-VSTeamOption -subDomain vsrm -area 'Release' -resource 'approvals'
   # Get-VSTeamOption -subDomain vsrm -area 'Release' -resource 'definitions'
   Write-Verbose "Release: $([vsteam_lib.Versions]::Release)"

   # These are distributed task, resources that have released versions
   # Get-VSTeamOption -area 'distributedtask' -resource 'pools'
   # Get-VSTeamOption -area 'distributedtask' -resource 'agents'
   # Get-VSTeamOption -area 'distributedtask' -resource 'messages'
   # Get-VSTeamOption -area 'distributedtask' -resource 'jobrequests'
   Write-Verbose "DistributedTaskReleased: $([vsteam_lib.Versions]::DistributedTaskReleased)"

   # Testing pipelines
   #  Get-VSTeamOption -area 'pipelines' -resource 'runs'
   Write-Verbose "Pipelines: $([vsteam_lib.Versions]::Pipelines)"

   # Get-VSTeamOption -area 'Contribution' -resource 'HierarchyQuery'
   Write-Verbose "HierarchyQuery: $([vsteam_lib.Versions]::HierarchyQuery)"

   # Undocumented billing API
   Write-Verbose "Billing: $([vsteam_lib.Versions]::Billing)"

   # These are distributed task, resources that are in preview
   # Get-VSTeamOption -area 'distributedtask' -resource 'queues'
   # Get-VSTeamOption -area 'distributedtask' -resource 'serviceendpoints'
   # Get-VSTeamOption -area 'distributedtask' -resource 'azurermsubscriptions'
   Write-Verbose "DistributedTask: $([vsteam_lib.Versions]::DistributedTask)"

   # Get-VSTeamOption -area 'distributedtask' -resource 'variablegroups'
   Write-Verbose "VariableGroups: $([vsteam_lib.Versions]::VariableGroups)"

   # Get-VSTeamOption -area 'tfvc' -resource 'branches'
   Write-Verbose "Tfvc: $([vsteam_lib.Versions]::Tfvc)"

   # Get-VSTeamOption -subDomain feeds -area 'Packaging' -resource 'Feeds'
   Write-Verbose "Packaging: $([vsteam_lib.Versions]::Packaging)"

   # Get-VSTeamOption -area 'distributedtask' -resource 'taskgroups'
   Write-Verbose "TaskGroups: $([vsteam_lib.Versions]::TaskGroups)"

   # Get-VSTeamOption -subDomain vsaex -area 'MemberEntitlementManagement' -resource 'UserEntitlements'
   Write-Verbose "MemberEntitlementManagement: $([vsteam_lib.Versions]::MemberEntitlementManagement)"

   # Get-VSTeamOption -area 'distributedtask' -resource 'serviceendpoints'
   Write-Verbose "ServiceEndpoints: $([vsteam_lib.Versions]::ServiceEndpoints)"

   # Get-VSTeamOption -subDomain 'extmgmt' -area 'ExtensionManagement' -resource 'InstalledExtensions'
   # Get-VSTeamOption -subDomain 'extmgmt' -area 'ExtensionManagement' -resource 'InstalledExtensionsByName'
   Write-Verbose "ExtensionsManagement: $([vsteam_lib.Versions]::ExtensionsManagement)"

   # Get-VSTeamOption -subDomain vssps -area 'Graph' -resource 'Users'
   # Get-VSTeamOption -subDomain vssps -area 'Graph' -resource 'Groups'
   # Get-VSTeamOption -subDomain vssps -area 'Graph' -resource 'Memberships'
   # Get-VSTeamOption -subDomain vssps -area 'Graph' -resource 'Descriptors'
   Write-Verbose "Graph: $([vsteam_lib.Versions]::Graph)"

   # Get-VSTeamOption -area 'policy' -resource 'configurations'
   Write-Verbose "Policy: $([vsteam_lib.Versions]::Policy)"

   # Get-VSTeamOption -area 'processes' -resource 'processes'
   Write-Verbose "Processes: $([vsteam_lib.Versions]::Processes)"
}