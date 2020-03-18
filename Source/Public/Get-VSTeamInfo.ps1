function Get-VSTeamInfo {
   return @{
      Account        = _getInstance
      Version        = [VSTeamVersions]::Version
      ModuleVersion  = [VSTeamVersions]::ModuleVersion
      DefaultProject = $Global:PSDefaultParameterValues['*:projectName']
   }
}