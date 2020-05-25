# escape=`
ARG fromTag=7.0.1-windowsservercore-1903
ARG pesterMinVer=5.0.0-rc8

FROM mcr.microsoft.com/powershell:${fromTag}

SHELL ["pwsh", "-Command", "$ErrorActionPreference = 'Stop';"]

RUN pwsh `
      -NoLogo `
      -NoProfile `
      -Command " `
         $ProgressPreference = 'SilentlyContinue';`
         Write-host 'Installing needed PowerShell modules...';`
         Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted;`
         Install-Module -Name SHiPS -Repository PSGallery -SkipPublisherCheck;`
         Install-Module -Name Trackyon.Utils -Repository PSGallery;`
         Install-Module -Name Pester -Repository PSGallery -Force -AllowPrerelease -MinimumVersion "$env:pesterMinVer" -AllowClobber -SkipPublisherCheck;`
         Install-Module -Name PSSCriptAnalyzer -Repository PSGallery;`
         Install-Module -Name Plaster -Repository PSGallery; `
         "
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]

ARG pesterMinVer=5.0.0-rc8

#install nuget in PS 5.1
# in this version nuget is not installed and registered, but is needed to install all other modules from PSGallery
# also PowerShellGet is not on the newest version e.g. Install-Module would not acccept version numbers like 5.0.0.-rc8
RUN powershell `
      -NoLogo `
      -Command " `
         `$PSVersionTable;`
         Set-ExecutionPolicy Bypass -Scope Process -Force;`
         [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;`
         iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'));`
         choco install nuget.commandline -y; `
         Install-PackageProvider -Name NuGet -Force -Verbose;`
         Install-Module -Name PowerShellGet -Force -Verbose;`
         Update-Module -Name PowerShellGet -Verbose;`
         "

#install all modules for PS 5.1 as well
RUN powershell `
      -NoLogo `
      -Command " `
         Install-Module -Name SHiPS -Repository PSGallery -SkipPublisherCheck -Verbose;`
         Install-Module -Name Trackyon.Utils -Repository PSGallery -Verbose;`
         Install-Module -Name Pester -Repository PSGallery -Force -AllowPrerelease -MinimumVersion "$env:pesterMinVer" -AllowClobber -SkipPublisherCheck -Verbose;`
         Install-Module -Name PSSCriptAnalyzer -Repository PSGallery -Verbose;`
         Install-Module -Name Plaster -Repository PSGallery -Verbose; `
         "

CMD ["pwsh.exe"]


#Invoke-WebRequest https://dist.nuget.org/win-x86-commandline/latest/nuget.exe -OutFile "C:\Program Files\Nuget\Nuget.exe"
#$oldpath = (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).path
#$newpath = "$oldpath;c:\path\to\folder"
#Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH -Value $newPath
