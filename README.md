![build status](https://loecda.visualstudio.com/_apis/public/build/definitions/3e857acd-880f-4056-a46b-1de672ca55cc/5/badge "Build status")
# Team
Home of PowerShell module for accessing TFS and VSTS

To get started you can visit this blog [PowerShell I would like you to meet TFS and VSTS](http://www.donovanbrown.com/post/PowerShell-I-would-like-you-to-meet-TFS-and-VSTS)

# Contributors
The cases of every file is very important. This module is to be used on Windows, Linux and OSx so case is important.  If the casing does not match Linux and OSx might fail.

# Release Notes
## 1.0.6
You can now tab complete your profiles.

## 1.0.5
Added support for Profiles. Now you can store different accounts and PATS as a profile using Add-VSTeamProfile. Then you can call Add-VSTeamAccount with the -Profile parameter and the PAT will be read from the profile. This prevents you having to remember the PAT to switch between accounts. Profiles also store the API version to use with the account. 

Added $VSTeamVersionTable so you can experiment with different versions of the VSTS/TFS APIs. The variable contains the following:
- 'Build'           = '3.0'
- 'Release'         = '3.0-preview'
- 'Core'            = '3.0'
- 'Git'             = '3.0'
- 'DistributedTask' = '3.0-preview'

You can update the version so try new versions of APIs. See Set-VSTeamAPIVersion.

## 1.0.4
Added support for Show-VSTeam that opens the configured TFS or VSTS in default browser.

Merge [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/26) from [Michel Perfetti](https://github.com/miiitch) which included the following:

- Remove deadlock when endpoint creation failed 
## 1.0.3
Explicit export of alias
Fixed typo in help
Fixed typo in export of function
Changed projectName dynamic parameter to return projects in any state instead of just well-formed.

## 1.0.2
Added Show-VSTeam* functions

Fixed ReleaseDefinition functions not recognized bug

## 1.0.1
Renamed from Team to VSTeam. An alias for every function with it's original name is provided. 

## 0.1.34
Added support to queue a build by ID using the Add-VSTeamBuild function. The Add-VSTeamBuild function also fully qualifies the names of build definitions when you tab complete from command line.

I added new full name extended property to build definition type.

Added support so you can update a project by ID as well as by Name.
## 0.1.33
The variable to test if you are on Mac OS changed from IsOSX to IsMacOS. Because I have Set-StrictMode -Version Latest trying to access a variable that is not set will crash.

## 0.1.32
Merge [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/16) from [Fergal](https://github.com/ObsidianPhoenix) which included the following:

- Added Support for Build Tags
- Added the ability to update KeepForever, and the Build Number
- Added the ability to pull artifact data from the build

## 0.1.31
Merge [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/17) from [Kees Verhaar](https://github.com/KeesV) which included the following:

- Add ProjectName as a property on team member so it can be used further down the pipeline

## 0.1.30
Merge [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/15) from [Kees Verhaar](https://github.com/KeesV) which included the following:

- Add support for teams

## 0.1.29
Merge [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/12) from [Andy Neillans](https://github.com/aneillans) which included the following:

- Fixed for on-premise URLS being incorrectly classed as VSTS accounts
- Fixed for projects validation if you have more than 100 projects

## 0.1.28
Added ID to approval default output

## 0.1.27
Clearing code analysis warnings

## 0.1.26
Merge [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/10) from [Roberto Peña](https://github.com/eulesv) which included the following:

- Adding a regular expression to validate VSTS account

## 0.1.25
- Moved -Expand parameter of Get-VSTeamRelease to all parameter sets.

## 0.1.24
- Added support so you can start a release from a Git commit

## 0.1.23
Merge [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/8) from [Michel Perfetti](https://github.com/miiitch) which included the following:

- Support for the [SonarQube extension](https://marketplace.visualstudio.com/items?itemName=SonarSource.sonarqube)

## 0.1.22
- Fixed bug in Set-VSTeamDefaultProject on Mac and Linux

## 0.1.21
- Added Get-VSTeamBuildLog that returns the logs of the provided build

Merge [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/6)from [Michel Perfetti](https://github.com/miiitch) which included the following:

- Added serviceEndpoint parameters to Add-VSTeamAzureRMServiceEndpoint cmdlet: if the serviceEndPoint parameters are not specified, the Automatic mode is used
- The _trackProgress function was changed too to reflect the return code of the api (https://www.visualstudio.com/en-us/docs/integrate/api/endpoints/endpoints)
- The URL in the payload changed to https://management.azure.com

## 0.1.19
Removed test folder from module

## 0.1.18
Merge [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/5) from [Christopher Mank](https://github.com/ChristopherMank) which included the following:
- Created new function in the release module named 'Add-VSTeamReleaseEnvironment'. New function deploys an environment from an existing release.

## 0.1.16
Merge [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/4) from [Andy Neillans](https://github.com/aneillans) which included the following:
- Bug fix for broken PAT code handling.

## 0.1.15
Merge [Pull Request](https://github.com/DarqueWarrior/vsteam/pull/3) from [Andy Neillans](https://github.com/aneillans) which included the following:
- Corrected typos in help files.
- Refactored location of common methods.
- Implemented using DefaultCredentials when using TFS.  This removes the need to create a PAT.

## 0.1.14
Initial Open Source release
