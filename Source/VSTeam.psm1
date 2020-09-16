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

# Check to see if the user stored the default project in an environment variable
if ($null -ne $env:TEAM_PROJECT) {
   # Make sure the value in the environment variable still exisits.
   if (Get-VSTeamProject | Where-Object ProjectName -eq $env:TEAM_PROJECT) {
      Set-VSTeamDefaultProject -Project $env:TEAM_PROJECT
   }
}

# Check to see if there is a newwer version of the module
$latestMod = Find-Module -Name 'VSTeam' -Repository 'PSGallery'

if($latestMod.Version -ge [vsteam_lib.Versions]::ModuleVersion) {
   Write-Information "There is a new version of VSTeam available ($($latestMod.Version)). Run 'Update-Module -Name VSTeam' to update." -InformationAction Continue
}