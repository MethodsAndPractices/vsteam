function Get-VSTeamInfo {
   return @{
      Account        = _getInstance
      Version        = $(_getApiVersion -Target)
      ModuleVersion  = [VSTeamVersions]::ModuleVersion
      DefaultProject = $Global:PSDefaultParameterValues['*-vsteam*:projectName']
      DefaultTimeout = $Global:PSDefaultParameterValues['*-vsteam*:vsteamApiTimeout']
   }
}