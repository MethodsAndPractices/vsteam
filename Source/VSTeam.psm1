# Dot sources all the files in Public, Private and Classes
# Then reads the file names in Public and exports them
# as the fucntions for the module.
# To export an alias you have to manually add it to the
# Export-ModuleMember below.
# The module manifest is using wildcard exports for functions
# and alias so you only have to name the files correctly.

# Classes.ps1 is built using a script in the root folder
. "$PSScriptRoot\Classes\classes.ps1"

$functionFolders = @('Private', 'Public')
ForEach ($folder in $functionFolders) {
   $folderPath = Join-Path -Path $PSScriptRoot -ChildPath $folder
   If (Test-Path -Path $folderPath) {
      Write-Verbose -Message "Importing from $folder"
      $functions = Get-ChildItem -Path $folderPath -Filter '*.ps1'
      ForEach ($function in $functions) {
         Write-Verbose -Message "  Importing $($function.BaseName)"
         . $($function.FullName)
      }
   }
}

$publicFunctions = (Get-ChildItem -Path "$PSScriptRoot\Public" -Filter '*.ps1').BaseName
Export-ModuleMember -Function $publicFunctions

# Check to see if the user stored the default project in an environment variable
if ($null -ne $env:TEAM_PROJECT) {
   # Make sure the value in the environment variable still exisits.
   if (Get-VSTeamProject | Where-Object ProjectName -eq $env:TEAM_PROJECT) {
      Set-VSTeamDefaultProject -Project $env:TEAM_PROJECT
   }
}

# Set the module version
[VSTeamVersions]::ModuleVersion = _getModuleVersion

# Load the correct version of the environment variable
Set-VSTeamAPIVersion -Target $([VSTeamVersions]::Version)