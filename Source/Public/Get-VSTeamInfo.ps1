function Get-VSTeamInfo {
   [CmdletBinding()]
   param ()
   return @{
      Account        = _getInstance
      Version        = $(_getApiVersion -Target)
      ModuleVersion  = [vsteam_lib.Versions]::ModuleVersion
      DefaultProject = $Global:PSDefaultParameterValues['*-vsteam*:projectName']
      DefaultTimeout = $Global:PSDefaultParameterValues['*-vsteam*:vsteamApiTimeout']
   }
}