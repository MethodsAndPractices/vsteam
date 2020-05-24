# Dot source Public & Private functions
# Files are built using a script in the root folder of the repository
. "$PSScriptRoot\vsteam.functions.ps1"

# Set the module version
[VSTeamVersions]::ModuleVersion = _getModuleVersion

# Load the correct version of the environment variable
Set-VSTeamAPIVersion -Target $([VSTeamVersions]::Version)

# Check to see if the user stored the default project in an environment variable
if ($null -ne $env:TEAM_PROJECT) {
   # Make sure the value in the environment variable still exisits.
   if (Get-VSTeamProject | Where-Object ProjectName -eq $env:TEAM_PROJECT) {
      Set-VSTeamDefaultProject -Project $env:TEAM_PROJECT
   }
}