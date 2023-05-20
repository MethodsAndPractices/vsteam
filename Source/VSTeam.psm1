# Dot sources all the files in Public, Private and Classes
# Then reads the file names in Public and exports them
# as the fucntions for the module.
# To export an alias you have to manually add it to the
# Export-ModuleMember below.
# The module manifest is using wildcard exports for functions
# and alias so you only have to name the files correctly.

# Files are built using a script in the root folder
. "$PSScriptRoot\vsteam.functions.ps1"

# Set the module version
[vsteam_lib.Versions]::ModuleVersion = _getModuleVersion

# Load the correct version of the environment variable
Set-VSTeamAPIVersion -Target $([vsteam_lib.Versions]::Version)

#compare versions and notify user
# new versions for the module are only checked if $env:VSTEAM_NO_UPDATE_MESSAGE is not set
if (($env:VSTEAM_NO_UPDATE_MESSAGE -eq $false) -or ($null -eq $env:VSTEAM_NO_UPDATE_MESSAGE)) {
   _checkForModuleUpdates -ModuleVersion ([version][vsteam_lib.Versions]::ModuleVersion) -ErrorAction Continue
}

# display custom message if set and not $true
if (($env:VSTEAM_NO_MODULE_MESSAGES -eq $false) -or ($null -eq $env:VSTEAM_NO_MODULE_MESSAGES)) {
   _showModuleLoadingMessages -ModuleVersion ([version][vsteam_lib.Versions]::ModuleVersion) -ErrorAction Continue
}

# Check to see if the user stored the default project in an environment variable
if ($null -ne $env:TEAM_PROJECT) {


   # if not account and pat is set, then do not try to set the default project
   if (($null -eq $env:TEAM_PAT -or $null -eq $env:TEAM_TOKEN) -and $null -eq $env:TEAM_ACCT) {
      Write-Warning "No PAT or Account set. You must set the environment variables (TEAM_PAT or TEAM_TOKEN) and TEAM_ACCT before loading the module to use the default project."
   }
   else {
      # set vsteam account to initialize given variables properly
      $commonArgs = @{
         Account = $env:TEAM_ACCT
         Version = $env:TEAM_VERSION
      }

      if (_useBearerToken) {
         $commonArgs.Add("UseBearerToken", $true)
         $commonArgs.Add("PersonalAccessToken", $env:TEAM_TOKEN)
      } else {
         $pat = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($env:TEAM_PAT))   #decode base64 stored pat
         $pat = $pat.Substring(1)                                                                           #remove the leading :
         $commonArgs.Add("PersonalAccessToken", $pat)
      }
      $defaultProject = $env:TEAM_PROJECT                                                                   #save temporary defalt project because it's removed during Set-VSTeamAccount call
      Set-VSTeamAccount @commonArgs
      # Make sure the value in the environment variable still exisits.
      if (Get-VSTeamProject | Where-Object ProjectName -eq $defaultProject) {
         Set-VSTeamDefaultProject -Project $defaultProject
      }
      else {
         Write-Warning "The default project '$defaultProject' stored in the environment variable TEAM_PROJECT does not exist."
      }
   }


}