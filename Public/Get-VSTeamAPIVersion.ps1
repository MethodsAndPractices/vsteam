function Get-VSTeamAPIVersion {
   [CmdletBinding()]
   param()

   return @{
      Version                     = $([VSTeamVersions]::Version)
      Build                       = $([VSTeamVersions]::Build)
      Release                     = $([VSTeamVersions]::Release)
      Core                        = $([VSTeamVersions]::Core)
      Git                         = $([VSTeamVersions]::Git)
      DistributedTask             = $([VSTeamVersions]::DistributedTask)
      Tfvc                        = $([VSTeamVersions]::Tfvc)
      Packaging                   = $([VSTeamVersions]::Packaging)
      MemberEntitlementManagement = $([VSTeamVersions]::MemberEntitlementManagement)
      ExtensionsManagement        = $([VSTeamVersions]::ExtensionsManagement)
      ServiceFabricEndpoint       = $([VSTeamVersions]::ServiceFabricEndpoint)
   }
}