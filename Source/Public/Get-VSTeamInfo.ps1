function Get-VSTeamInfo {
   return @{
      Account        = [VSTeamVersions]::Account
      Version        = [VSTeamVersions]::Version
      ModuleVersion  = [VSTeamVersions]::ModuleVersion
      DefaultProject = $Global:PSDefaultParameterValues['*:projectName']
   }
}