function Get-VSTeamAPIVersion {
   [CmdletBinding(HelpUri = 'https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Get-VSTeamAPIVersion')]
   [OutputType([System.Collections.Hashtable])]
   param(
      [Parameter(Mandatory = $false, Position = 0)]
      [ValidateSet('Build', 'Release', 'Core', 'Git', 'DistributedTask',
                   'DistributedTaskReleased', 'VariableGroups', 'Tfvc',
                   'Packaging', 'MemberEntitlementManagement',
                   'ExtensionsManagement', 'ServiceEndpoints', 'Graph',
                   'TaskGroups', 'Policy', 'Processes', 'HierarchyQuery',
                   'Pipelines', 'Billing')]
      [string] $Service
   )

   if ($Service) {
      return $(_getApiVersion $Service)
   }
   else {
      # Casting to a [PSCustomObject] returns the properties in this
      # exact order. If not this is a hashtable and the order is
      # nondeterministic
      return [PSCustomObject]@{
         Billing                     = $(_getApiVersion Billing)
         Build                       = $(_getApiVersion Build)
         Core                        = $(_getApiVersion Core)
         DistributedTask             = $(_getApiVersion DistributedTask)
         DistributedTaskReleased     = $(_getApiVersion DistributedTaskReleased)
         ExtensionsManagement        = $(_getApiVersion ExtensionsManagement)
         Git                         = $(_getApiVersion Git)
         Graph                       = $(_getApiVersion Graph)
         HierarchyQuery              = $(_getApiVersion HierarchyQuery)
         MemberEntitlementManagement = $(_getApiVersion MemberEntitlementManagement)
         Packaging                   = $(_getApiVersion Packaging)
         Pipelines                   = $(_getApiVersion Pipelines)
         Policy                      = $(_getApiVersion Policy)
         Processes                   = $(_getApiVersion Processes)
         Release                     = $(_getApiVersion Release)
         ServiceEndpoints            = $(_getApiVersion ServiceEndpoints)
         TaskGroups                  = $(_getApiVersion TaskGroups)
         Tfvc                        = $(_getApiVersion Tfvc)
         VariableGroups              = $(_getApiVersion VariableGroups)
         Version                     = $(_getApiVersion -Target)
      }
   }
}