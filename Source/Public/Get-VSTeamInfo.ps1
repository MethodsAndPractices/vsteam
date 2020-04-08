function Get-VSTeamInfo {
   return @{
      Account        = _getInstance
      Version        = $(_getApiVersion -Target)
      ModuleVersion  = [VSTeamVersions]::ModuleVersion
      DefaultProject = $Global:PSDefaultParameterValues['*:projectName']
   }
}