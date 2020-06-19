Set-StrictMode -Version Latest

Describe "VSTeamAlias" {
   BeforeAll {
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Public/$sut"
   }

   Context "Set-VSTeamAlias" {
      BeforeAll {
         Set-VSTeamAlias -Force
      }

      It "Should set ata for Set-VSTeamAccount" {
         $actual = Get-Alias ata

         $actual.Name | Should -Be 'ata'
         $actual.Definition | Should -Be 'Set-VSTeamAccount'
      }

      It "Should set sta for Set-VSTeamAccount" {
         $actual = Get-Alias sta

         $actual.Name | Should -Be 'sta'
         $actual.Definition | Should -Be 'Set-VSTeamAccount'
      }

      It "Should set gti for Get-VSTeamInfo" {
         $actual = Get-Alias gti

         $actual.Name | Should -Be 'gti'
         $actual.Definition | Should -Be 'Get-VSTeamInfo'
      }

      It "Should set ivr for Invoke-VSTeamRequest" {
         $actual = Get-Alias ivr

         $actual.Name | Should -Be 'ivr'
         $actual.Definition | Should -Be 'Invoke-VSTeamRequest'
      }

      It "Should set Get-ServiceEndpoint for Get-VSTeamServiceEndpoint" {
         $actual = Get-Alias Get-ServiceEndpoint

         $actual.Name | Should -Be 'Get-ServiceEndpoint'
         $actual.Definition | Should -Be 'Get-VSTeamServiceEndpoint'
      }

      It "Should set Add-AzureRMServiceEndpoint for Add-VSTeamAzureRMServiceEndpoint" {
         $actual = Get-Alias Add-AzureRMServiceEndpoint

         $actual.Name | Should -Be 'Add-AzureRMServiceEndpoint'
         $actual.Definition | Should -Be 'Add-VSTeamAzureRMServiceEndpoint'
      }

      It "Should set Remove-ServiceEndpoint for Remove-VSTeamServiceEndpoint" {
         $actual = Get-Alias Remove-ServiceEndpoint

         $actual.Name | Should -Be 'Remove-ServiceEndpoint'
         $actual.Definition | Should -Be 'Remove-VSTeamServiceEndpoint'
      }

      It "Should set Add-SonarQubeEndpoint for Add-VSTeamSonarQubeEndpoint" {
         $actual = Get-Alias Add-SonarQubeEndpoint

         $actual.Name | Should -Be 'Add-SonarQubeEndpoint'
         $actual.Definition | Should -Be 'Add-VSTeamSonarQubeEndpoint'
      }

      It "Should set Add-KubernetesEndpoint for Add-VSTeamKubernetesEndpoint" {
         $actual = Get-Alias Add-KubernetesEndpoint

         $actual.Name | Should -Be 'Add-KubernetesEndpoint'
         $actual.Definition | Should -Be 'Add-VSTeamKubernetesEndpoint'
      }

      It "Should set Add-ServiceEndpoint for Add-VSTeamServiceEndpoint" {
         $actual = Get-Alias Add-ServiceEndpoint

         $actual.Name | Should -Be 'Add-ServiceEndpoint'
         $actual.Definition | Should -Be 'Add-VSTeamServiceEndpoint'
      }

      It "Should set Update-ServiceEndpoint for Update-VSTeamServiceEndpoint" {
         $actual = Get-Alias Update-ServiceEndpoint

         $actual.Name | Should -Be 'Update-ServiceEndpoint'
         $actual.Definition | Should -Be 'Update-VSTeamServiceEndpoint'
      }

      It "Should set Add-ServiceFabricEndpoint for Add-VSTeamServiceFabricEndpoint" {
         $actual = Get-Alias Add-ServiceFabricEndpoint

         $actual.Name | Should -Be 'Add-ServiceFabricEndpoint'
         $actual.Definition | Should -Be 'Add-VSTeamServiceFabricEndpoint'
      }

      It "Should set Remove-ServiceFabricEndpoint for Remove-VSTeamServiceFabricEndpoint" {
         $actual = Get-Alias Remove-ServiceFabricEndpoint

         $actual.Name | Should -Be 'Remove-ServiceFabricEndpoint'
         $actual.Definition | Should -Be 'Remove-VSTeamServiceFabricEndpoint'
      }

      It "Should set Remove-AzureRMServiceEndpoint for Remove-VSTeamAzureRMServiceEndpoint" {
         $actual = Get-Alias Remove-AzureRMServiceEndpoint

         $actual.Name | Should -Be 'Remove-AzureRMServiceEndpoint'
         $actual.Definition | Should -Be 'Remove-VSTeamAzureRMServiceEndpoint'
      }

      It "Should set Remove-SonarQubeEndpoint for Remove-VSTeamSonarQubeEndpoint" {
         $actual = Get-Alias Remove-SonarQubeEndpoint

         $actual.Name | Should -Be 'Remove-SonarQubeEndpoint'
         $actual.Definition | Should -Be 'Remove-VSTeamSonarQubeEndpoint'
      }

      It "Should set Get-Build for Get-VSTeamBuild" {
         $actual = Get-Alias Get-Build

         $actual.Name | Should -Be 'Get-Build'
         $actual.Definition | Should -Be 'Get-VSTeamBuild'
      }

      It "Should set Show-Build for Show-VSTeamBuild" {
         $actual = Get-Alias Show-Build

         $actual.Name | Should -Be 'Show-Build'
         $actual.Definition | Should -Be 'Show-VSTeamBuild'
      }

      It "Should set Get-BuildLog for Get-VSTeamBuildLog" {
         $actual = Get-Alias Get-BuildLog

         $actual.Name | Should -Be 'Get-BuildLog'
         $actual.Definition | Should -Be 'Get-VSTeamBuildLog'
      }

      It "Should set Get-BuildTag for Get-VSTeamBuildTag" {
         $actual = Get-Alias Get-BuildTag

         $actual.Name | Should -Be 'Get-BuildTag'
         $actual.Definition | Should -Be 'Get-VSTeamBuildTag'
      }

      It "Should set Get-BuildArtifact for Get-VSTeamBuildArtifact" {
         $actual = Get-Alias Get-BuildArtifact

         $actual.Name | Should -Be 'Get-BuildArtifact'
         $actual.Definition | Should -Be 'Get-VSTeamBuildArtifact'
      }

      It "Should set Add-Build for Add-VSTeamBuild" {
         $actual = Get-Alias Add-Build

         $actual.Name | Should -Be 'Add-Build'
         $actual.Definition | Should -Be 'Add-VSTeamBuild'
      }

      It "Should set Add-BuildTag for Add-VSTeamBuildTag" {
         $actual = Get-Alias Add-BuildTag

         $actual.Name | Should -Be 'Add-BuildTag'
         $actual.Definition | Should -Be 'Add-VSTeamBuildTag'
      }

      It "Should set Remove-Build for Remove-VSTeamBuild" {
         $actual = Get-Alias Remove-Build

         $actual.Name | Should -Be 'Remove-Build'
         $actual.Definition | Should -Be 'Remove-VSTeamBuild'
      }

      It "Should set Remove-BuildTag for Remove-VSTeamBuildTag" {
         $actual = Get-Alias Remove-BuildTag

         $actual.Name | Should -Be 'Remove-BuildTag'
         $actual.Definition | Should -Be 'Remove-VSTeamBuildTag'
      }

      It "Should set Update-Build for Update-VSTeamBuild" {
         $actual = Get-Alias Update-Build

         $actual.Name | Should -Be 'Update-Build'
         $actual.Definition | Should -Be 'Update-VSTeamBuild'
      }

      It "Should set Get-BuildDefinition for Get-VSTeamBuildDefinition" {
         $actual = Get-Alias Get-BuildDefinition

         $actual.Name | Should -Be 'Get-BuildDefinition'
         $actual.Definition | Should -Be 'Get-VSTeamBuildDefinition'
      }

      It "Should set Add-BuildDefinition for Add-VSTeamBuildDefinition" {
         $actual = Get-Alias Add-BuildDefinition

         $actual.Name | Should -Be 'Add-BuildDefinition'
         $actual.Definition | Should -Be 'Add-VSTeamBuildDefinition'
      }

      It "Should set Show-BuildDefinition for Show-VSTeamBuildDefinition" {
         $actual = Get-Alias Show-BuildDefinition

         $actual.Name | Should -Be 'Show-BuildDefinition'
         $actual.Definition | Should -Be 'Show-VSTeamBuildDefinition'
      }

      It "Should set Remove-BuildDefinition for Remove-VSTeamBuildDefinition" {
         $actual = Get-Alias Remove-BuildDefinition

         $actual.Name | Should -Be 'Remove-BuildDefinition'
         $actual.Definition | Should -Be 'Remove-VSTeamBuildDefinition'
      }

      It "Should set Show-Approval for Show-VSTeamApproval" {
         $actual = Get-Alias Show-Approval

         $actual.Name | Should -Be 'Show-Approval'
         $actual.Definition | Should -Be 'Show-VSTeamApproval'
      }

      It "Should set Get-Approval for Get-VSTeamApproval" {
         $actual = Get-Alias Get-Approval

         $actual.Name | Should -Be 'Get-Approval'
         $actual.Definition | Should -Be 'Get-VSTeamApproval'
      }

      It "Should set Set-Approval for Set-VSTeamApproval" {
         $actual = Get-Alias Set-Approval

         $actual.Name | Should -Be 'Set-Approval'
         $actual.Definition | Should -Be 'Set-VSTeamApproval'
      }

      It "Should set Get-CloudSubscription for Get-VSTeamCloudSubscription" {
         $actual = Get-Alias Get-CloudSubscription

         $actual.Name | Should -Be 'Get-CloudSubscription'
         $actual.Definition | Should -Be 'Get-VSTeamCloudSubscription'
      }

      It "Should set Get-GitRepository for Get-VSTeamGitRepository" {
         $actual = Get-Alias Get-GitRepository

         $actual.Name | Should -Be 'Get-GitRepository'
         $actual.Definition | Should -Be 'Get-VSTeamGitRepository'
      }

      It "Should set Show-GitRepository for Show-VSTeamGitRepository" {
         $actual = Get-Alias Show-GitRepository

         $actual.Name | Should -Be 'Show-GitRepository'
         $actual.Definition | Should -Be 'Show-VSTeamGitRepository'
      }

      It "Should set Add-GitRepository for Add-VSTeamGitRepository" {
         $actual = Get-Alias Add-GitRepository

         $actual.Name | Should -Be 'Add-GitRepository'
         $actual.Definition | Should -Be 'Add-VSTeamGitRepository'
      }

      It "Should set Remove-GitRepository for Remove-VSTeamGitRepository" {
         $actual = Get-Alias Remove-GitRepository

         $actual.Name | Should -Be 'Remove-GitRepository'
         $actual.Definition | Should -Be 'Remove-VSTeamGitRepository'
      }

      It "Should set Get-Pool for Get-VSTeamPool" {
         $actual = Get-Alias Get-Pool

         $actual.Name | Should -Be 'Get-Pool'
         $actual.Definition | Should -Be 'Get-VSTeamPool'
      }

      It "Should set Get-Project for Get-VSTeamProject" {
         $actual = Get-Alias Get-Project

         $actual.Name | Should -Be 'Get-Project'
         $actual.Definition | Should -Be 'Get-VSTeamProject'
      }

      It "Should set Show-Project for Show-VSTeamProject" {
         $actual = Get-Alias Show-Project

         $actual.Name | Should -Be 'Show-Project'
         $actual.Definition | Should -Be 'Show-VSTeamProject'
      }

      It "Should set Update-Project for Update-VSTeamProject" {
         $actual = Get-Alias Update-Project

         $actual.Name | Should -Be 'Update-Project'
         $actual.Definition | Should -Be 'Update-VSTeamProject'
      }

      It "Should set Add-Project for Add-VSTeamProject" {
         $actual = Get-Alias Add-Project

         $actual.Name | Should -Be 'Add-Project'
         $actual.Definition | Should -Be 'Add-VSTeamProject'
      }

      It "Should set Remove-Project for Remove-VSTeamProject" {
         $actual = Get-Alias Remove-Project

         $actual.Name | Should -Be 'Remove-Project'
         $actual.Definition | Should -Be 'Remove-VSTeamProject'
      }

      It "Should set Get-Queue for Get-VSTeamQueue" {
         $actual = Get-Alias Get-Queue

         $actual.Name | Should -Be 'Get-Queue'
         $actual.Definition | Should -Be 'Get-VSTeamQueue'
      }

      It "Should set Get-ReleaseDefinition for Get-VSTeamReleaseDefinition" {
         $actual = Get-Alias Get-ReleaseDefinition

         $actual.Name | Should -Be 'Get-ReleaseDefinition'
         $actual.Definition | Should -Be 'Get-VSTeamReleaseDefinition'
      }

      It "Should set Show-ReleaseDefinition for Show-VSTeamReleaseDefinition" {
         $actual = Get-Alias Show-ReleaseDefinition

         $actual.Name | Should -Be 'Show-ReleaseDefinition'
         $actual.Definition | Should -Be 'Show-VSTeamReleaseDefinition'
      }

      It "Should set Add-ReleaseDefinition for Add-VSTeamReleaseDefinition" {
         $actual = Get-Alias Add-ReleaseDefinition

         $actual.Name | Should -Be 'Add-ReleaseDefinition'
         $actual.Definition | Should -Be 'Add-VSTeamReleaseDefinition'
      }

      It "Should set Remove-ReleaseDefinition for Remove-VSTeamReleaseDefinition" {
         $actual = Get-Alias Remove-ReleaseDefinition

         $actual.Name | Should -Be 'Remove-ReleaseDefinition'
         $actual.Definition | Should -Be 'Remove-VSTeamReleaseDefinition'
      }

      It "Should set Get-Release for Get-VSTeamRelease" {
         $actual = Get-Alias Get-Release

         $actual.Name | Should -Be 'Get-Release'
         $actual.Definition | Should -Be 'Get-VSTeamRelease'
      }

      It "Should set Show-Release for Show-VSTeamRelease" {
         $actual = Get-Alias Show-Release

         $actual.Name | Should -Be 'Show-Release'
         $actual.Definition | Should -Be 'Show-VSTeamRelease'
      }

      It "Should set Add-Release for Add-VSTeamRelease" {
         $actual = Get-Alias Add-Release

         $actual.Name | Should -Be 'Add-Release'
         $actual.Definition | Should -Be 'Add-VSTeamRelease'
      }

      It "Should set Remove-Release for Remove-VSTeamRelease" {
         $actual = Get-Alias Remove-Release

         $actual.Name | Should -Be 'Remove-Release'
         $actual.Definition | Should -Be 'Remove-VSTeamRelease'
      }

      It "Should set Set-ReleaseStatus for Set-VSTeamReleaseStatus" {
         $actual = Get-Alias Set-ReleaseStatus

         $actual.Name | Should -Be 'Set-ReleaseStatus'
         $actual.Definition | Should -Be 'Set-VSTeamReleaseStatus'
      }

      It "Should set Add-ReleaseEnvironment for Add-VSTeamReleaseEnvironment" {
         $actual = Get-Alias Add-ReleaseEnvironment

         $actual.Name | Should -Be 'Add-ReleaseEnvironment'
         $actual.Definition | Should -Be 'Add-VSTeamReleaseEnvironment'
      }

      It "Should set Get-TeamInfo for Get-VSTeamInfo" {
         $actual = Get-Alias Get-TeamInfo

         $actual.Name | Should -Be 'Get-TeamInfo'
         $actual.Definition | Should -Be 'Get-VSTeamInfo'
      }

      It "Should set Add-TeamAccount for Set-VSTeamAccount" {
         $actual = Get-Alias Add-TeamAccount

         $actual.Name | Should -Be 'Add-TeamAccount'
         $actual.Definition | Should -Be 'Set-VSTeamAccount'
      }

      It "Should set Remove-TeamAccount for Remove-VSTeamAccount" {
         $actual = Get-Alias Remove-TeamAccount

         $actual.Name | Should -Be 'Remove-TeamAccount'
         $actual.Definition | Should -Be 'Remove-VSTeamAccount'
      }

      It "Should set Get-TeamOption for Get-VSTeamOption" {
         $actual = Get-Alias Get-TeamOption

         $actual.Name | Should -Be 'Get-TeamOption'
         $actual.Definition | Should -Be 'Get-VSTeamOption'
      }

      It "Should set Get-TeamResourceArea for Get-VSTeamResourceArea" {
         $actual = Get-Alias Get-TeamResourceArea

         $actual.Name | Should -Be 'Get-TeamResourceArea'
         $actual.Definition | Should -Be 'Get-VSTeamResourceArea'
      }

      It "Should set Clear-DefaultProject for Clear-VSTeamDefaultProject" {
         $actual = Get-Alias Clear-DefaultProject

         $actual.Name | Should -Be 'Clear-DefaultProject'
         $actual.Definition | Should -Be 'Clear-VSTeamDefaultProject'
      }

      It "Should set Set-DefaultProject for Set-VSTeamDefaultProject" {
         $actual = Get-Alias Set-DefaultProject

         $actual.Name | Should -Be 'Set-DefaultProject'
         $actual.Definition | Should -Be 'Set-VSTeamDefaultProject'
      }

      It "Should set Get-TeamMember for Get-VSTeamMember" {
         $actual = Get-Alias Get-TeamMember

         $actual.Name | Should -Be 'Get-TeamMember'
         $actual.Definition | Should -Be 'Get-VSTeamMember'
      }

      It "Should set Get-Team for Get-VSTeam" {
         $actual = Get-Alias Get-Team

         $actual.Name | Should -Be 'Get-Team'
         $actual.Definition | Should -Be 'Get-VSTeam'
      }

      It "Should set Add-Team for Add-VSTeam" {
         $actual = Get-Alias Add-Team

         $actual.Name | Should -Be 'Add-Team'
         $actual.Definition | Should -Be 'Add-VSTeam'
      }

      It "Should set Update-Team for Update-VSTeam" {
         $actual = Get-Alias Update-Team

         $actual.Name | Should -Be 'Update-Team'
         $actual.Definition | Should -Be 'Update-VSTeam'
      }

      It "Should set Remove-Team for Remove-VSTeam" {
         $actual = Get-Alias Remove-Team

         $actual.Name | Should -Be 'Remove-Team'
         $actual.Definition | Should -Be 'Remove-VSTeam'
      }

      It "Should set Add-Profile for Add-VSTeamProfile" {
         $actual = Get-Alias Add-Profile

         $actual.Name | Should -Be 'Add-Profile'
         $actual.Definition | Should -Be 'Add-VSTeamProfile'
      }

      It "Should set Remove-Profile for Remove-VSTeamProfile" {
         $actual = Get-Alias Remove-Profile

         $actual.Name | Should -Be 'Remove-Profile'
         $actual.Definition | Should -Be 'Remove-VSTeamProfile'
      }

      It "Should set Get-Profile for Get-VSTeamProfile" {
         $actual = Get-Alias Get-Profile

         $actual.Name | Should -Be 'Get-Profile'
         $actual.Definition | Should -Be 'Get-VSTeamProfile'
      }

      It "Should set Set-APIVersion for Set-VSTeamAPIVersion" {
         $actual = Get-Alias Set-APIVersion

         $actual.Name | Should -Be 'Set-APIVersion'
         $actual.Definition | Should -Be 'Set-VSTeamAPIVersion'
      }

      It "Should set Add-UserEntitlement for Add-VSTeamUserEntitlement" {
         $actual = Get-Alias Add-UserEntitlement

         $actual.Name | Should -Be 'Add-UserEntitlement'
         $actual.Definition | Should -Be 'Add-VSTeamUserEntitlement'
      }

      It "Should set Remove-UserEntitlement for Remove-VSTeamUserEntitlement" {
         $actual = Get-Alias Remove-UserEntitlement

         $actual.Name | Should -Be 'Remove-UserEntitlement'
         $actual.Definition | Should -Be 'Remove-VSTeamUserEntitlement'
      }

      It "Should set Get-UserEntitlement for Get-VSTeamUserEntitlement" {
         $actual = Get-Alias Get-UserEntitlement

         $actual.Name | Should -Be 'Get-UserEntitlement'
         $actual.Definition | Should -Be 'Get-VSTeamUserEntitlement'
      }

      It "Should set Update-UserEntitlement for Update-VSTeamUserEntitlement" {
         $actual = Get-Alias Update-UserEntitlement

         $actual.Name | Should -Be 'Update-UserEntitlement'
         $actual.Definition | Should -Be 'Update-VSTeamUserEntitlement'
      }

      It "Should set Set-EnvironmentStatus for Set-VSTeamEnvironmentStatus" {
         $actual = Get-Alias Set-EnvironmentStatus

         $actual.Name | Should -Be 'Set-EnvironmentStatus'
         $actual.Definition | Should -Be 'Set-VSTeamEnvironmentStatus'
      }

      It "Should set Get-ServiceEndpointType for Get-VSTeamServiceEndpointType" {
         $actual = Get-Alias Get-ServiceEndpointType

         $actual.Name | Should -Be 'Get-ServiceEndpointType'
         $actual.Definition | Should -Be 'Get-VSTeamServiceEndpointType'
      }

      It "Should set Update-BuildDefinition for Update-VSTeamBuildDefinition" {
         $actual = Get-Alias Update-BuildDefinition

         $actual.Name | Should -Be 'Update-BuildDefinition'
         $actual.Definition | Should -Be 'Update-VSTeamBuildDefinition'
      }

      It "Should set Get-TfvcRootBranch for Get-VSTeamTfvcRootBranch" {
         $actual = Get-Alias Get-TfvcRootBranch

         $actual.Name | Should -Be 'Get-TfvcRootBranch'
         $actual.Definition | Should -Be 'Get-VSTeamTfvcRootBranch'
      }

      It "Should set Get-TfvcBranch for Get-VSTeamTfvcBranch" {
         $actual = Get-Alias Get-TfvcBranch

         $actual.Name | Should -Be 'Get-TfvcBranch'
         $actual.Definition | Should -Be 'Get-VSTeamTfvcBranch'
      }

      It "Should set Get-WorkItemType for Get-VSTeamWorkItemType" {
         $actual = Get-Alias Get-WorkItemType

         $actual.Name | Should -Be 'Get-WorkItemType'
         $actual.Definition | Should -Be 'Get-VSTeamWorkItemType'
      }

      It "Should set Add-WorkItem for Add-VSTeamWorkItem" {
         $actual = Get-Alias Add-WorkItem

         $actual.Name | Should -Be 'Add-WorkItem'
         $actual.Definition | Should -Be 'Add-VSTeamWorkItem'
      }

      It "Should set Get-WorkItem for Get-VSTeamWorkItem" {
         $actual = Get-Alias Get-WorkItem

         $actual.Name | Should -Be 'Get-WorkItem'
         $actual.Definition | Should -Be 'Get-VSTeamWorkItem'
      }

      It "Should set Remove-WorkItem for Remove-VSTeamWorkItem" {
         $actual = Get-Alias Remove-WorkItem

         $actual.Name | Should -Be 'Remove-WorkItem'
         $actual.Definition | Should -Be 'Remove-VSTeamWorkItem'
      }

      It "Should set Show-WorkItem for Show-VSTeamWorkItem" {
         $actual = Get-Alias Show-WorkItem

         $actual.Name | Should -Be 'Show-WorkItem'
         $actual.Definition | Should -Be 'Show-VSTeamWorkItem'
      }

      It "Should set Get-Policy for Get-VSTeamPolicy" {
         $actual = Get-Alias Get-Policy

         $actual.Name | Should -Be 'Get-Policy'
         $actual.Definition | Should -Be 'Get-VSTeamPolicy'
      }

      It "Should set Get-PolicyType for Get-VSTeamPolicyType" {
         $actual = Get-Alias Get-PolicyType

         $actual.Name | Should -Be 'Get-PolicyType'
         $actual.Definition | Should -Be 'Get-VSTeamPolicyType'
      }

      It "Should set Add-Policy for Add-VSTeamPolicy" {
         $actual = Get-Alias Add-Policy

         $actual.Name | Should -Be 'Add-Policy'
         $actual.Definition | Should -Be 'Add-VSTeamPolicy'
      }

      It "Should set Update-Policy for Update-VSTeamPolicy" {
         $actual = Get-Alias Update-Policy

         $actual.Name | Should -Be 'Update-Policy'
         $actual.Definition | Should -Be 'Update-VSTeamPolicy'
      }

      It "Should set Remove-Policy for Remove-VSTeamPolicy" {
         $actual = Get-Alias Remove-Policy

         $actual.Name | Should -Be 'Remove-Policy'
         $actual.Definition | Should -Be 'Remove-VSTeamPolicy'
      }

      It "Should set Get-GitRef for Get-VSTeamGitRef" {
         $actual = Get-Alias Get-GitRef

         $actual.Name | Should -Be 'Get-GitRef'
         $actual.Definition | Should -Be 'Get-VSTeamGitRef'
      }

      It "Should set Get-Agent for Get-VSTeamAgent" {
         $actual = Get-Alias Get-Agent

         $actual.Name | Should -Be 'Get-Agent'
         $actual.Definition | Should -Be 'Get-VSTeamAgent'
      }

      It "Should set Remove-Agent for Remove-VSTeamAgent" {
         $actual = Get-Alias Remove-Agent

         $actual.Name | Should -Be 'Remove-Agent'
         $actual.Definition | Should -Be 'Remove-VSTeamAgent'
      }

      It "Should set Enable-Agent for Enable-VSTeamAgent" {
         $actual = Get-Alias Enable-Agent

         $actual.Name | Should -Be 'Enable-Agent'
         $actual.Definition | Should -Be 'Enable-VSTeamAgent'
      }

      It "Should set Disable-Agent for Disable-VSTeamAgent" {
         $actual = Get-Alias Disable-Agent

         $actual.Name | Should -Be 'Disable-Agent'
         $actual.Definition | Should -Be 'Disable-VSTeamAgent'
      }

      It "Should set Update-Profile for Update-VSTeamProfile" {
         $actual = Get-Alias Update-Profile

         $actual.Name | Should -Be 'Update-Profile'
         $actual.Definition | Should -Be 'Update-VSTeamProfile'
      }

      It "Should set Get-APIVersion for Get-VSTeamAPIVersion" {
         $actual = Get-Alias Get-APIVersion

         $actual.Name | Should -Be 'Get-APIVersion'
         $actual.Definition | Should -Be 'Get-VSTeamAPIVersion'
      }

      It "Should set Add-NuGetEndpoint for Add-VSTeamNuGetEndpoint" {
         $actual = Get-Alias Add-NuGetEndpoint

         $actual.Name | Should -Be 'Add-NuGetEndpoint'
         $actual.Definition | Should -Be 'Add-VSTeamNuGetEndpoint'
      }

      It "Should set Get-Feed for Get-VSTeamFeed" {
         $actual = Get-Alias Get-Feed

         $actual.Name | Should -Be 'Get-Feed'
         $actual.Definition | Should -Be 'Get-VSTeamFeed'
      }

      It "Should set Add-Feed for Add-VSTeamFeed" {
         $actual = Get-Alias Add-Feed

         $actual.Name | Should -Be 'Add-Feed'
         $actual.Definition | Should -Be 'Add-VSTeamFeed'
      }

      It "Should set Show-Feed for Show-VSTeamFeed" {
         $actual = Get-Alias Show-Feed

         $actual.Name | Should -Be 'Show-Feed'
         $actual.Definition | Should -Be 'Show-VSTeamFeed'
      }

      It "Should set Remove-Feed for Remove-VSTeamFeed" {
         $actual = Get-Alias Remove-Feed

         $actual.Name | Should -Be 'Remove-Feed'
         $actual.Definition | Should -Be 'Remove-VSTeamFeed'
      }

      It "Should set Get-PullRequest for Get-VSTeamPullRequest" {
         $actual = Get-Alias Get-PullRequest

         $actual.Name | Should -Be 'Get-PullRequest'
         $actual.Definition | Should -Be 'Get-VSTeamPullRequest'
      }

      It "Should set Show-PullRequest for Show-VSTeamPullRequest" {
         $actual = Get-Alias Show-PullRequest

         $actual.Name | Should -Be 'Show-PullRequest'
         $actual.Definition | Should -Be 'Show-VSTeamPullRequest'
      }

      It "Should set Add-Extension for Add-VSTeamExtension" {
         $actual = Get-Alias Add-Extension

         $actual.Name | Should -Be 'Add-Extension'
         $actual.Definition | Should -Be 'Add-VSTeamExtension'
      }

      It "Should set Get-Extension for Get-VSTeamExtension" {
         $actual = Get-Alias Get-Extension

         $actual.Name | Should -Be 'Get-Extension'
         $actual.Definition | Should -Be 'Get-VSTeamExtension'
      }

      It "Should set Update-Extension for Update-VSTeamExtension" {
         $actual = Get-Alias Update-Extension

         $actual.Name | Should -Be 'Update-Extension'
         $actual.Definition | Should -Be 'Update-VSTeamExtension'
      }

      It "Should set Remove-Extension for Remove-VSTeamExtension" {
         $actual = Get-Alias Remove-Extension

         $actual.Name | Should -Be 'Remove-Extension'
         $actual.Definition | Should -Be 'Remove-VSTeamExtension'
      }

      It "Should set Update-WorkItem for Update-VSTeamWorkItem" {
         $actual = Get-Alias Update-WorkItem

         $actual.Name | Should -Be 'Update-WorkItem'
         $actual.Definition | Should -Be 'Update-VSTeamWorkItem'
      }

      It "Should set Get-JobRequest for Get-VSTeamJobRequest" {
         $actual = Get-Alias Get-JobRequest

         $actual.Name | Should -Be 'Get-JobRequest'
         $actual.Definition | Should -Be 'Get-VSTeamJobRequest'
      }

      It "Should set Update-ReleaseDefinition for Update-VSTeamReleaseDefinition" {
         $actual = Get-Alias Update-ReleaseDefinition

         $actual.Name | Should -Be 'Update-ReleaseDefinition'
         $actual.Definition | Should -Be 'Update-VSTeamReleaseDefinition'
      }

   }
}