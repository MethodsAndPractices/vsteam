class VSTeamVersions {
   static [string] $Account = $env:TEAM_ACCT
   static [string] $DefaultTimeout = $env:TEAM_TIMEOUT
   static [string] $DefaultProject = $env:TEAM_PROJECT
   static [string] $Version = $(If ($env:TEAM_VERSION) { $env:TEAM_VERSION } Else { "TFS2017" })
   static [string] $Git = '3.0'
   static [string] $Core = '3.0'
   static [string] $Build = '3.0'
   static [string] $Release = '3.0-preview'
   static [string] $DistributedTask = '3.0-preview'
   static [string] $VariableGroups = ''
   static [string] $TaskGroups = '3.0-preview'
   static [string] $Tfvc = '3.0'
   static [string] $Packaging = '3.0-preview'
   static [string] $MemberEntitlementManagement = ''
   static [string] $ExtensionsManagement = ''
   static [string] $ServiceEndpoints = '3.0-preview'
   static [string] $ModuleVersion = $null
   static [string] $Graph = ''
   static [string] $Policy = '3.0'
   static [string] $Processes = ''
}