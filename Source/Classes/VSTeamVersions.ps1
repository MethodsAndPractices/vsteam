class VSTeamVersions {
   static [string] $Account = $env:TEAM_ACCT
   static [string] $DefaultProject = $env:TEAM_PROJECT
   static [string] $Version = $(If ($env:TEAM_VERSION) {$env:TEAM_VERSION} Else {"AzD2019"})
   static [string] $Build = '5.0'
   static [string] $Release = '5.0'
   static [string] $Core = '5.0'
   static [string] $Git = '5.0'
   static [string] $DistributedTask = '5.0'
   static [string] $VariableGroups = '5.0'
   static [string] $Tfvc = '5.0'
   static [string] $Packaging = ''
   static [string] $MemberEntitlementManagement = ''
   static [string] $ExtensionsManagement = ''
   static [string] $ServiceFabricEndpoint = ''
   static [string] $ModuleVersion = $null
   static [string] $Graph = ''
}