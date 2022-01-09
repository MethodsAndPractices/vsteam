[CmdletBinding()]
param (
   # path to the module wihtout the name e.g. "C:\path\without\name" and not "C:\path\without\name\VSTeam"
   [Parameter(Mandatory = $true)]
   [string]
   $ModulePath
)

# Load the psd1 file so you can read the required modules and install them
$manifest = Import-PowerShellDataFile $ModulePath/VSTeam.psd1

# Install each module
$manifest.RequiredModules | ForEach-Object { Install-Module -Name $_ -Repository PSGallery -Force -Scope CurrentUser -Verbose }