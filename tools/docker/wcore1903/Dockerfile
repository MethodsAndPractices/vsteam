# escape=`
ARG fromTag=7.0.1-windowsservercore-1903
ARG pesterMinVer=5.0.2

FROM mcr.microsoft.com/powershell:${fromTag}

SHELL ["pwsh", "-Command", "$ErrorActionPreference = 'Stop';"]

RUN pwsh `
   -NoLogo `
   -NoProfile `
   -Command " `
   `Write-host 'Installing needed PowerShell modules...'; `
   Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted; `
   Install-Module -Name 'Trackyon.Utils', 'PSScriptAnalyzer', 'Plaster', 'SHiPS' -SkipPublisherCheck; `
   Install-Module -Name Pester -Force -AllowPrerelease -MinimumVersion "$env:pesterMinVer" -AllowClobber -SkipPublisherCheck; `
   "

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]

# install nuget in PS 5.1
# in this version nuget is not installed and registered, but is needed to install all other modules from PSGallery
# also PowerShellGet is not on the newest version e.g. Install-Module would not acccept version numbers like 5.0.2
RUN powershell `
   -NoLogo `
   -Command " `
   `Write-host 'Installing nuget and PowerShellGet...'; `
   Set-ExecutionPolicy Bypass -Scope Process -Force; `
   [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; `
   iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')); `
   choco install nuget.commandline -y; `
   Install-PackageProvider -Name NuGet -Force; `
   Install-Module -Name PowerShellGet -Force; `
   Update-Module -Name PowerShellGet; `
   "

# install all modules for PS 5.1 as well
RUN powershell `
   -NoLogo `
   -Command " `
   `Write-host 'Installing needed PowerShell modules...'; `
   Install-Module -Name 'Trackyon.Utils', 'PSScriptAnalyzer', 'Plaster', 'SHiPS' -SkipPublisherCheck; `
   Install-Module -Name Pester -Repository PSGallery -Force -AllowPrerelease -MinimumVersion "$env:pesterMinVer" -AllowClobber -SkipPublisherCheck;`
   "

CMD ["pwsh.exe"]
