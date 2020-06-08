# Run Unit Tests Locally with Docker

When helping us to develop this module or when we want to expand the module. We always write unit tests. The problem with that is, that most of the time everybody is using his own machine with different version of OS or different versions of dependencies.

This is why we created docker files for windows and linux. Currently we have prepared to run the unit tests in

* linux - PowerShell Core 7
* windows server core - PowerShell 5
* windows server core - PowerShell Core 7

In best case you should only need to run the powershell script below. The dockerfiles being used for this have only the needed PowerShell modules installed. So theoretically you could also develop in theese containers with VSCode and remote development.

# Prerequisites

> **Note:** This feature is still in testing and was developed on a windows machine. Therefore,  the script to run all tests for you works for that OS. But it is itended to work also for linux. But this comes a bit later.

* [Docker](https://docs.docker.com/engine/install/)
   * depending on your OS you need to install Docker Desktop or only Server
* Windows based OS if you want to run Windows containers
* optional: [Install WSL](https://code.visualstudio.com/docs/remote/wsl#_installation)
   * if you even [use WSL2](https://docs.microsoft.com/en-us/windows/wsl/install-win10#update-to-wsl-2) then container switch and run with much more performance!

Also be aware that we cannot know all prerequisites as there often many different dependencies for different host OS systems.

# How to Run

1. Install Docker: https://docs.docker.com/engine/install
2. Run [Run-ContainerTests.ps1](Run-ContainerTests.ps1) located under ./tools/docker

   ```powershell
   #Example
   Run-ContainerTests.ps1
   ```

# Limitations

* Windows container only work with windows based systems.
* If you want to use the container to develop with VSCode remote development, then it currently only works with linux systems.
* The log in PowerShell 5 window is scrambled, only the Pester results at the end can be properly observed.

# Troubleshooting

* sometimes windows container do not seem to be able to connect to the internet on a windows host. This often happens when there are multiple networking adapters (Ethernet, Wi-Fi, etc.) present on the host.
Check the [github issue](https://github.com/docker/for-win/issues/2760) for mitigation.