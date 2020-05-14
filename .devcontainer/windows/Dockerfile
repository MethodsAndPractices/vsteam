# escape=`
# Args used by from statements must be defined here:
ARG fromTag=1709
ARG InstallerVersion=nanoserver
ARG InstallerRepo=mcr.microsoft.com/powershell
ARG NanoServerRepo=mcr.microsoft.com/windows/nanoserver

# Use server core as an installer container to extract PowerShell,
# As this is a multi-stage build, this stage will eventually be thrown away
FROM ${InstallerRepo}:$InstallerVersion  AS installer-env

# Arguments for installing PowerShell, must be defined in the container they are used
ARG PS_VERSION=6.2.0-rc.1

ARG PS_PACKAGE_URL=https://github.com/PowerShell/PowerShell/releases/download/v$PS_VERSION/PowerShell-$PS_VERSION-win-x64.zip

SHELL ["pwsh", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ARG PS_PACKAGE_URL_BASE64

RUN Write-host "Verifying valid Version..."; `
    if (!($env:PS_VERSION -match '^\d+\.\d+\.\d+(-\w+(\.\d+)?)?$' )) { `
        throw ('PS_Version ({0}) must match the regex "^\d+\.\d+\.\d+(-\w+(\.\d+)?)?$"' -f $env:PS_VERSION) `
    } `
    $ProgressPreference = 'SilentlyContinue'; `
    if($env:PS_PACKAGE_URL_BASE64){ `
        Write-host "decoding: $env:PS_PACKAGE_URL_BASE64" ;`
        $url = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($env:PS_PACKAGE_URL_BASE64)) `
    } else { `
        Write-host "using url: $env:PS_PACKAGE_URL" ;`
        $url = $env:PS_PACKAGE_URL `
    } `
    Write-host "downloading: $url"; `
    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12; `
    New-Item -ItemType Directory /installer > $null ; `
    Invoke-WebRequest -Uri $url -outfile /installer/powershell.zip -verbose; `
    Expand-Archive /installer/powershell.zip -DestinationPath \PowerShell

# Install PowerShell into NanoServer
FROM ${NanoServerRepo}:${fromTag}

ARG VCS_REF="none"
ARG PS_VERSION=6.2.0-rc.1
ARG IMAGE_NAME=mcr.microsoft.com/powershell

LABEL maintainer="PowerShell Team <powershellteam@hotmail.com>" `
      readme.md="https://github.com/PowerShell/PowerShell/blob/master/docker/README.md" `
      description="This Dockerfile will install the latest release of PowerShell." `
      org.label-schema.usage="https://github.com/PowerShell/PowerShell/tree/master/docker#run-the-docker-image-you-built" `
      org.label-schema.url="https://github.com/PowerShell/PowerShell/blob/master/docker/README.md" `
      org.label-schema.vcs-url="https://github.com/PowerShell/PowerShell-Docker" `
      org.label-schema.name="powershell" `
      org.label-schema.vcs-ref=${VCS_REF} `
      org.label-schema.vendor="PowerShell" `
      org.label-schema.version=${PS_VERSION} `
      org.label-schema.schema-version="1.0" `
      org.label-schema.docker.cmd="docker run ${IMAGE_NAME} pwsh -c '$psversiontable'" `
      org.label-schema.docker.cmd.devel="docker run ${IMAGE_NAME}" `
      org.label-schema.docker.cmd.test="docker run ${IMAGE_NAME} pwsh -c Invoke-Pester" `
      org.label-schema.docker.cmd.help="docker run ${IMAGE_NAME} pwsh -c Get-Help"

# Copy PowerShell Core from the installer container
ENV ProgramFiles="C:\Program Files" `
    # set a fixed location for the Module analysis cache
    LOCALAPPDATA="C:\Users\ContainerAdministrator\AppData\Local" `
    PSModuleAnalysisCachePath="$LOCALAPPDATA\Microsoft\Windows\PowerShell\docker\ModuleAnalysisCache" `
    # Persist %PSCORE% ENV variable for user convenience
    PSCORE="$ProgramFiles\PowerShell\pwsh.exe" `
    # Set the default windows path so we can use it
    WindowsPATH="C:\Windows\system32;C:\Windows"

    # Set the path
ENV PATH="$WindowsPATH;${ProgramFiles}\PowerShell;"

COPY --from=installer-env ["\\PowerShell\\", "$ProgramFiles\\PowerShell"]

# intialize powershell module cache
RUN pwsh `
        -NoLogo `
        -NoProfile `
        -Command " `
          $stopTime = (get-date).AddMinutes(15); `
          $ErrorActionPreference = 'Stop' ; `
          $ProgressPreference = 'SilentlyContinue' ; `
          while(!(Test-Path -Path $env:PSModuleAnalysisCachePath)) {  `
            Write-Host "'Waiting for $env:PSModuleAnalysisCachePath'" ; `
            if((get-date) -gt $stopTime) { throw 'timout expired'} `
            Start-Sleep -Seconds 6 ; `
          }"

CMD ["pwsh.exe"]