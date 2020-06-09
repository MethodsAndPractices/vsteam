# Run Unit Tests Locally with Docker

When helping us to develop this module or when we want to expand the module. We always write unit tests. The problem with that is, that most of the time everybody is using their own machine with different version of OS or different versions of dependencies.

This is why we created docker files for windows and linux. Currently we have prepared to run the unit tests in

* Linux - PowerShell Core 7
* Windows server core - PowerShell 5
* Windows server core - PowerShell Core 7

In best case you should only need to run the PowerShell script below. The docker files being used for this have only the needed PowerShell modules installed. So theoretically you could also develop in these containers with [Visual Studio Code](https://code.visualstudio.com/?wt.mc_id=DX_841432&WT.mc_id=github-github-dbrown) and [remote development](https://code.visualstudio.com/docs/remote/remote-overview?WT.mc_id=github-github-dbrown).

## Prerequisites

> **Note:** This feature is still in testing and was developed on a windows machine. Therefore,  the script to run all tests for you works for that OS. But it is intended to work also for linux. But this comes a bit later.

* [Docker](https://docs.docker.com/engine/install/)
  * depending on your OS you need to install Docker Desktop or only Server
* Windows based OS if you want to run Windows containers
* optional: [Install WSL](https://code.visualstudio.com/docs/remote/wsl#_installation?WT.mc_id=github-github-dbrown#update-to-wsl-2)
  * if you even [use WSL2](https://docs.microsoft.com/windows/wsl/install-win10?WT.mc_id=github-github-dbrown#update-to-wsl-2) then container switch and run with much more performance!

Also be aware that we cannot know all prerequisites as there often many different dependencies for different host OS systems.

## How to Run

1. Install Docker: [https://docs.docker.com/engine/install](https://docs.docker.com/engine/install)
2. Run [Run-ContainerTests.ps1](Run-ContainerTests.ps1) located under ./tools/docker

   ```PowerShell
   #Example
   Run-ContainerTests.ps1
   ```

## Limitations

* Windows container only work with windows based systems.
* If you want to use the container to develop with [Visual Studio Code](https://code.visualstudio.com/?wt.mc_id=DX_841432&WT.mc_id=github-github-dbrown) [remote development](https://code.visualstudio.com/docs/remote/remote-overview?WT.mc_id=github-github-dbrown), then it currently only works with linux systems.
* The log in PowerShell 5 window is scrambled, only the Pester results at the end can be properly observed.
