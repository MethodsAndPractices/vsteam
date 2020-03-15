# Apply types to the returned objects so format and type files can
# identify the object and act on it.
function _applyTypes {
   param(
      $item,
      $type
   )

   $item.PSObject.TypeNames.Insert(0, $type)
}

function _applyTypesWorkItemType {
   param($item)

   $item.PSObject.TypeNames.Insert(0, 'Team.WorkItemType')
}

function _applyTypesToWorkItem {
   param($item)

   # If there are ids in the list that don't map to a work item and empty
   # entry is returned in its place if ErrorPolicy is Omit.
   if ($item) {
      $item.PSObject.TypeNames.Insert(0, 'Team.WorkItem')
   }
}

function _applyTypesToWiql {
   param($item)
   if ($item) {
      $item.PSObject.TypeNames.Insert(0, 'Team.Wiql')
   }
}

function _applyTypesToUser {
   param(
      [Parameter(Mandatory = $true)]
      $item
   )

   $item.PSObject.TypeNames.Insert(0, 'Team.UserEntitlement')
   $item.accessLevel.PSObject.TypeNames.Insert(0, 'Team.AccessLevel')
}

function _applyTypesToTfvcBranch {
   param($item)

   $item.PSObject.TypeNames.Insert(0, 'Team.TfvcBranch')
}

function _applyTypesToTeamMember {
   param(
      [Parameter(Mandatory = $true)]
      $item,
      [Parameter(Mandatory = $true)]
      $team,
      [Parameter(Mandatory = $true)]
      $ProjectName
   )

   # Add the team name as a NoteProperty so we can use it further down the pipeline (it's not returned from the REST call)
   $item | Add-Member -MemberType NoteProperty -Name Team -Value $team
   $item | Add-Member -MemberType NoteProperty -Name ProjectName -Value $ProjectName
   $item.PSObject.TypeNames.Insert(0, 'Team.TeamMember')
}

function _applyTypesToApproval {
   param($item)

   $item.PSObject.TypeNames.Insert(0, 'Team.Approval')
}

function _applyTypesToBuild {
   param($item)

   $item.PSObject.TypeNames.Insert(0, 'Team.Build')
   $item.logs.PSObject.TypeNames.Insert(0, 'Team.Logs')
   $item._links.PSObject.TypeNames.Insert(0, 'Team.Links')
   $item.project.PSObject.TypeNames.Insert(0, 'Team.Project')
   $item.requestedBy.PSObject.TypeNames.Insert(0, 'Team.User')
   $item.requestedFor.PSObject.TypeNames.Insert(0, 'Team.User')
   $item.lastChangedBy.PSObject.TypeNames.Insert(0, 'Team.User')
   $item.repository.PSObject.TypeNames.Insert(0, 'Team.Repository')
   $item.definition.PSObject.TypeNames.Insert(0, 'Team.BuildDefinition')

   if ($item.PSObject.Properties.Match('queue').count -gt 0 -and $null -ne $item.queue) {
      $item.queue.PSObject.TypeNames.Insert(0, 'Team.Queue')
   }

   if ($item.PSObject.Properties.Match('orchestrationPlan').count -gt 0 -and $null -ne $item.orchestrationPlan) {
      $item.orchestrationPlan.PSObject.TypeNames.Insert(0, 'Team.OrchestrationPlan')
   }
}

function _applyArtifactTypes {
   $item.PSObject.TypeNames.Insert(0, "Team.Build.Artifact")

   if ($item.PSObject.Properties.Match('resource').count -gt 0 -and $null -ne $item.resource -and $item.resource.PSObject.Properties.Match('propeties').count -gt 0) {
      $item.resource.PSObject.TypeNames.Insert(0, 'Team.Build.Artifact.Resource')
      $item.resource.properties.PSObject.TypeNames.Insert(0, 'Team.Build.Artifact.Resource.Properties')
   }
}

function _applyTypesToAzureSubscription {
   param($item)

   $item.PSObject.TypeNames.Insert(0, 'Team.AzureSubscription')
}

function _applyTypesToPolicy {
   param($item)

   $item.PSObject.TypeNames.Insert(0, 'Team.Policy')
}

