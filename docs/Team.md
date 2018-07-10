---
Module Name: Team
Module Guid: 22fe5207-1749-4832-9648-e939fe074b7f
Help Version: 1.0.0.0
Locale: en-US
---

# Team Module

## Description

Provides access to your Visual Studio Team Services (VSTS) and Team Foundation Server (TFS) from Mac, Linux and PC.

## Team Cmdlets

### [Add-VSTeamAzureRMServiceEndpoint](Add-VSTeamAzureRMServiceEndpoint.md)

Adds a new Azure Resource Manager service endpoint.

### [Add-VSTeamBuild](Add-VSTeamBuild.md)

Queues a new build.

### [Add-VSTeamBuildDefinition](Add-VSTeamBuildDefinition.md)

Creates a new build defintion from a JSON file.

### [Add-VSTeamBuildTag](Add-VSTeamBuildTag.md)

Adds a tag to a build.

### [Add-VSTeamGitRepository](Add-VSTeamGitRepository.md)

Adds a Git repository to your Visual Studio Team Services or Team Foundation Server account.

### [Add-VSTeamProfile](Add-VSTeamProfile.md)

Stores your account name and personal access token as a profile for use with
the Add-TeamAccount function in this module.

### [Add-VSTeamProject](Add-VSTeamProject.md)

Adds a Team Project to your account.

### [Add-VSTeamRelease](Add-VSTeamRelease.md)

Queues a new release

### [Add-VSTeamReleaseDefinition](Add-VSTeamReleaseDefinition.md)

Creates a new release defintion from a JSON file.

### [Add-VSTeamSonarQubeEndpoint](Add-VSTeamSonarQubeEndpoint.md)

Adds a new SonarQube service endpoint.

### [Add-VSTeam](Add-VSTeam.md)

Adds a team to a team project.

### [Add-VSTeamAccount](Add-VSTeamAccount.md)

Stores your account name and personal access token for use with the other
functions in this module.

### [Add-VSTeamWorkItem](Add-VSTeamWorkItem.md)

Adds a work item to your project.

### [Clear-VSTeamDefaultProject](Clear-VSTeamDefaultProject.md)

Clears the value stored in the default project parameter value.

### [Get-VSTeamApproval](Get-VSTeamApproval.md)

Gets a list of approvals for all releases for a team project.

### [Get-VSTeamBuild](Get-VSTeamBuild.md)

Gets the builds for a team project.

### [Get-VSTeamBuildArtifact](Get-VSTeamBuildArtifact.md)

Returns the artifacts of a build.

### [Get-VSTeamBuildDefinition](Get-VSTeamBuildDefinition.md)

Gets the build definitions for a team project.

### [Get-VSTeamBuildLog](Get-VSTeamBuildLog.md)

Displays the logs for the build.

### [Get-VSTeamBuildTag](Get-VSTeamBuildTag.md)

Returns all the tags of a build.

### [Get-VSTeamCloudSubscription](Get-VSTeamCloudSubscription.md)

Gets the Azure subscriptions associated with the Team Services account.

### [Get-VSTeamGitRepository](Get-VSTeamGitRepository.md)

Get all the repositories in your Visual Studio Team Services or Team Foundation Server account, or a specific project.

### [Get-VSTeamPool](Get-VSTeamPool.md)

Returns the agent pools.

### [Get-VSTeamProfile](Get-VSTeamProfile.md)

Returns the saved profiles.

### [Get-VSTeamProject](Get-VSTeamProject.md)

Returns a list of projects in the Team Services or Team Foundation Server account.

### [Get-VSTeamQueue](Get-VSTeamQueue.md)

Gets a agent queue.

### [Get-VSTeamRelease](Get-VSTeamRelease.md)

Gets the releases for a team project.

### [Get-VSTeamReleaseDefinition](Get-VSTeamReleaseDefinition.md)

Gets the release definitions for a team project.

### [Get-VSTeamResourceArea](Get-VSTeamResourceArea.md)

List all the areas supported by this instance of TFS/VSTS.

### [Get-VSTeamServiceEndpoint](Get-VSTeamServiceEndpoint.md)

