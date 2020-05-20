# escape=`

FROM mcr.microsoft.com/powershell:7.0.1-windowsservercore-1903

SHELL ["pwsh", "-Command", "$ErrorActionPreference = 'SilentlyContinue'; $ProgressPreference = 'SilentlyContinue';"]

RUN pwsh `
      -NoLogo `
      -NoProfile `
      -Command " `
         Write-host 'Installing needed PowerShell modules...';`
         Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted;`
         Install-Module -Name SHiPS -SkipPublisherCheck;`
         Install-Module -Name Trackyon.Utils;`
         Install-Module -Name Pester;`
         Install-Module -Name PSSCriptAnalyzer;`
         Install-Module -Name Plaster; `
         "

CMD ["pwsh.exe"]


#COPY . ./vsteam