function _applyTypesToPolicyType {
   param($item)

   $item.PSObject.TypeNames.Insert(0, 'Team.PolicyType')
}

function _applyTypesToPullRequests {
   param($item)

   $item.PSObject.TypeNames.Insert(0, 'Team.PullRequest')
}

function _applyTypesToRelease {
   param($item)

   $item.PSObject.TypeNames.Insert(0, 'Team.Release')

   if ($item.PSObject.Properties.Match('environments').count -gt 0 -and $null -ne $item.environments) {
      foreach ($e in $item.environments) {
         $e.PSObject.TypeNames.Insert(0, 'Team.Environment')
      }
   }

   $item._links.PSObject.TypeNames.Insert(0, 'Team.Links')
   $item._links.self.PSObject.TypeNames.Insert(0, 'Team.Link')
   $item._links.web.PSObject.TypeNames.Insert(0, 'Team.Link')
}

function _applyTypesToServiceEndpoint {
   param($item)

   $item.PSObject.TypeNames.Insert(0, 'Team.ServiceEndpoint')

   $item.createdBy.PSObject.TypeNames.Insert(0, 'Team.User')
   $item.authorization.PSObject.TypeNames.Insert(0, 'Team.authorization')
   $item.data.PSObject.TypeNames.Insert(0, 'Team.ServiceEndpoint.Details')

   if ($item.PSObject.Properties.Match('operationStatus').count -gt 0 -and $null -ne $item.operationStatus) {
      # This is VSTS
      $item.operationStatus.PSObject.TypeNames.Insert(0, 'Team.OperationStatus')
   }
}

function _applyTypesToServiceEndpointType {
   param($item)

   $item.PSObject.TypeNames.Insert(0, 'Team.ServiceEndpointType')

   $item.inputDescriptors.PSObject.TypeNames.Insert(0, 'Team.InputDescriptor[]')

   foreach ($inputDescriptor in $item.inputDescriptors) {
      $inputDescriptor.PSObject.TypeNames.Insert(0, 'Team.InputDescriptor')
   }

   $item.authenticationSchemes.PSObject.TypeNames.Insert(0, 'Team.AuthenticationScheme[]')

   foreach ($authenticationScheme in $item.authenticationSchemes) {
      $authenticationScheme.PSObject.TypeNames.Insert(0, 'Team.AuthenticationScheme')
   }

   if ($item.PSObject.Properties.Match('dataSources').count -gt 0 -and $null -ne $item.dataSources) {
      $item.dataSources.PSObject.TypeNames.Insert(0, 'Team.DataSource[]')

      foreach ($dataSource in $item.dataSources) {
         $dataSource.PSObject.TypeNames.Insert(0, 'Team.DataSource')
      }
   }
}

function _applyTypesToVariableGroup {
   param($item)

   $item.PSObject.TypeNames.Insert(0, 'Team.VariableGroup')

   $item.createdBy.PSObject.TypeNames.Insert(0, 'Team.User')
   $item.modifiedBy.PSObject.TypeNames.Insert(0, 'Team.User')
   if ($item.PSObject.Properties.Match('providerData').count -gt 0 -and $null -ne $item.providerData) {
      $item.providerData.PSObject.TypeNames.Insert(0, 'Team.ProviderData')
   }
   $item.variables.PSObject.TypeNames.Insert(0, 'Team.Variables')
}

function _applyTypesToYamlPipelineResultType {
   param($item)

   $item.PSObject.TypeNames.Insert(0, 'Team.YamlPipelineResult')
}

function _applyTypesToBuildTimelineResultType {
   param($item)

   $item.PSObject.TypeNames.Insert(0, 'Team.BuildTimeline')

   if ($item.PSObject.Properties.Match('records').count -gt 0 -and $null -ne $item.records) {
      $item.records.PSObject.TypeNames.Insert(0, 'Team.BuildTimelineRecord[]')

      foreach ($records in $item.records) {
         $records.PSObject.TypeNames.Insert(0, 'Team.BuildTimelineRecord')
      }
   }
}
