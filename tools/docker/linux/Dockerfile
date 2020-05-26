# escape=`
ARG fromTag=7.0.1-ubuntu-18.04
ARG pesterMinVer=5.0.0-rc8

FROM mcr.microsoft.com/powershell:${fromTag}

SHELL ["pwsh", "-Command", "$ErrorActionPreference = 'Stop';"]

RUN pwsh `
      -NoLogo `
      -NoProfile `
      -Command " `
         `$ProgressPreference = 'SilentlyContinue';`
         Write-host 'Installing needed PowerShell modules...';`
         Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted;`
         Install-Module -Name SHiPS -Repository PSGallery -SkipPublisherCheck;`
         Install-Module -Name Trackyon.Utils -Repository PSGallery;`
         Install-Module -Name Pester -Repository PSGallery -Force -AllowPrerelease -MinimumVersion '${pesterMinVer}' -AllowClobber -SkipPublisherCheck;`
         Install-Module -Name PSSCriptAnalyzer -Repository PSGallery;`
         Install-Module -Name Plaster -Repository PSGallery; `
         "

CMD ["pwsh.exe"]
