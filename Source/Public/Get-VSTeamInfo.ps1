function Get-VSTeamInfo {
   [CmdletBinding(HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Get-VSTeamInfo')]
   param ()
   return @{
      Account        = _getInstance
      Version        = $(_getApiVersion -Target)
      ModuleVersion  = [vsteam_lib.Versions]::ModuleVersion
      DefaultProject = $Global:PSDefaultParameterValues['*-vsteam*:projectName']
      DefaultTimeout = $Global:PSDefaultParameterValues['*-vsteam*:vsteamApiTimeout']
   }
}