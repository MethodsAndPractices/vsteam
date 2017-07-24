# Team
Home of PowerShell module for accessing TFS and VSTS

To get started you can visit this blog [PowerShell I would like you to meet TFS and VSTS](http://www.donovanbrown.com/post/PowerShell-I-would-like-you-to-meet-TFS-and-VSTS)

# Contributors
The cases of every file is very important. This module is to be used on Windows, Linux and OSx so case is important.  If the casing does not match Linux and OSx might fail.

# Release Notes
## 0.1.27
Clearing code analysis warnings.

## 0.1.26
Merge [Pull Request](https://github.com/DarqueWarrior/team/pull/10) from [Roberto Peña](https://github.com/eulesv) which included the following:

- Adding a regular expression to validate VSTS account

## 0.1.25
- Moved -Expand parameter of Get-Release to all parameter sets.

## 0.1.24
- Added support so you can start a release from a Git commit

## 0.1.23
Merge [Pull Request](https://github.com/DarqueWarrior/team/pull/8) from [Michel Perfetti](https://github.com/miiitch) which included the following:

- Support for the [SonarQube extension](https://marketplace.visualstudio.com/items?itemName=SonarSource.sonarqube)

## 0.1.22
- Fixed bug in Set-DefaultProject on Mac and Linux

## 0.1.21
- Added Get-BuildLog that returns the logs of the provided build

Merge [Pull Request](https://github.com/DarqueWarrior/team/pull/6)from [Michel Perfetti](https://github.com/miiitch) which included the following:

- Added serviceEndpoint parameters to Add-AzureRMServiceEndpoint cmdlet: if the serviceEndPoint parameters are not specified, the Automatic mode is used
- The _trackProgress function was changed too to reflect the return code of the api (https://www.visualstudio.com/en-us/docs/integrate/api/endpoints/endpoints)
- The URL in the payload changed to https://management.azure.com

## 0.1.19
Removed test folder from module

## 0.1.18
Merge [Pull Request](https://github.com/DarqueWarrior/team/pull/5) from [Christopher Mank](https://github.com/ChristopherMank) which included the following:
- Created new function in the release module named 'Add-ReleaseEnvironment'. New function deploys an environment from an existing release.

## 0.1.16
Merge [Pull Request](https://github.com/DarqueWarrior/team/pull/4) from [Andy Neillans](https://github.com/aneillans) which included the following:
- Bug fix for broken PAT code handling.

## 0.1.15
Merge [Pull Request](https://github.com/DarqueWarrior/team/pull/3) from [Andy Neillans](https://github.com/aneillans) which included the following:
- Corrected typos in help files.
- Refactored location of common methods.
- Implemented using DefaultCredentials when using TFS.  This removes the need to create a PAT.

## 0.1.14
Initial Open Source release