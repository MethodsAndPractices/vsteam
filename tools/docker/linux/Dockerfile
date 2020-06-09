# escape=`
ARG fromTag=7.0.1-ubuntu-18.04
ARG pesterMinVer=5.0.2

FROM mcr.microsoft.com/powershell:${fromTag}

SHELL ["pwsh", "-Command", "$ErrorActionPreference = 'Stop';"]

RUN pwsh `
   -NoLogo `
   -NoProfile `
   -Command " `
   `Write-host 'Installing needed PowerShell modules...'; `
   Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted; `
   Install-Module -Name 'Trackyon.Utils', 'PSScriptAnalyzer', 'Plaster', 'SHiPS' -SkipPublisherCheck -Verbose; `
   Install-Module -Name Pester -Repository PSGallery -Force -AllowPrerelease -MinimumVersion '${pesterMinVer}' -AllowClobber -SkipPublisherCheck; `
   "

CMD ["pwsh.exe"]
