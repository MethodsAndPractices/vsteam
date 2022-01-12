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
$ghLatestRelease = Invoke-WebRequest "https://api.github.com/repos/MethodsAndPractices/vsteam/releases/latest" | ConvertFrom-Json -Depth 20
[version]$latestVersion = $ghLatestRelease.tag_name -replace "v", ""
[version]$currentVersion = $([vsteam_lib.Versions]::ModuleVersion)
if ($currentVersion -lt $latestVersion) {
   Write-Host "New version available: $latestVersion"
   Write-Host "Run: Update-Module -Name VSTeam -RequiredVersion $latestVersion"
}

Write-Host "Warning: Breaking changes coming with Version 8.0.0. Support for TFS 2017 and 2018 will be dropped.`nSee: https://github.com/MethodsAndPractices/vsteam/issues/438" -ForegroundColor Yellow

# Check to see if the user stored the default project in an environment variable
if ($null -ne $env:TEAM_PROJECT) {
   # Make sure the value in the environment variable still exisits.
   if (Get-VSTeamProject | Where-Object ProjectName -eq $env:TEAM_PROJECT) {
      Set-VSTeamDefaultProject -Project $env:TEAM_PROJECT
   }
}