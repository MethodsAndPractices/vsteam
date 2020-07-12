function Get-VSTeamAPIVersion {
   [CmdletBinding()]
   [OutputType([System.Collections.Hashtable])]
   param(
      [Parameter(Mandatory = $false, Position = 0)]
      [ValidateSet('Build', 'Release', 'Core', 'Git', 'DistributedTask', 'VariableGroups', 'Tfvc', 'Packaging', 'MemberEntitlementManagement', 'ExtensionsManagement', 'ServiceEndpoints', 'Graph', 'TaskGroups', 'Policy', 'Processes')]
      [string] $Service
   )

   if ($Service) {
      return $(_getApiVersion $Service)
   }
   else {
      return @{
         Version                     = $(_getApiVersion -Target)
         Build                       = $(_getApiVersion Build)
         Release                     = $(_getApiVersion Release)
         Core                        = $(_getApiVersion Core)
         Git                         = $(_getApiVersion Git)
         DistributedTask             = $(_getApiVersion DistributedTask)
         VariableGroups              = $(_getApiVersion VariableGroups)
         Tfvc                        = $(_getApiVersion Tfvc)
         Packaging                   = $(_getApiVersion Packaging)
         TaskGroups                  = $(_getApiVersion TaskGroups)
         MemberEntitlementManagement = $(_getApiVersion MemberEntitlementManagement)
         ExtensionsManagement        = $(_getApiVersion ExtensionsManagement)
         ServiceEndpoints            = $(_getApiVersion ServiceEndpoints)
         Graph                       = $(_getApiVersion Graph)
         Policy                      = $(_getApiVersion Policy)
         Processes                   = $(_getApiVersion Processes)
      }
   }
}