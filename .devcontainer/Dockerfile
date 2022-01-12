FROM mcr.microsoft.com/powershell:lts-debian-11

ARG pesterMinVer=5.3.1
ARG INSTALL_ZSH="true"
ARG UPGRADE_PACKAGES="false"

# Install needed packages and setup non-root user. Use a separate RUN statement to add your own dependencies.
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID
COPY library-scripts/*.sh /tmp/library-scripts/
RUN apt-get update \
   && /bin/bash /tmp/library-scripts/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" "true" "true" \
   && chsh "${USERNAME}" -s "$(which pwsh)" \
   && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts

RUN wget https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
   && dpkg -i packages-microsoft-prod.deb \
   && apt-get update \
   && apt-get install -y dotnet-sdk-3.1 \
   && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts

RUN pwsh -NoLogo -NoProfile -Command " \
   Write-host 'Installing needed PowerShell modules...'; \
   Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted; \
   Install-Module -Name 'Trackyon.Utils', 'PSScriptAnalyzer', 'Plaster', 'SHiPS' -SkipPublisherCheck; \
   Install-Module -Name Pester -Force -AllowPrerelease -MinimumVersion "$env:pesterMinVer" -AllowClobber -SkipPublisherCheck; \
   "

# [Optional] Uncomment this section to install additional packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>
