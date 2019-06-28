class VSTeamVersions {
   static [string] $Account = $env:TEAM_ACCT
   static [string] $DefaultProject = $env:TEAM_PROJECT
   static [string] $Version = $(If ($env:TEAM_VERSION) {$env:TEAM_VERSION} Else {"TFS2017"})
   static [string] $Build = '3.0'
   static [string] $Release = '3.0-preview'
   static [string] $Core = '3.0'
   static [string] $Git = '3.0'
   static [string] $DistributedTask = '3.0-preview'
   static [string] $VariableGroups = '3.2-preview.1'
   static [string] $Tfvc = '3.0'
   static [string] $Packaging = ''
   static [string] $MemberEntitlementManagement = ''
   static [string] $ExtensionsManagement = ''
   static [string] $ServiceFabricEndpoint = ''
   static [string] $ModuleVersion = $null
   static [string] $Graph = ''
}