Gets a service endpoint.

### [Get-VSTeam](Get-VSTeam.md)

Returns a team.

### [Get-VSTeamInfo](Get-VSTeamInfo.md)

Displays your current account and default project.

### [Get-VSTeamMember](Get-VSTeamMember.md)

Returns a team member.

### [Get-VSTeamOption](Get-VSTeamOption.md)

Returns all the versions of supported APIs of your TFS or VSTS.

### [Get-VSTeamWorkItemType](Get-VSTeamWorkItemType.md)

Gets a list of all Work Item Types or a single work item type.

### [Remove-VSTeamBuild](Remove-VSTeamBuild.md)

Deletes the build.

### [Remove-VSTeamBuildDefinition](Remove-VSTeamBuildDefinition.md)

Removes the build definitions for a team project.

### [Remove-VSTeamBuildTag](Remove-VSTeamBuildTag.md)

Removes the tag from a build.

### [Remove-VSTeamGitRepository](Remove-VSTeamGitRepository.md)

Removes the Git repository from your Visual Studio Team Services or Team Foundation Server account.

### [Remove-VSTeamProject](Remove-VSTeamProject.md)

Deletes the Team Project from your Team Services account.

### [Remove-VSTeamRelease](Remove-VSTeamRelease.md)

Removes the releases for a team project.

### [Remove-VSTeamReleaseDefinition](Remove-VSTeamReleaseDefinition.md)

Removes the release definitions for a team project.

### [Remove-VSTeamServiceEndpoint](Remove-VSTeamServiceEndpoint.md)

Removes a service endpoint.

### [Remove-VSTeam](Remove-VSTeam.md)

Removes a team from a project.

### [Remove-VSTeamAccount](Remove-VSTeamAccount.md)

Clears your default project, account name and personal access token.

### [Set-VSTeamAPIVersion](Set-VSTeamAPIVersion.md)

Sets the API versions to support either TFS2017, TFS2018 or VSTS.

### [Set-VSTeamApproval](Set-VSTeamApproval.md)

Sets the status of approval to Approved, Rejected, Pending, or ReAssigned.

### [Set-VSTeamDefaultProject](Set-VSTeamDefaultProject.md)

Sets the default project to be used with other calls in the module.

### [Set-VSTeamEnvironmentStatus](Set-VSTeamEnvironmentStatus.md)

Sets the status of a environment to canceled, inProgress, notStarted, partiallySucceeded, queued, rejected, scheduled, succeeded or undefined.

### [Set-VSTeamReleaseStatus](Set-VSTeamReleaseStatus.md)

Sets the status of a release to Active or Abandoned.

### [Show-VSTeam](Show-VSTeam.md)

Opens TFS or VSTS site in the default browser.

### [Show-VSTeamApproval](Show-VSTeamApproval.md)

Opens the release associated with the waiting approval in the default browser.

### [Show-VSTeamBuild](Show-VSTeamBuild.md)

Opens the build summary in the default browser.

### [Show-VSTeamBuildDefinition](Show-VSTeamBuildDefinition.md)

Opens the build definition in the default browser.

### [Show-VSTeamGitRepository](Show-VSTeamGitRepository.md)

Opens the Git repository in the default browser.

### [Show-VSTeamProject](Show-VSTeamProject.md)

Opens the project in the default browser.

### [Show-VSTeamRelease](Show-VSTeamRelease.md)

Opens the release summary in the default browser.

### [Show-VSTeamReleaseDefinition](Show-VSTeamReleaseDefinition.md)

Opens the release definitions for a team project in the default browser.

### [Update-VSTeamBuild](Update-VSTeamBuild.md)

Allows you to set the keep forever flag and build number.

### [Update-VSTeamBuildDefinition](Update-VSTeamBuildDefinition.md)

Updates a build definition for a team project.

### [Update-VSTeamProject](Update-VSTeamProject.md)

Updates the project name, description or both.

### [Get-VSTeamServiceEndpointType](Get-VSTeamServiceEndpointType.md)

Get service endpoint types.