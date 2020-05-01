# VSTeam

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/DarqueWarrior/vsteam/blob/master/LICENSE)
[![Documentation - VSTeam](https://img.shields.io/badge/Documentation-VSTeam-blue.svg)](https://github.com/DarqueWarrior/vsteam/blob/master/docs/readme.md)
[![PowerShell Gallery - VSTeam](https://img.shields.io/badge/PowerShell%20Gallery-VSTeam-blue.svg)](https://www.powershellgallery.com/packages/VSTeam)
[![Minimum Supported PowerShell Version](https://img.shields.io/badge/PowerShell-5.0-blue.svg)](https://github.com/PowerShell/PowerShell)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-v2.0%20adopted-ff69b4.svg)](CODE_OF_CONDUCT.md) 

## Introduction

VSTeam is a PowerShell module with commands for accessing your [Azure DevOps Server (previously named Visual Studio Team Foundation Server) 2017/2018](https://cda.ms/Bf) and [Azure DevOps (previously named Visual Studio Team Services)](https://cda.ms/Bf).

The VSTeam module is also a provider allowing users to navigate their [Azure DevOps Server](https://cda.ms/Bf) and [Azure DevOps](https://cda.ms/Bf) as a file system.

To get started you can visit this blog [PowerShell I would like you to meet TFS and VSTS](http://www.donovanbrown.com/post/PowerShell-I-would-like-you-to-meet-TFS-and-VSTS)

Documentation of the cmdlets can be found in the [docs README](https://github.com/DarqueWarrior/vsteam/blob/master/docs/readme.md) or using `Get-Help VSTeam` once the module is installed.

## Requirements

- Windows PowerShell 5.0 or newer.
- PowerShell Core.

## Installation

Install this module from the [PowerShell Gallery](https://www.powershellgallery.com/packages/VSTeam)

## Change Log

[Change Log](CHANGELOG.md)

## Pipeline Status

You can review the status of every stage of the pipeline below.

|         Stage                       |             Status           |
|-------------------------------------|------------------------------|
| Build                               | [![Build status](https://loecda.visualstudio.com/Team%20Module/_apis/build/status/CI)](https://loecda.visualstudio.com/Team%20Module/_build/latest?definitionId=52)|
| Linux Team Foundation Server 2017   | [![Environment status](https://loecda.vsrm.visualstudio.com/_apis/public/Release/badge/3e857acd-880f-4056-a46b-1de672ca55cc/1/7)](https://loecda.visualstudio.com/Team%20Module/_releases2?definitionId=1&view=mine&_a=releases) |
| macOS Team Foundation Server 2017   | [![Environment status](https://loecda.vsrm.visualstudio.com/_apis/public/Release/badge/3e857acd-880f-4056-a46b-1de672ca55cc/1/6)](https://loecda.visualstudio.com/Team%20Module/_releases2?definitionId=1&view=mine&_a=releases) |
| Windows Team Foundation Server 2017 | [![Environment status](https://loecda.vsrm.visualstudio.com/_apis/public/Release/badge/3e857acd-880f-4056-a46b-1de672ca55cc/1/2)](https://loecda.visualstudio.com/Team%20Module/_releases2?definitionId=1&view=mine&_a=releases) |
| Windows Team Foundation Server 2018 | [![Environment status](https://loecda.vsrm.visualstudio.com/_apis/public/Release/badge/3e857acd-880f-4056-a46b-1de672ca55cc/1/5)](https://loecda.visualstudio.com/Team%20Module/_releases2?definitionId=1&view=mine&_a=releases) |
| Windows Azure DevOps | [![Environment status](https://loecda.vsrm.visualstudio.com/_apis/public/Release/badge/3e857acd-880f-4056-a46b-1de672ca55cc/1/4)](https://loecda.visualstudio.com/Team%20Module/_releases2?definitionId=1&view=mine&_a=releases) |
| Publish to PowerShell Gallery       | [![Environment status](https://loecda.vsrm.visualstudio.com/_apis/public/Release/badge/3e857acd-880f-4056-a46b-1de672ca55cc/1/1)](https://loecda.visualstudio.com/Team%20Module/_releases2?definitionId=1&view=mine&_a=releases) |

The build for VSTeam is run on macOS, Linux and Windows to ensure there are no casing or other platform specific issues with the code.

![Build](.github/images/build.png)

 On each platform unit tests are run.

 ![Unit Tests](.github/images/unittests.png)

During the release the module is installed on macOS, Linux and Window and tested against [Azure DevOps Server](https://cda.ms/Bf) and [Azure DevOps](https://cda.ms/Bf) before being published to the PowerShell Gallery.

## Module Dependencies

- [SHiPS module](https://www.powershellgallery.com/packages/SHiPS/)
- [Trackyon.Utils module](https://www.powershellgallery.com/packages/Trackyon.Utils)

## Building Module

In an effort to reduce the module size this repository contains two scripts `Build-Module.ps1` and `Merge-File.ps1` that merges similar files into a single file. The files in the formats folder are merged into `vsteam.format.ps1xml`. The files in the classes folder are merged into `vsteam.classes.ps1`. The functions from the Private and Public folders are merged into `vsteam.functions.ps1`. Finally all the files in the types folder are merged into `vsteam.types.ps1xml`. The order of the files being merged can be controlled by the `_*.json` files in the repository.

The JSON files must be in the following format:

```JSON
{
   "outputFile": "vsteam.functions.ps1",
   "fileType": "functions",
   "files": [
      "./Private/*.ps1",
      "./Public/*.ps1"
   ]
}
```

### How to build locally

To run build the script Build-Module.ps1. The script has the following parameters:

* `-outputDir 'C:\outputdir'`: The final module is stored in a dist folder by default. You can override this folder by using the parameter
* `-buildHelp`: Building help is skipped by default to speed your inner loop. Use this flag to include building the help
* `-installDep`: By default the build will not install dependencies unless this switch is used
* `-ipmo`: build module will be imported into session. IF a loaded module exist, it will be overwritten with the build version.
* `-analyzeScript`: run the static code analyzer for the scripts with PSScriptAnalyzer
* `-runTests`: runs the unit tests
* `-testName 'tests to filter'`: can be used to filter the unit test parts that should be run. Wildcards can be used! See [the Pester documentation](https://github.com/pester/Pester/wiki/Invoke%E2%80%90Pester#testname-alias-name) for a more elaborate explanation.
* `-codeCoverage`: outputs the code coverage. Output by default is NUnit

Below are some examples on how to build the module locally. It is expected that your working directory is at the root of the repository.

Builds the module, installs needed dependencies, loads the module into the session and also builds the help.
```PowerShell
.\Build-Module.ps1 -installDep -ipmo -buildHelp
```

Runs all unit tests and executes the static code analysis.
```PowerShell
.\Build-Module.ps1 -runTests -codeCoverage -analyzeScript
```

Runs the tests, but executes only the unit tests that have the description "workitems" for the logical grouped unit tests. This can be used if you only want to test a portion of your unit tests.
```PowerShell
.\Build-Module.ps1 -runTests -testName workitems
```



## Contributors

[Guidelines](.github/CONTRIBUTING.md)

## Maintainers

- [Donovan Brown](https://github.com/darquewarrior) - [@DonovanBrown](https://twitter.com/DonovanBrown)
- [Sebastian Schütze](https://github.com/SebastianSchuetze) - [@RazorSPoint](https://twitter.com/RazorSPoint)

## License

This project is [licensed under the MIT License](LICENSE).    
