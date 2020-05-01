Set-StrictMode -Version Latest

#region include
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Public/$sut"
#endregion

Describe "VSTeamAlias" {
   Context "Set-VSTeamAlias" {
      Set-VSTeamAlias -Force
      
      It "Should set ata for Set-VSTeamAccount" {
         $actual = Get-Alias ata

         $actual.Name | Should be 'ata'
         $actual.Definition | Should be 'Set-VSTeamAccount'
      }

      It "Should set sta for Set-VSTeamAccount" {
         $actual = Get-Alias sta
         
         $actual.Name | Should be 'sta'
         $actual.Definition | Should be 'Set-VSTeamAccount'
      }

      It "Should set gti for Get-VSTeamInfo" {
         $actual = Get-Alias gti
         
         $actual.Name | Should be 'gti'
         $actual.Definition | Should be 'Get-VSTeamInfo'
      }

      It "Should set ivr for Invoke-VSTeamRequest" {
         $actual = Get-Alias ivr
         
         $actual.Name | Should be 'ivr'
         $actual.Definition | Should be 'Invoke-VSTeamRequest'
      }
      
      It "Should set Get-ServiceEndpoint for Get-VSTeamServiceEndpoint" {
         $actual = Get-Alias Get-ServiceEndpoint

         $actual.Name | Should be 'Get-ServiceEndpoint'
         $actual.Definition | Should be 'Get-VSTeamServiceEndpoint'
      }

      It "Should set Add-AzureRMServiceEndpoint for Add-VSTeamAzureRMServiceEndpoint" {
         $actual = Get-Alias Add-AzureRMServiceEndpoint

         $actual.Name | Should be 'Add-AzureRMServiceEndpoint'
         $actual.Definition | Should be 'Add-VSTeamAzureRMServiceEndpoint'
      }

      It "Should set Remove-ServiceEndpoint for Remove-VSTeamServiceEndpoint" {
         $actual = Get-Alias Remove-ServiceEndpoint

         $actual.Name | Should be 'Remove-ServiceEndpoint'
         $actual.Definition | Should be 'Remove-VSTeamServiceEndpoint'
      }

      It "Should set Add-SonarQubeEndpoint for Add-VSTeamSonarQubeEndpoint" {
         $actual = Get-Alias Add-SonarQubeEndpoint

         $actual.Name | Should be 'Add-SonarQubeEndpoint'
         $actual.Definition | Should be 'Add-VSTeamSonarQubeEndpoint'
      }

      It "Should set Add-KubernetesEndpoint for Add-VSTeamKubernetesEndpoint" {
         $actual = Get-Alias Add-KubernetesEndpoint

         $actual.Name | Should be 'Add-KubernetesEndpoint'
         $actual.Definition | Should be 'Add-VSTeamKubernetesEndpoint'
      }

      It "Should set Add-ServiceEndpoint for Add-VSTeamServiceEndpoint" {
         $actual = Get-Alias Add-ServiceEndpoint

         $actual.Name | Should be 'Add-ServiceEndpoint'
         $actual.Definition | Should be 'Add-VSTeamServiceEndpoint'
      }

      It "Should set Update-ServiceEndpoint for Update-VSTeamServiceEndpoint" {
         $actual = Get-Alias Update-ServiceEndpoint

         $actual.Name | Should be 'Update-ServiceEndpoint'
         $actual.Definition | Should be 'Update-VSTeamServiceEndpoint'
      }

      It "Should set Add-ServiceFabricEndpoint for Add-VSTeamServiceFabricEndpoint" {
         $actual = Get-Alias Add-ServiceFabricEndpoint

         $actual.Name | Should be 'Add-ServiceFabricEndpoint'
         $actual.Definition | Should be 'Add-VSTeamServiceFabricEndpoint'
      }

      It "Should set Remove-ServiceFabricEndpoint for Remove-VSTeamServiceFabricEndpoint" {
         $actual = Get-Alias Remove-ServiceFabricEndpoint

         $actual.Name | Should be 'Remove-ServiceFabricEndpoint'
         $actual.Definition | Should be 'Remove-VSTeamServiceFabricEndpoint'
      }

      It "Should set Remove-AzureRMServiceEndpoint for Remove-VSTeamAzureRMServiceEndpoint" {
         $actual = Get-Alias Remove-AzureRMServiceEndpoint

         $actual.Name | Should be 'Remove-AzureRMServiceEndpoint'
         $actual.Definition | Should be 'Remove-VSTeamAzureRMServiceEndpoint'
      }

      It "Should set Remove-SonarQubeEndpoint for Remove-VSTeamSonarQubeEndpoint" {
         $actual = Get-Alias Remove-SonarQubeEndpoint

         $actual.Name | Should be 'Remove-SonarQubeEndpoint'
         $actual.Definition | Should be 'Remove-VSTeamSonarQubeEndpoint'
      }

      It "Should set Get-Build for Get-VSTeamBuild" {
         $actual = Get-Alias Get-Build

         $actual.Name | Should be 'Get-Build'
         $actual.Definition | Should be 'Get-VSTeamBuild'
      }

      It "Should set Show-Build for Show-VSTeamBuild" {
         $actual = Get-Alias Show-Build

         $actual.Name | Should be 'Show-Build'
         $actual.Definition | Should be 'Show-VSTeamBuild'
      }

      It "Should set Get-BuildLog for Get-VSTeamBuildLog" {
         $actual = Get-Alias Get-BuildLog

         $actual.Name | Should be 'Get-BuildLog'
         $actual.Definition | Should be 'Get-VSTeamBuildLog'
      }

      It "Should set Get-BuildTag for Get-VSTeamBuildTag" {
         $actual = Get-Alias Get-BuildTag

         $actual.Name | Should be 'Get-BuildTag'
         $actual.Definition | Should be 'Get-VSTeamBuildTag'
      }

      It "Should set Get-BuildArtifact for Get-VSTeamBuildArtifact" {
         $actual = Get-Alias Get-BuildArtifact

         $actual.Name | Should be 'Get-BuildArtifact'
         $actual.Definition | Should be 'Get-VSTeamBuildArtifact'
      }

      It "Should set Add-Build for Add-VSTeamBuild" {
         $actual = Get-Alias Add-Build

         $actual.Name | Should be 'Add-Build'
         $actual.Definition | Should be 'Add-VSTeamBuild'
      }

      It "Should set Add-BuildTag for Add-VSTeamBuildTag" {
         $actual = Get-Alias Add-BuildTag

         $actual.Name | Should be 'Add-BuildTag'
         $actual.Definition | Should be 'Add-VSTeamBuildTag'
      }

      It "Should set Remove-Build for Remove-VSTeamBuild" {
         $actual = Get-Alias Remove-Build

         $actual.Name | Should be 'Remove-Build'
         $actual.Definition | Should be 'Remove-VSTeamBuild'
      }

      It "Should set Remove-BuildTag for Remove-VSTeamBuildTag" {
         $actual = Get-Alias Remove-BuildTag

         $actual.Name | Should be 'Remove-BuildTag'
         $actual.Definition | Should be 'Remove-VSTeamBuildTag'
      }

      It "Should set Update-Build for Update-VSTeamBuild" {
         $actual = Get-Alias Update-Build

         $actual.Name | Should be 'Update-Build'
         $actual.Definition | Should be 'Update-VSTeamBuild'
      }

      It "Should set Get-BuildDefinition for Get-VSTeamBuildDefinition" {
         $actual = Get-Alias Get-BuildDefinition

         $actual.Name | Should be 'Get-BuildDefinition'
         $actual.Definition | Should be 'Get-VSTeamBuildDefinition'
      }

      It "Should set Add-BuildDefinition for Add-VSTeamBuildDefinition" {
         $actual = Get-Alias Add-BuildDefinition

         $actual.Name | Should be 'Add-BuildDefinition'
         $actual.Definition | Should be 'Add-VSTeamBuildDefinition'
      }

      It "Should set Show-BuildDefinition for Show-VSTeamBuildDefinition" {
         $actual = Get-Alias Show-BuildDefinition

         $actual.Name | Should be 'Show-BuildDefinition'
         $actual.Definition | Should be 'Show-VSTeamBuildDefinition'
      }

      It "Should set Remove-BuildDefinition for Remove-VSTeamBuildDefinition" {
         $actual = Get-Alias Remove-BuildDefinition

         $actual.Name | Should be 'Remove-BuildDefinition'
         $actual.Definition | Should be 'Remove-VSTeamBuildDefinition'
      }

      It "Should set Show-Approval for Show-VSTeamApproval" {
         $actual = Get-Alias Show-Approval

         $actual.Name | Should be 'Show-Approval'
         $actual.Definition | Should be 'Show-VSTeamApproval'
      }

      It "Should set Get-Approval for Get-VSTeamApproval" {
         $actual = Get-Alias Get-Approval

         $actual.Name | Should be 'Get-Approval'
         $actual.Definition | Should be 'Get-VSTeamApproval'
      }

      It "Should set Set-Approval for Set-VSTeamApproval" {
         $actual = Get-Alias Set-Approval

         $actual.Name | Should be 'Set-Approval'
         $actual.Definition | Should be 'Set-VSTeamApproval'
      }

      It "Should set Get-CloudSubscription for Get-VSTeamCloudSubscription" {
         $actual = Get-Alias Get-CloudSubscription

         $actual.Name | Should be 'Get-CloudSubscription'
         $actual.Definition | Should be 'Get-VSTeamCloudSubscription'
      }

      It "Should set Get-GitRepository for Get-VSTeamGitRepository" {
         $actual = Get-Alias Get-GitRepository

         $actual.Name | Should be 'Get-GitRepository'
         $actual.Definition | Should be 'Get-VSTeamGitRepository'
      }

      It "Should set Show-GitRepository for Show-VSTeamGitRepository" {
         $actual = Get-Alias Show-GitRepository

         $actual.Name | Should be 'Show-GitRepository'
         $actual.Definition | Should be 'Show-VSTeamGitRepository'
      }

      It "Should set Add-GitRepository for Add-VSTeamGitRepository" {
         $actual = Get-Alias Add-GitRepository

         $actual.Name | Should be 'Add-GitRepository'
         $actual.Definition | Should be 'Add-VSTeamGitRepository'
      }

      It "Should set Remove-GitRepository for Remove-VSTeamGitRepository" {
         $actual = Get-Alias Remove-GitRepository

         $actual.Name | Should be 'Remove-GitRepository'
         $actual.Definition | Should be 'Remove-VSTeamGitRepository'
      }

      It "Should set Get-Pool for Get-VSTeamPool" {
         $actual = Get-Alias Get-Pool

         $actual.Name | Should be 'Get-Pool'
         $actual.Definition | Should be 'Get-VSTeamPool'
      }

      It "Should set Get-Project for Get-VSTeamProject" {
         $actual = Get-Alias Get-Project

         $actual.Name | Should be 'Get-Project'
         $actual.Definition | Should be 'Get-VSTeamProject'
      }

      It "Should set Show-Project for Show-VSTeamProject" {
         $actual = Get-Alias Show-Project

         $actual.Name | Should be 'Show-Project'
         $actual.Definition | Should be 'Show-VSTeamProject'
      }

      It "Should set Update-Project for Update-VSTeamProject" {
         $actual = Get-Alias Update-Project

         $actual.Name | Should be 'Update-Project'
         $actual.Definition | Should be 'Update-VSTeamProject'
      }

      It "Should set Add-Project for Add-VSTeamProject" {
         $actual = Get-Alias Add-Project

         $actual.Name | Should be 'Add-Project'
         $actual.Definition | Should be 'Add-VSTeamProject'
      }

      It "Should set Remove-Project for Remove-VSTeamProject" {
         $actual = Get-Alias Remove-Project

         $actual.Name | Should be 'Remove-Project'
         $actual.Definition | Should be 'Remove-VSTeamProject'
      }

      It "Should set Get-Queue for Get-VSTeamQueue" {
         $actual = Get-Alias Get-Queue

         $actual.Name | Should be 'Get-Queue'
         $actual.Definition | Should be 'Get-VSTeamQueue'
      }

      It "Should set Get-ReleaseDefinition for Get-VSTeamReleaseDefinition" {
         $actual = Get-Alias Get-ReleaseDefinition

         $actual.Name | Should be 'Get-ReleaseDefinition'
         $actual.Definition | Should be 'Get-VSTeamReleaseDefinition'
      }

      It "Should set Show-ReleaseDefinition for Show-VSTeamReleaseDefinition" {
         $actual = Get-Alias Show-ReleaseDefinition

         $actual.Name | Should be 'Show-ReleaseDefinition'
         $actual.Definition | Should be 'Show-VSTeamReleaseDefinition'
      }

      It "Should set Add-ReleaseDefinition for Add-VSTeamReleaseDefinition" {
         $actual = Get-Alias Add-ReleaseDefinition

         $actual.Name | Should be 'Add-ReleaseDefinition'
         $actual.Definition | Should be 'Add-VSTeamReleaseDefinition'
      }

      It "Should set Remove-ReleaseDefinition for Remove-VSTeamReleaseDefinition" {
         $actual = Get-Alias Remove-ReleaseDefinition

         $actual.Name | Should be 'Remove-ReleaseDefinition'
         $actual.Definition | Should be 'Remove-VSTeamReleaseDefinition'
      }

      It "Should set Get-Release for Get-VSTeamRelease" {
         $actual = Get-Alias Get-Release

         $actual.Name | Should be 'Get-Release'
         $actual.Definition | Should be 'Get-VSTeamRelease'
      }

      It "Should set Show-Release for Show-VSTeamRelease" {
         $actual = Get-Alias Show-Release

         $actual.Name | Should be 'Show-Release'
         $actual.Definition | Should be 'Show-VSTeamRelease'
      }

      It "Should set Add-Release for Add-VSTeamRelease" {
         $actual = Get-Alias Add-Release

         $actual.Name | Should be 'Add-Release'
         $actual.Definition | Should be 'Add-VSTeamRelease'
      }

      It "Should set Remove-Release for Remove-VSTeamRelease" {
         $actual = Get-Alias Remove-Release

         $actual.Name | Should be 'Remove-Release'
         $actual.Definition | Should be 'Remove-VSTeamRelease'
      }

      It "Should set Set-ReleaseStatus for Set-VSTeamReleaseStatus" {
         $actual = Get-Alias Set-ReleaseStatus

         $actual.Name | Should be 'Set-ReleaseStatus'
         $actual.Definition | Should be 'Set-VSTeamReleaseStatus'
      }

      It "Should set Add-ReleaseEnvironment for Add-VSTeamReleaseEnvironment" {
         $actual = Get-Alias Add-ReleaseEnvironment

         $actual.Name | Should be 'Add-ReleaseEnvironment'
         $actual.Definition | Should be 'Add-VSTeamReleaseEnvironment'
      }

      It "Should set Get-TeamInfo for Get-VSTeamInfo" {
         $actual = Get-Alias Get-TeamInfo

         $actual.Name | Should be 'Get-TeamInfo'
         $actual.Definition | Should be 'Get-VSTeamInfo'
      }

      It "Should set Add-TeamAccount for Set-VSTeamAccount" {
         $actual = Get-Alias Add-TeamAccount

         $actual.Name | Should be 'Add-TeamAccount'
         $actual.Definition | Should be 'Set-VSTeamAccount'
      }

      It "Should set Remove-TeamAccount for Remove-VSTeamAccount" {
         $actual = Get-Alias Remove-TeamAccount

         $actual.Name | Should be 'Remove-TeamAccount'
         $actual.Definition | Should be 'Remove-VSTeamAccount'
      }

      It "Should set Get-TeamOption for Get-VSTeamOption" {
         $actual = Get-Alias Get-TeamOption

         $actual.Name | Should be 'Get-TeamOption'
         $actual.Definition | Should be 'Get-VSTeamOption'
      }

      It "Should set Get-TeamResourceArea for Get-VSTeamResourceArea" {
         $actual = Get-Alias Get-TeamResourceArea

         $actual.Name | Should be 'Get-TeamResourceArea'
         $actual.Definition | Should be 'Get-VSTeamResourceArea'
      }

      It "Should set Clear-DefaultProject for Clear-VSTeamDefaultProject" {
         $actual = Get-Alias Clear-DefaultProject

         $actual.Name | Should be 'Clear-DefaultProject'
         $actual.Definition | Should be 'Clear-VSTeamDefaultProject'
      }

      It "Should set Set-DefaultProject for Set-VSTeamDefaultProject" {
         $actual = Get-Alias Set-DefaultProject

         $actual.Name | Should be 'Set-DefaultProject'
         $actual.Definition | Should be 'Set-VSTeamDefaultProject'
      }

      It "Should set Get-TeamMember for Get-VSTeamMember" {
         $actual = Get-Alias Get-TeamMember

         $actual.Name | Should be 'Get-TeamMember'
         $actual.Definition | Should be 'Get-VSTeamMember'
      }

      It "Should set Get-Team for Get-VSTeam" {
         $actual = Get-Alias Get-Team

         $actual.Name | Should be 'Get-Team'
         $actual.Definition | Should be 'Get-VSTeam'
      }

      It "Should set Add-Team for Add-VSTeam" {
         $actual = Get-Alias Add-Team

         $actual.Name | Should be 'Add-Team'
         $actual.Definition | Should be 'Add-VSTeam'
      }

      It "Should set Update-Team for Update-VSTeam" {
         $actual = Get-Alias Update-Team

         $actual.Name | Should be 'Update-Team'
         $actual.Definition | Should be 'Update-VSTeam'
      }

      It "Should set Remove-Team for Remove-VSTeam" {
         $actual = Get-Alias Remove-Team

         $actual.Name | Should be 'Remove-Team'
         $actual.Definition | Should be 'Remove-VSTeam'
      }

      It "Should set Add-Profile for Add-VSTeamProfile" {
         $actual = Get-Alias Add-Profile

         $actual.Name | Should be 'Add-Profile'
         $actual.Definition | Should be 'Add-VSTeamProfile'
      }

      It "Should set Remove-Profile for Remove-VSTeamProfile" {
         $actual = Get-Alias Remove-Profile

         $actual.Name | Should be 'Remove-Profile'
         $actual.Definition | Should be 'Remove-VSTeamProfile'
      }

      It "Should set Get-Profile for Get-VSTeamProfile" {
         $actual = Get-Alias Get-Profile

         $actual.Name | Should be 'Get-Profile'
         $actual.Definition | Should be 'Get-VSTeamProfile'
      }

      It "Should set Set-APIVersion for Set-VSTeamAPIVersion" {
         $actual = Get-Alias Set-APIVersion

         $actual.Name | Should be 'Set-APIVersion'
         $actual.Definition | Should be 'Set-VSTeamAPIVersion'
      }

      It "Should set Add-UserEntitlement for Add-VSTeamUserEntitlement" {
         $actual = Get-Alias Add-UserEntitlement

         $actual.Name | Should be 'Add-UserEntitlement'
         $actual.Definition | Should be 'Add-VSTeamUserEntitlement'
      }

      It "Should set Remove-UserEntitlement for Remove-VSTeamUserEntitlement" {
         $actual = Get-Alias Remove-UserEntitlement

         $actual.Name | Should be 'Remove-UserEntitlement'
         $actual.Definition | Should be 'Remove-VSTeamUserEntitlement'
      }

      It "Should set Get-UserEntitlement for Get-VSTeamUserEntitlement" {
         $actual = Get-Alias Get-UserEntitlement

         $actual.Name | Should be 'Get-UserEntitlement'
         $actual.Definition | Should be 'Get-VSTeamUserEntitlement'
      }

      It "Should set Update-UserEntitlement for Update-VSTeamUserEntitlement" {
         $actual = Get-Alias Update-UserEntitlement

         $actual.Name | Should be 'Update-UserEntitlement'
         $actual.Definition | Should be 'Update-VSTeamUserEntitlement'
      }

      It "Should set Set-EnvironmentStatus for Set-VSTeamEnvironmentStatus" {
         $actual = Get-Alias Set-EnvironmentStatus

         $actual.Name | Should be 'Set-EnvironmentStatus'
         $actual.Definition | Should be 'Set-VSTeamEnvironmentStatus'
      }

      It "Should set Get-ServiceEndpointType for Get-VSTeamServiceEndpointType" {
         $actual = Get-Alias Get-ServiceEndpointType

         $actual.Name | Should be 'Get-ServiceEndpointType'
         $actual.Definition | Should be 'Get-VSTeamServiceEndpointType'
      }

      It "Should set Update-BuildDefinition for Update-VSTeamBuildDefinition" {
         $actual = Get-Alias Update-BuildDefinition

         $actual.Name | Should be 'Update-BuildDefinition'
         $actual.Definition | Should be 'Update-VSTeamBuildDefinition'
      }

      It "Should set Get-TfvcRootBranch for Get-VSTeamTfvcRootBranch" {
         $actual = Get-Alias Get-TfvcRootBranch

         $actual.Name | Should be 'Get-TfvcRootBranch'
         $actual.Definition | Should be 'Get-VSTeamTfvcRootBranch'
      }

      It "Should set Get-TfvcBranch for Get-VSTeamTfvcBranch" {
         $actual = Get-Alias Get-TfvcBranch

         $actual.Name | Should be 'Get-TfvcBranch'
         $actual.Definition | Should be 'Get-VSTeamTfvcBranch'
      }

      It "Should set Get-WorkItemType for Get-VSTeamWorkItemType" {
         $actual = Get-Alias Get-WorkItemType

         $actual.Name | Should be 'Get-WorkItemType'
         $actual.Definition | Should be 'Get-VSTeamWorkItemType'
      }

      It "Should set Add-WorkItem for Add-VSTeamWorkItem" {
         $actual = Get-Alias Add-WorkItem

         $actual.Name | Should be 'Add-WorkItem'
         $actual.Definition | Should be 'Add-VSTeamWorkItem'
      }

      It "Should set Get-WorkItem for Get-VSTeamWorkItem" {
         $actual = Get-Alias Get-WorkItem

         $actual.Name | Should be 'Get-WorkItem'
         $actual.Definition | Should be 'Get-VSTeamWorkItem'
      }

      It "Should set Remove-WorkItem for Remove-VSTeamWorkItem" {
         $actual = Get-Alias Remove-WorkItem

         $actual.Name | Should be 'Remove-WorkItem'
         $actual.Definition | Should be 'Remove-VSTeamWorkItem'
      }

      It "Should set Show-WorkItem for Show-VSTeamWorkItem" {
         $actual = Get-Alias Show-WorkItem

         $actual.Name | Should be 'Show-WorkItem'
         $actual.Definition | Should be 'Show-VSTeamWorkItem'
      }

      It "Should set Get-Policy for Get-VSTeamPolicy" {
         $actual = Get-Alias Get-Policy

         $actual.Name | Should be 'Get-Policy'
         $actual.Definition | Should be 'Get-VSTeamPolicy'
      }

      It "Should set Get-PolicyType for Get-VSTeamPolicyType" {
         $actual = Get-Alias Get-PolicyType

         $actual.Name | Should be 'Get-PolicyType'
         $actual.Definition | Should be 'Get-VSTeamPolicyType'
      }

      It "Should set Add-Policy for Add-VSTeamPolicy" {
         $actual = Get-Alias Add-Policy

         $actual.Name | Should be 'Add-Policy'
         $actual.Definition | Should be 'Add-VSTeamPolicy'
      }

      It "Should set Update-Policy for Update-VSTeamPolicy" {
         $actual = Get-Alias Update-Policy

         $actual.Name | Should be 'Update-Policy'
         $actual.Definition | Should be 'Update-VSTeamPolicy'
      }

      It "Should set Remove-Policy for Remove-VSTeamPolicy" {
         $actual = Get-Alias Remove-Policy

         $actual.Name | Should be 'Remove-Policy'
         $actual.Definition | Should be 'Remove-VSTeamPolicy'
      }

      It "Should set Get-GitRef for Get-VSTeamGitRef" {
         $actual = Get-Alias Get-GitRef

         $actual.Name | Should be 'Get-GitRef'
         $actual.Definition | Should be 'Get-VSTeamGitRef'
      }

      It "Should set Get-Agent for Get-VSTeamAgent" {
         $actual = Get-Alias Get-Agent

         $actual.Name | Should be 'Get-Agent'
         $actual.Definition | Should be 'Get-VSTeamAgent'
      }

      It "Should set Remove-Agent for Remove-VSTeamAgent" {
         $actual = Get-Alias Remove-Agent

         $actual.Name | Should be 'Remove-Agent'
         $actual.Definition | Should be 'Remove-VSTeamAgent'
      }

      It "Should set Enable-Agent for Enable-VSTeamAgent" {
         $actual = Get-Alias Enable-Agent

         $actual.Name | Should be 'Enable-Agent'
         $actual.Definition | Should be 'Enable-VSTeamAgent'
      }

      It "Should set Disable-Agent for Disable-VSTeamAgent" {
         $actual = Get-Alias Disable-Agent

         $actual.Name | Should be 'Disable-Agent'
         $actual.Definition | Should be 'Disable-VSTeamAgent'
      }

      It "Should set Update-Profile for Update-VSTeamProfile" {
         $actual = Get-Alias Update-Profile

         $actual.Name | Should be 'Update-Profile'
         $actual.Definition | Should be 'Update-VSTeamProfile'
      }

      It "Should set Get-APIVersion for Get-VSTeamAPIVersion" {
         $actual = Get-Alias Get-APIVersion

         $actual.Name | Should be 'Get-APIVersion'
         $actual.Definition | Should be 'Get-VSTeamAPIVersion'
      }

      It "Should set Add-NuGetEndpoint for Add-VSTeamNuGetEndpoint" {
         $actual = Get-Alias Add-NuGetEndpoint

         $actual.Name | Should be 'Add-NuGetEndpoint'
         $actual.Definition | Should be 'Add-VSTeamNuGetEndpoint'
      }

      It "Should set Get-Feed for Get-VSTeamFeed" {
         $actual = Get-Alias Get-Feed

         $actual.Name | Should be 'Get-Feed'
         $actual.Definition | Should be 'Get-VSTeamFeed'
      }

      It "Should set Add-Feed for Add-VSTeamFeed" {
         $actual = Get-Alias Add-Feed

         $actual.Name | Should be 'Add-Feed'
         $actual.Definition | Should be 'Add-VSTeamFeed'
      }

      It "Should set Show-Feed for Show-VSTeamFeed" {
         $actual = Get-Alias Show-Feed

         $actual.Name | Should be 'Show-Feed'
         $actual.Definition | Should be 'Show-VSTeamFeed'
      }

      It "Should set Remove-Feed for Remove-VSTeamFeed" {
         $actual = Get-Alias Remove-Feed

         $actual.Name | Should be 'Remove-Feed'
         $actual.Definition | Should be 'Remove-VSTeamFeed'
      }

      It "Should set Get-PullRequest for Get-VSTeamPullRequest" {
         $actual = Get-Alias Get-PullRequest

         $actual.Name | Should be 'Get-PullRequest'
         $actual.Definition | Should be 'Get-VSTeamPullRequest'
      }

      It "Should set Show-PullRequest for Show-VSTeamPullRequest" {
         $actual = Get-Alias Show-PullRequest

         $actual.Name | Should be 'Show-PullRequest'
         $actual.Definition | Should be 'Show-VSTeamPullRequest'
      }

      It "Should set Add-Extension for Add-VSTeamExtension" {
         $actual = Get-Alias Add-Extension

         $actual.Name | Should be 'Add-Extension'
         $actual.Definition | Should be 'Add-VSTeamExtension'
      }

      It "Should set Get-Extension for Get-VSTeamExtension" {
         $actual = Get-Alias Get-Extension

         $actual.Name | Should be 'Get-Extension'
         $actual.Definition | Should be 'Get-VSTeamExtension'
      }

      It "Should set Update-Extension for Update-VSTeamExtension" {
         $actual = Get-Alias Update-Extension

         $actual.Name | Should be 'Update-Extension'
         $actual.Definition | Should be 'Update-VSTeamExtension'
      }

      It "Should set Remove-Extension for Remove-VSTeamExtension" {
         $actual = Get-Alias Remove-Extension

         $actual.Name | Should be 'Remove-Extension'
         $actual.Definition | Should be 'Remove-VSTeamExtension'
      }

      It "Should set Update-WorkItem for Update-VSTeamWorkItem" {
         $actual = Get-Alias Update-WorkItem

         $actual.Name | Should be 'Update-WorkItem'
         $actual.Definition | Should be 'Update-VSTeamWorkItem'
      }

      It "Should set Get-JobRequest for Get-VSTeamJobRequest" {
         $actual = Get-Alias Get-JobRequest

         $actual.Name | Should be 'Get-JobRequest'
         $actual.Definition | Should be 'Get-VSTeamJobRequest'
      }

      It "Should set Update-ReleaseDefinition for Update-VSTeamReleaseDefinition" {
         $actual = Get-Alias Update-ReleaseDefinition

         $actual.Name | Should be 'Update-ReleaseDefinition'
         $actual.Definition | Should be 'Update-VSTeamReleaseDefinition'
      }

   }
}